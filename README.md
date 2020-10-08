# Openware Drone CI Box

This repository is used to quickly deploy Drone CI instances by utilizing GCP, Terraform and Compose.

The deployment includes:
  * Terraform configs for a VM and related network configs
  * Docker and Compose installation
  * Traefik, and Drone CI compose files

## Getting started with Drone CI Box


### 1. Terraform configurations


1.1. Modify `config/terraform.tfvars` file with the correct values of your gcp project. Do not touch the section, related to ssh keys.

### 2. Drone CI configuration


2.1. Modify `compose/drone.yaml` file with the correct values, meaning of each variable can be found in [Drone CI documentation ](https://docs.drone.io/).


### 3. Drone installation

3.1. Run `./bin/deploy.sh` from the root of drone-box repo to generate ssh, initialise and apply terraform.

3.2 Take an external IP of the created VM instance and point drone server domain name to it.

3.3. Run `./bin/install.sh` from the root of drone-box repo to install the drone to the created VM instance.
