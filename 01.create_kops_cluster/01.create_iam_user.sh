#!/bin/bash
####### Variables #########
KOPS_CLUSTER_NAME="kops.cluster.k8s.local"
KOPS_BUCKET_NAME="starlordkopsbucketbb"
KOPS_ZONE_NAME="eu-central-1a"

KOPS_USER_NAME="kopsBBUser-01"
KOPS_GROUP_NAME="kopsBBGroup-01"

LOG_FILE="kops_user_creation_logs_`date +%F`.txt"
KOPS_USER_KEYS="kops_user_access_keys.txt"


KOPS_USER_POLICIES=`cat <<EOF
AmazonEC2FullAccess
AmazonRoute53FullAccess
AmazonS3FullAccess
IAMFullAccess
AmazonVPCFullAccess
EOF`
echo "`date +%F-%T` Starting Script." >> ${LOG_FILE}

###########################

create_aws_user_group()
{
####### 01.Create Kops-User-Group   ########

	echo "`date +%F-%T` 01.Creating-Group" >> ${LOG_FILE}
	aws iam create-group --group-name ${KOPS_GROUP_NAME} >> ${LOG_FILE}

####### 02.Attach Policies to Group ########
	echo "`date +%F-%T` 02.Attaching Policies" >> ${LOG_FILE}
	for poli in `echo ${KOPS_USER_POLICIES}`
	do
		echo -e "`date +%F-%T` \t Attaching Policy ${poli}." >> ${LOG_FILE}
	        aws iam attach-group-policy --policy-arn arn:aws:iam::aws:policy/${poli} --group-name ${KOPS_GROUP_NAME} >> ${LOG_FILE}
	done



####### 03.Create Kops-User         ########
	echo "`date +%F-%T` 03.Creating-Kops-User" >> ${LOG_FILE}
	aws iam create-user --user-name ${KOPS_USER_NAME} >> ${LOG_FILE}

####### 04.Add Kops-User to Group   ########
	echo "`date +%F-%T` 04.Add Kops-User to Group" >> ${LOG_FILE}
	aws iam add-user-to-group --user-name ${KOPS_USER_NAME} --group-name ${KOPS_GROUP_NAME} >> ${LOG_FILE}

####### 05.Create Access-Key/Secret ########
	echo "`date +%F-%T` 05.Creating Access/Secret Keys" >> ${LOG_FILE}
	aws iam create-access-key --user-name ${KOPS_USER_NAME} >> ${KOPS_USER_KEYS}
	cat ${KOPS_USER_KEYS} >> ${LOG_FILE}

	clear
	echo -e "\n\n"
	echo -e "\t The User Access & Secret-Keys are in file ${LOG_FILE}."
	echo -e "\t Take a backup of file and don't loose them."
	cat figlet_ascii.txt
	echo -e "\n\n"
}


delete_aws_user_group()
{
############### DELETE USER/GROUP #############
#### 01.Detach Kops User/Group
	echo "`date +%F-%T` 01.DELETING Kops-Group" >> ${LOG_FILE}
	aws iam remove-user-from-group --user-name ${KOPS_USER_NAME} --group-name ${KOPS_GROUP_NAME} >> ${LOG_FILE}

#### 02.Detach Policies from Kops-Group
echo "`date +%F-%T` 02.Detaching Policies from Kops-Group" >> ${LOG_FILE}
for poli in `echo ${KOPS_USER_POLICIES}`
        do
                echo -e "`date +%F-%T` \t Detaching Policy ${poli}." >> ${LOG_FILE}
                aws iam detach-group-policy --policy-arn arn:aws:iam::aws:policy/${poli} --group-name ${KOPS_GROUP_NAME} >> ${LOG_FILE}
        done

#### 03. Delete Group 
	echo "`date +%F-%T` 03.DELETING Kops-Group" >> ${LOG_FILE}
        aws iam delete-group --group-name ${KOPS_GROUP_NAME} >> ${LOG_FILE}
#### 04. Delete Access-Key
	echo "`date +%F-%T` 04.DELETING ACCESS-Key" >> ${LOG_FILE}
ACCESS_KEY=`aws iam list-access-keys --user-name ${KOPS_USER_NAME} | jq -r '.AccessKeyMetadata[0].AccessKeyId'` >> ${LOG_FILE}
	aws iam delete-access-key --access-key ${ACCESS_KEY} --user-name ${KOPS_USER_NAME} >> ${LOG_FILE}	


#### 05. Delete User
	echo "`date +%F-%T` 05.DELETING Kops-User" >> ${LOG_FILE}
	aws iam delete-user --user-name ${KOPS_USER_NAME} >> ${LOG_FILE}

}

create_aws_s3_bucket()
{
	echo "`date +%F-%T` Creating AWS-S3-Bucket." >> ${LOG_FILE}
	aws s3 mb s3://${KOPS_BUCKET_NAME} >> ${LOG_FILE}
}

delete_aws_s3_bucket()
{
        echo "`date +%F-%T` Deleting AWS-S3-Bucket." >> ${LOG_FILE}
	aws s3 rb s3://${KOPS_BUCKET_NAME} >> ${LOG_FILE}
}


create_kops_cluster()
{
	echo "`date +%F-%T` Creating KOPS-Local-Cluster." >> ${LOG_FILE}
	export KOPS_STATE_STORE=s3://${KOPS_BUCKET_NAME}
	kops create cluster --name ${KOPS_CLUSTER_NAME} --state s3://${KOPS_BUCKET_NAME} --zones ${KOPS_ZONE_NAME} --yes
}

delete_kops_cluster()
{
	echo "`date +%F-%T` Deleting KOPS-Local-Cluster." >> ${LOG_FILE}
	export KOPS_STATE_STORE=s3://${KOPS_BUCKET_NAME}
	kops delete cluster --name ${KOPS_CLUSTER_NAME} --state s3://${KOPS_BUCKET_NAME} --yes	
}

main()
{
case "$1" in
create)
	create_aws_user_group 
	create_aws_s3_bucket
	create_kops_cluster
	;;
delete)
	delete_kops_cluster
	delete_aws_s3_bucket
	delete_aws_user_group 
	;;
*)
	clear
	cat figlet_attention.txt
	echo -e "\n"
	echo -e "\t Sorry, Check the usage of script."
	echo -e "\t Only delete/create arguements are allowed.\n"
	cat figlet_usage.txt
	echo -e "\n"
	exit
	;;
esac
}
usage()
{
	if [ "$#" -eq "1" ]
	then
		main $*
	else
		clear
		cat figlet_attention.txt
		echo -e "\n"
		echo -e "\n\t Script needs one arguement. Either delete or create."	
		echo -e "\t Usage $0 delete"
		echo -e "\t Usage $0 create\n"
		cat figlet_usage.txt
		echo -e "\n"
		exit	
	fi
}
usage $*
