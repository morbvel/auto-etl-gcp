#!/bin/bash
projectName=`gcloud config get-value project`

gcloud dataproc jobs submit spark \
  --region "europe-west2" \
  --cluster ${projectName}-cluster \
  --class "alaw.mot.lufc.groupid.WriteBigqueryTablesMain" \
  --jars "gs://packages-jar/write-bigquery-tables-0.1-SNAPSHOT-jar-with-dependencies.jar,gs://spark-lib/bigquery/spark-bigquery-latest.jar" \
  -- "uk_training_innovation_datasets.final_table_poc" "uk_training_innovation.final_table_poc"
