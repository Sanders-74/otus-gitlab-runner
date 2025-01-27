#!/bin/bash
USER_NAME=$1
HOME=/home/${USER_NAME}

function log() {
    sep="----------------------------------------------------------"
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $sep " | tee -a $HOME/setup_execution.log
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] [INFO] $1" | tee -a $HOME/setup_execution.log
}

# Установка git и jq
log "Installing git and jq"
sudo apt-get --yes install git jq

# Установка gitlab-runner
log "Installing gitlab-runner"
curl --location https://packages.gitlab.com/install/repositories/runner/gitlab-runner/script.deb.sh | sudo bash
sudo apt-get --yes install gitlab-runner
