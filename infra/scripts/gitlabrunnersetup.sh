#!/bin/bash
source ../../.env

set -e
# Установка docker
ssh ${USER_NAME}@${SERVER_IP} 'bash -s' < ./installDocker.sh $USER_NAME

# Установка git, jq, gitlab-runner
ssh ${USER_NAME}@${SERVER_IP} 'bash -s' < ./installSoft.sh $USER_NAME

# Регистрация проектного gitlab-runner 
GITLAB_REGISTRATION_TOKEN=$REGISTRATION_TOKEN_PROJECT
ssh ${USER_NAME}@${SERVER_IP} 'bash -s' < ./registerGLRunner.sh $USER_NAME $GITLAB_URL $GITLAB_REGISTRATION_TOKEN

# Регистрация инстансного gitlab-runner 
GITLAB_REGISTRATION_TOKEN=$REGISTRATION_TOKEN_INSTANCE
ssh ${USER_NAME}@${SERVER_IP} 'bash -s' < ./registerGLRunner.sh $USER_NAME $GITLAB_URL $GITLAB_REGISTRATION_TOKEN

# Запуск gitlab-runner
echo "Starting gitlab-runner"
ssh ${USER_NAME}@${SERVER_IP} 'sudo systemctl start gitlab-runner'

echo "Setup script execution completed"