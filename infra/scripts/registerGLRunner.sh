#!/bin/bash
USER_NAME=$1
HOME=/home/${USER_NAME}
gitlab_url=$2
gitlab_registration_token=$3

function log() {
    sep="----------------------------------------------------------"
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $sep " | tee -a $HOME/setup_execution.log
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] [INFO] $1" | tee -a $HOME/setup_execution.log
}

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
