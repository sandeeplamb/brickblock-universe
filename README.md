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

* **[AWS CLI](https://aws.amazon.com/documentation/cli/)** to manage AWS resources
	* `pip install --upgrade --user awscli`
	* `aws configure`

* **[terraform](https://www.terraform.io/)** to create  AWS Services

* **[jq](https://stedolan.github.io/jq/)** to parse JSON results returned by the AWS CLI

* **[kops](https://github.com/kubernetes/kops/)** to create the Kubernetes cluster

* **[kubectl](https://kubernetes.io/)** to manage Kubernetes resources

## Steps to get Infinity Stone
1. Create KOPS Cluster. It consists of 3 steps. 
    1. Create separate User/Group and assign specific Policies in IAM with root user to administer the KOPS-Cluster.
    1. Create a S3 Bucket to store the state of the KOPS-Cluster.
    1. Create KOPS Cluster.
1. Create SELF-SIGNED Certificate for NGINX. This step is Optional.
1. Create Kubernetes Resources.

## Step-01-to-Infinity-Stone

Change directory `01.create_kops_user`.

I made a script which will Automate the creation of KOPS-Cluster.
The script will take one arguement either `create or delete`.

`create` arguement will create the AWS-IAM user, group, attaching policies and groups, AWS-S3 Bucket and KOPS-cluster for you.
`delete` arguement will delete the AWS-IAM user, group, attaching policies and groups, AWS-S3 Bucket and KOPS-cluster for you.

In the script, there are HARD-CODED variables. 
If you wish to change them,like Bucket-Name, Cluster-Name, Region, you can changed directly into the script.

```
#!/bin/bash
####### Variables #########
KOPS_CLUSTER_NAME="kops.cluster.k8s.local"
KOPS_BUCKET_NAME="starlordkopsbucketbb"
KOPS_ZONE_NAME="eu-central-1a"

KOPS_USER_NAME="kopsBBUser-01"
KOPS_GROUP_NAME="kopsBBGroup-01"

LOG_FILE="kops_user_creation_logs_`date +%F`.txt"
KOPS_USER_KEYS="kops_user_access_keys.txt"
```


**See it, To Believe it**

<p align="center">
  <a href="https://asciinema.org/a/iOhpvJQnxi37c7xWEqnw0v7kl?speed=3">
  <img src="https://asciinema.org/a/iOhpvJQnxi37c7xWEqnw0v7kl.png" width="885"></image>
  </a>
</p>

## Step-02-to-Infinity-Stone
**Create the Self-Signed-Certificate/Optional-Step**

Change directory `03.create_nginx_cert`.

We create the self-signed certificate to handle HTTPS.
Yes, its not secure but the `TASK have an additional cookie` if you made your cluster app running over HTTPS.
Script `01.create_cert.sh` will create the cert and key which is `WILDCARD Certificate` for domain ending with `*.k8s.local`.

**See it, To Believe it**

<p align="center">
  <a href="https://asciinema.org/a/1Z2t6t7oUFc9usdCaBgI2cPlz">
  <img src="https://asciinema.org/a/1Z2t6t7oUFc9usdCaBgI2cPlz.png" width="885"></image>
  </a>
</p>

## Step-03-to-Infinity-Stone
**Create the Kubernetes Resources**

Change directory `04.create_k8s_resources`.

I have created the Kubernetes Resource `YAML` files for FrontEnd API Consumer i.e. Nginx, BackEnd Node, Database DB, HPA and Heapster.

**Keep-In-Mind**

* The ConfigMap for nginx default.conf file, we need to change the service name of backend-app. In our case, it is `my-emp`.
* Check file `01.create_nginx_config_maps.yaml` i.e. `proxy_pass http://my-emp`.
* No need to change other configMaps.
* For HPA or autoscaling, please make sure that `Heapster` Pod is running to collect metrics.
* Order of execution of K8s resources is important. So, follow the commands as given below in video.

**See it, To Believe it**

<p align="center">
  <a href="https://asciinema.org/a/nNzSpDxECHgjWMLaUanm423rK?speed=3">
  <img src="https://asciinema.org/a/nNzSpDxECHgjWMLaUanm423rK.png" width="885"></image>
  </a>
</p>


## Bonus-From-Star-Lord

**To check if Horizontal Scaling is working**

We have deployed HPA for NGINX and MY-APP.
Let see if we load the server, PODS will scale or not.

You need to run the below POD and query in separate terminal and then check what happens to our NGINX and APP resources.

```
star-lord@Guardian:05.create_load$ `kubectl run -i --tty load-generator --image=busybox /bin/sh`
If you don't see a command prompt, try pressing enter.
/ # `while true; do wget -q -O- --header "empid: 12345" --header "Content-Type: application/x-www-form-urlencoded" http://nginx-for-bb.def
ault.svc.cluster.local/GetEmployee; done`
```

**See it, To Believe it**

<p align="center">
  <a href="https://asciinema.org/a/asWAqOSTZbL5TJK2Eaa83pVEH?speed=2">
  <img src="https://asciinema.org/a/asWAqOSTZbL5TJK2Eaa83pVEH.png" width="885"></image>
  </a>
</p>


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

