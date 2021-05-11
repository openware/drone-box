#!/bin/bash -x

COMPOSE_VERSION="1.25.5"
COMPOSE_URL="https://github.com/docker/compose/releases/download/$COMPOSE_VERSION/docker-compose-$(uname -s)-$(uname -m)"

# Opendax bootstrap script
install_core() {
  sudo bash <<EOS
apt-get update
apt-get install -y -q git tmux dbus htop curl build-essential
EOS
}

log_rotation() {
  sudo bash <<EOS
mkdir -p /etc/docker
echo '
{
  "log-driver": "json-file",
  "log-opts": {
    "max-size": "10m",
    "max-file": "10"
  }
}' > /etc/docker/daemon.json
EOS
}

# Docker installation
install_docker() {
  curl -fsSL https://get.docker.com/ | bash
  sudo bash <<EOS
usermod -a -G docker $USER
curl -L "$COMPOSE_URL" -o /usr/local/bin/docker-compose
chmod +x /usr/local/bin/docker-compose
EOS
}

deploy() {
  sudo -u deploy bash <<EOS
  cd /home/deploy/platform
  touch config/acme.json
  chmod 0600 config/acme.json
  docker-compose up -d
EOS
}

install_core
log_rotation
install_docker
deploy
