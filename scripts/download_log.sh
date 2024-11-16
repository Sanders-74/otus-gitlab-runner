#!/bin/bash

# Скачивание логов с сервера
server_logs_path="/var/log/setup_execution.log"

scp -i $PRIVATE_KEY ubuntu@$SERVER_IP:$server_log_path $PROJECT_LOGS_PATH/