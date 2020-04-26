#!/bin/bash

region="us-east1"
machineType="n1-standard-1"
diskSize="15"
numWorkers="2"

if [-nz $1]; then
  region=$1
fi

if [-nz $2]; then
  machineType=$2
fi

if [-nz $3]; then
  diskSize=$3
fi

if [-nz $4]; then
  numWorkers=$4
fi

projectName=`gcloud config get-value project`
fullName=`gcloud config get-value account`

IFS='@' # space is set as delimiter
read -ra ADDR <<< "$fullName" # str is read into an array as tokens separated by IFS
userName=${ADDR[0]}

gcloud dataproc clusters create ${projectName}-${userName}-cluster\
    --region ${region} \
    --zone ${region}-d \
    --master-machine-type ${machineType} \
    --master-boot-disk-size ${diskSize} \
    --num-workers ${numWorkers} \
    --worker-machine-type ${machineType} \
    --worker-boot-disk-size ${diskSize} \
    --project ${projectName}
    #--initialization-actions
