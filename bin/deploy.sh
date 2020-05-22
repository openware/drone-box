#!/usr/bin/env bash

set -e

KEY_FILE="./config/secrets/deploy.key"

if [ ! -f ${KEY_FILE} ]; then
  echo "Generating the ${KEY_FILE} RSA key"
  ssh-keygen -b 4096 -t rsa -C deploy@platform -f ${KEY_FILE} -q -N ""
fi

terraform init ./terraform
terraform apply -var-file config/terraform.tfvars ./terraform
