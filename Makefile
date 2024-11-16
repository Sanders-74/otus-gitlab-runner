SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c

include .env

.ONESHELL:
.EXPORT_ALL_VARIABLES:

download_log:
	bash scripts/download_log.sh

check_projects:
	python3 src/check_projects.py

check_runners:
	python3 src/check_runners.py