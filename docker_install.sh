#!/bin/bash

set -euo pipefail

DOCKER_COMPOSE_VERSION="v2.24.6"

# Install gum
install_gum() {
  sudo apt-get update > /dev/null
  sudo apt-get install -y curl jq git
  sudo mkdir -p /etc/apt/keyrings > /dev/null
  curl -fsSL https://repo.charm.sh/apt/gpg.key | sudo gpg --dearmor -o /etc/apt/keyrings/charm.gpg
  echo "deb [signed-by=/etc/apt/keyrings/charm.gpg] https://repo.charm.sh/apt/ * *" | sudo tee /etc/apt/sources.list.d/charm.list > /dev/null
  sudo apt-get update > /dev/null
  sudo apt-get install -y gum
}

# Install docker
install_docker() {
  sudo apt-get update > /dev/null
  sudo apt-get install -y curl
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
  echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
  sudo apt-get update > /dev/null
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io
  gum style --foreground 2 --align left --margin "1 1" "Done! $(docker --version)"
}

# Install docker-compose
install_compose() {
  gum style --foreground 2 --align left --margin "2 2" "Installing docker-compose..."
  curl -sL https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-linux-x86_64 -o docker-compose
  chmod +x docker-compose
  sudo mv docker-compose /usr/local/bin
  gum style --foreground 2 --align left --margin "1 1" "Done! Docker-compose version: $(docker-compose --version | cut -d ' ' -f 4)"
}


# Update docker-compose
update_compose() {
  curl -sL https://github.com/docker/compose/releases/download/$DOCKER_COMPOSE_VERSION/docker-compose-linux-x86_64 -o docker-compose
  chmod +x docker-compose
  sudo mv docker-compose /usr/local/bin
  gum style --foreground 2 --align left --margin "1 1" "Done! Docker-compose version: $(docker-compose --version | cut -d ' ' -f 4)"
}


# Check gum
if [[ ! -x "$(command -v gum)" ]]; then
 install_gum
fi


# Title
gum style --foreground 2 --border-foreground 4 --border double --bold --align center --width 50 --margin "2 20" --padding "1 1" 'Docker installer' 'by Darksiders Staking'


# Check docker
if [[ ! -x "$(command -v docker)" ]]; then
  gum style --foreground 2 --align left --margin "1 1" "Docker not installed. Installing..."
  install_docker
else
  gum style --foreground 3 --align left --margin "0 1" "Docker installed. $(docker --version)"
fi

# Check docker-compose
if [[ ! -x "$(command -v docker-compose)" ]]; then
  gum style --foreground 2 --align left --margin "2 2" "Docker-compose doesn't exist. Installing docker-compose..."
  install_compose
elif [[ $(docker-compose --version | cut -d ' ' -f 4) != $DOCKER_COMPOSE_VERSION ]]; then
  gum style --foreground 2 --align left --margin "2 2" "Docker-compose version outdated. Updating docker-compose..."
  update_compose
else
  gum style --foreground 3 --align left --margin "0 1" "Docker-compose updated to last version: $(docker-compose --version | cut -d ' ' -f 4)"
fi
