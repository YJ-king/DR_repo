#!/bin/bash

export DB_NAME=petclinic
export DB_USER=petuser
export DB_PASSWORD=petpass1234
export RDS_ENDPOINT_FULL=$(terraform -chdir=../infra/dr_terraform/envs output -raw rds_endpoint)
export RDS_HOST=${RDS_ENDPOINT_FULL%%:*}

envsubst < restore-job.yaml.tpl > restore-job.yaml
kubectl apply -f restore-job.yaml

