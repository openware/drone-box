# Openware Drone CI Box

This repository is used to quickly deploy Drone CI instances by utilizing GCP, Terraform and Compose.

The deployment includes:
  * Terraform configs for a VM and related network configs
  * Docker and Compose installation
  * Traefik and Drone CI compose files

## Usage

The deployment flow is as follows:
1. [Create](https://docs.github.com/en/developers/apps/creating-an-oauth-app) a Github OAuth app for Drone, setting the callback URL to `https://*domain*/login`
2. Modify `config/*cloud*.tfvars` file with the correct values of your gcp project.
3. Fill out `.env` with the correct values
   |Variable|Description|
   |---|---|
   |POSTGRES_USER|PostgreSQL database user|
   |POSTGRES_PASS|PostgreSQL database password|
   |DRONE_SECRET|Randonly generated secret string(at least 32 characters)|
   |DRONE_RPC_SECRET|Randonly generated RPC secret string(at least 32 characters)|
   |DRONE_SERVER_HOST|Drone CI server host(excluding the protocol)|
   |DRONE_GITHUB_CLIENT_ID|Github OAuth app client ID|
   |DRONE_GITHUB_CLIENT_SECRET|Github OAuth app client secret|
   |DRONE_GITHUB_ADMIN_USER|Github username of the initial admin user|

   You can find Drone CI configuration reference [here](https://docs.drone.io/server/provider/github/).
4. Run `./bin/deploy.sh *cloud*` from the root of the repo to generate SSH keys, initialize and apply Terraform configuration.
5. Take an external IP of the created VM instance and point the domain name there.
6. Try accessing the deployment URL and connect to the resulting VM by SSH to check if all components are up and running.
