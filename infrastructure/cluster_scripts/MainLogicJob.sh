#!/bin/bash
projectName=`gcloud config get-value project`

gcloud dataproc jobs submit spark \
  --region "europe-west2" \
  --cluster ${projectName}-cluster \
  --class "alaw.mot.lufc.groupid.SampleEtlMain" \
  --jars "gs://packages-jar/sample-etl-1.0-SNAPSHOT.jar"
