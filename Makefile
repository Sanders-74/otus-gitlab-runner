SHELL := /bin/bash
.SHELLFLAGS := -eu -o pipefail -c

include .env

.ONESHELL:
.EXPORT_ALL_VARIABLES:

download-log:
	bash scripts/download_log.sh

check-projects:
	python3 src/check_projects.py

check-runners:
	python3 src/check_runners.py

plan:
	cd infra && terraform plan

apply:
	cd infra && terraform apply -auto-approve

destroy:
	cd infra && terraform destroy -auto-approve
