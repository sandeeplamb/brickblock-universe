<p align="center">
  <img src="img/k8s-aws.png"> </image>
</p>


# brickblock-galaxy
Easter-Sunday-Treat-by-Star-Lord-from-KnowWhere.

## The Goal
To solve the problem mentioned by [brickblock-challenge-devops](https://github.com/brickblock-io/coding-challenge-devops).

## Difficulty Level
`Saving Galaxy was much Easier.`

## Architecture

Architecture created using site [DRAW.IO](https://www.draw.io/).

The XML file for below architecture is present in `img directory`.

<p align="center">
  <img src="img/sector-1.0-brick-block.png"> </image>
</p>

## Pre-requisites

* Install KUBECTL [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/).
* Export k8s-Cluster Name in NAME variable in shell. `export NAME=YOUR_CLUSTER_NAME`.
* Export KOPS_STATE_STORE variable in shell. `export KOPS_STATE_STORE=s3://YOUR_BUCKET_NAME`.
* If don’t want to use env variables. You can define the values using the `–name` and `–state` flags in kops command. 

## Steps to get Infinity Stone
1. Create KOPS CLuster. It consists of 3 steps. 
    1. Separate User/Group and assign specific Policies in IAM with root user to administer the KOPS-Cluster.
    1. Create a S3 Bucket to store the state of the KOPS-Cluster.
    1. Create KOPS Cluster.
1. Create SELF-SIGNED Certificate for NGINX. This step is Optional.
1. Create Kubernetes Resources.

## Step-01-to-Infinity-Stone

Change directory `01.create_kops_user`.

I made a script which will Automate the creation and deletion of Group, User, attach Policies and Users to Group.
The script will take one arguement either `create or delete`.

You can not run script with any other random arguement or more than one arguement.

`create` arguement will create the user, group, attaching policies and groups for you.
`delete` arguement will delete the user, group, attaching policies and groups for you.

**See it, To Believe it**


## Step-02-to-Infinity-Stone
**Create the Self-Signed-Certificate/Optional-Step**

Change directory `04.create_nginx_cert`.

We create the self-signed certificate to handle HTTPS.
Yes, its not secure but the `TASK have an additional cookie` if you made your cluster app running over HTTPS.
Script `01.create_cert.sh` will create the cert and key which is `WILDCARD Certificate` for domain ending with `*.k8s.local`.

**See it, To Believe it**

## Step-03-to-Infinity-Stone
**Create the Kubernetes Resources**

Change directory `05.create_k8s_resources`.

I have created the Kubernetes Resource `YAML` files for FrontEnd API Consumer i.e. Nginx, BackEnd Node App and Database DB.

**Keep-In-Mind**

* The ConfigMap for nginx default.conf file, we need to change the service name of backend-app. In our case, it is `my-emp`.
* Check file `01.create_nginx_config_maps.yaml` i.e. `proxy_pass http://my-emp`.
* No need to change other configMaps.
* For HPA or autoscaling, please make sure that `Heapster` Pod is running to collect metrics.

**See it, To Believe it**


# Tasks Completion Matrix

|Tasks                                               | Comments                                                |
|--------------------------------------------- |---------------------------------------------------------------|
|**`Acceptance Criteria`**                                          |                                                                    |
|01. K8s Cluster Up and Running                                    | Finished                                                    |
|02. FrontEnd Application Running and Accessible     | Finished                                                    |
|03. FrontEnd Displays Data from API                            |  Finished                                                   |
|04. Code Accessible in GIT                                              | Finished                                                     |
|**`Bonus Round`**                                                      |                                                                      |
|01. HTTPS                                                                          | **`Self-Signed-Cert`**                          |
|02. Automate the Cluster                                               | Finished                                                       |
|03. Auto-Scaling                                                               | Finished                                                       |
|04. API Hooked to Database                                         | Finished                                                        |
|05. Isolated Staging/Production                                   | **`Only Staging`**                                 |

