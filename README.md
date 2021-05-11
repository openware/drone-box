# Openware Drone CI Box

This repository is used to quickly deploy Drone CI instances by utilizing GCP, Terraform and Compose.

The deployment includes:
  * Terraform configs for a VM and related network configs
  * Docker and Compose installation
  * Traefik and Drone CI compose files

## Usage

The deployment flow is as follows:
1. Modify `config/*cloud*.tfvars` file with the correct values of your gcp project.
2. Modify `compose/drone.yaml` file with the correct values, meaning of each variable can be found in [Drone CI documentation ](https://docs.drone.io/).
3. Run `./bin/deploy.sh *cloud*` from the root of the repo to generate SSH keys, initialize and apply Terraform configuration.
4. Take an external IP of the created VM instance and point the domain name there.
5. Try accessing the deployment URL and connect to the resulting VM by SSH to check if all components are up and running.
