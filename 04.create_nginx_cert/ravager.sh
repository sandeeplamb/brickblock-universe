#!/bin/bash


#### Function Create KOPS
create_kops ()
{
	cd 01.create_kops_user
	/bin/sh ./01.create_iam_user.sh create
	NEW_USER_ACCESS_KEY=`cat kops_user_access_keys.txt | jq -r '.AccessKey.AccessKeyId'`
        NEW_USER_SECRET_KEY=`cat kops_user_access_keys.txt | jq -r '.AccessKey.SecretAccessKey'`
        NEW_USER_REGION="eu-central-1"

	aws configure set aws_access_key_id "${NEW_USER_ACCESS_KEY}"
	aws configure set aws_secret_access_key "${NEW_USER_SECRET_KEY}"
	aws configure set region "${NEW_USER_REGION}"
exit
}


#### Function Delete KOPS
delete_kops ()
{
exit
}

#### Function Main
main()
{
case "$1" in
create)
        create_kops ;;
delete)
        delete_kops ;;
*)
        clear
        echo -e "\n"
        echo -e "\t Sorry, Check the usage of script."
        echo -e "\t Only delete/create arguements are allowed.\n"
        echo -e "\n"
        exit
        ;;
esac
}


#### Function Usage
usage()
{
        if [ "$#" -eq "1" ]
        then
                main $*
        else
                clear
                echo -e "\n"
                echo -e "\n\t Script needs one arguement. Either delete or create."
                echo -e "\t Usage $0 delete"
                echo -e "\t Usage $0 create\n"
                echo -e "\n"
                exit
        fi
}
usage $*
