#!/bin/bash
region="us-east1"

if [ ! -z $1 ]; then
  region=$1
fi

projectName=`gcloud config get-value project`
fullName=`gcloud config get-value account`

IFS='@' # space is set as delimiter
read -ra ADDR <<< "$fullName" # str is read into an array as tokens separated by IFS
userName=${ADDR[0]}

gcloud dataproc clusters delete ${projectName}-${userName}-cluster --region ${region}
