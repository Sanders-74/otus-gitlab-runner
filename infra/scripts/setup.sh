#!/bin/bash

# Функция для логирования

HOME=/home/${user_name}

function log() {
    sep="----------------------------------------------------------"
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $sep " | tee -a $HOME/setup_execution.log
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] [INFO] $1" | tee -a $HOME/setup_execution.log
}

log "Starting setup script execution"

# Установка docker
log "Installing docker"
sudo apt-get update
sudo apt-get install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt-get update
sudo apt-get install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker ${user_name}

# Установка git и jq
log "Installing git and jq"
sudo apt-get --yes install git jq

# Установка gitlab-runner
log "Installing gitlab-runner"
curl --location https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash
sudo apt-get --yes install gitlab-runner

# Регистрация gitlab-runner
log "Registering gitlab-runner"
sudo gitlab-runner register \
  --non-interactive \
  --url ${gitlab_url} \
  --registration-token ${gitlab_registration_token} \
  --executor docker \
  --description "docker-runner" \
  --docker-image python:3.11.4-slim-buster \
  --tag-list 'docker' \
  --run-untagged="true" \
  --locked="false" \
  --access-level="not_protected"

# Запуск gitlab-runner
log "Starting gitlab-runner"
sudo gitlab-runner start > /dev/null 2>&1

log "Setup script execution completed"