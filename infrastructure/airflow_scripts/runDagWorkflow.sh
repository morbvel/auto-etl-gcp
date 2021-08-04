#!/bin/bash

gcloud composer environments run poc-dags	\
  --location europe-west2 trigger_dag -- uk_training_innovation_dag
