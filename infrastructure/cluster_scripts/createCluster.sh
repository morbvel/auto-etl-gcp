#!/bin/bash

region="europe-west2"
machineType="n1-standard-1"
diskSize="15"
numWorkers="3"

if [ ! -z $1 ]; then
  region=$1
fi

if [ ! -z $2 ]; then
  machineType=$2
fi

if [ ! -z $3 ]; then
  diskSize=$3
fi

if [ ! -z $4 ]; then
  numWorkers=$4
fi

projectName=`gcloud config get-value project`
fullName=`gcloud config get-value account`

IFS='@' # space is set as delimiter
read -ra ADDR <<< "$fullName" # str is read into an array as tokens separated by IFS
userName=${ADDR[0]}

#Enable Cloud SQL Admin API
gcloud dataproc clusters create ${projectName}-cluster\
    --region ${region} \
    --zone ${region}-a \
    --bucket "datalake-warehouse" \
    --master-machine-type ${machineType} \
    --master-boot-disk-size ${diskSize} \
    --num-workers ${numWorkers} \
    --worker-machine-type ${machineType} \
    --worker-boot-disk-size ${diskSize} \
    --project ${projectName} \
    --scopes sql-admin,bigquery \
    --image-version 1.4 \
    --initialization-actions gs://goog-dataproc-initialization-actions-${region}/cloud-sql-proxy/cloud-sql-proxy.sh \
    --properties hive:hive.metastore.warehouse.dir=gs://datalake-warehouse/ \
    --metadata enable-cloud-sql-proxy-on-workers=false \
    --metadata "hive-metastore-instance=uk-training-innovation:${region}:hive-metastore" \
