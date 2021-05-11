#!/usr/bin/env bash

set -e

KEY_DIR="./config/secrets"
KEY_FILE="${KEY_DIR}/deploy.key"

if [ -z "$1" ]
then
  echo -e "Cloud name is not set!\nUsage: deploy.sh aws|gcp"
  exit
fi

if [ ! -f ${KEY_FILE} ]; then
  mkdir -p ${KEY_DIR}
  echo "Generating the ${KEY_FILE} RSA key"
  ssh-keygen -b 4096 -t rsa -C deploy@platform -f ${KEY_FILE} -q -N ""
fi

terraform init ./terraform/$1
terraform apply -var-file config/$1.tfvars ./terraform/$1
