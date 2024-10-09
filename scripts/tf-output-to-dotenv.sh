#!/bin/bash

set -euo pipefail

DOTENV_DIR=${DOTENV_DIR:-./tmp}
DOTENV_PATH=${DOTENV_DIR}/.env

mkdir -p ${DOTENV_DIR}

TF_OUTPUT=$(cd ./infra && terraform output --json)


cat <<EOF >> ${DOTENV_PATH}
AZURE_APPLICATION_CLIENT_ID=$(echo "${TF_OUTPUT}" | jq -r '.azure_application_client_id.value')
AZURE_APPLICATION_PASSWORD=$(echo "${TF_OUTPUT}" | jq -r '.azure_application_password.value')
AZURE_TENANT_ID=$(echo "${TF_OUTPUT}" | jq -r '.azure_tenant_id.value')
EOF

echo "${DOTENV_PATH} created"
