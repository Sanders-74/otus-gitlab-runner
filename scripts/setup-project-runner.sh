#!/bin/bash

# Функция вывода помощи
usage() {
    echo "Usage: $0 [OPTIONS]"
    echo "Required options:"
    echo "  -u, --user         Username"
    echo "  -g, --gitlab-url   GitLab URL"
    echo "  -t, --token        GitLab registration token"
    echo
    echo "Optional options:"
    echo "  -d, --docker-image Docker image (default: python:3.11.4-slim-buster)"
    echo "  -h, --help         Show this help message"
    echo
    echo "Example: $0 -u john -g https://gitlab.com -t token123"
    exit 1
}

# Значения по умолчанию
DOCKER_IMAGE="python:3.11.4-slim-buster"

# Парсинг аргументов
while [[ $# -gt 0 ]]; do
    case $1 in
        -u|--user)
            user_name="$2"
            shift 2
            ;;
        -g|--gitlab-url)
            gitlab_url="$2"
            shift 2
            ;;
        -t|--token)
            gitlab_registration_token="$2"
            shift 2
            ;;
        -d|--docker-image)
            DOCKER_IMAGE="$2"
            shift 2
            ;;
        -h|--help)
            usage
            ;;
        *)
            echo "Unknown parameter: $1"
            usage
            ;;
    esac
done

# Проверка обязательных параметров
if [ -z "$user_name" ] || [ -z "$gitlab_url" ] || [ -z "$gitlab_registration_token" ]; then
    echo "Error: Missing required parameters!"
    usage
fi

HOME=/home/${user_name}

# Функция для логирования
function log() {
    sep="----------------------------------------------------------"
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] $sep " | tee -a $HOME/setup_project_runner.log
    echo "[$(date +'%Y-%m-%d %H:%M:%S')] [INFO] $1" | tee -a $HOME/setup_project_runner.log
}

log "Starting setup script execution"
log "Parameters:"
log "User: ${user_name}"
log "GitLab URL: ${gitlab_url}"
log "Docker Image: ${DOCKER_IMAGE}"

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
  --docker-image ${DOCKER_IMAGE} \
  --tag-list 'project-runners' \
  --run-untagged="true" \
  --locked="false" \
  --access-level="not_protected"

# Запуск gitlab-runner
log "Starting gitlab-runner"
sudo gitlab-runner start > /dev/null 2>&1

log "Setup script execution completed"