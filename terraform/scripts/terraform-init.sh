#!/usr/bin/env bash

set -o nounset
set -o errexit
set -o pipefail

function fn_usage() {
  echo
  echo "A wrapper for a \"terraform init\" command."
  echo
  echo "Usage: $0 [-h]"
  echo -e  "\033[1;36m""Options${COLOUR_OFF}"
  echo "-h             Show this usage message and exit"
  echo
}

function fn_fail_if_missing() {
  local message=$1
  local string=$2
  if [[ -z "${string}" ]]
  then
    echo -e "${RED}ERROR:${RESET} ${message}"
    exit 1
  fi
}

##### ENTRY
AWS_REGION="eu-west-2"
BACKEND_CONFIG_KEY="jobhunt2025"  # make this an option/positional argument if needed

BOLD="\033[1m"
GREEN="\033[1;32m"
RED="\033[1;31m"
RESET="\033[0m"

while getopts "h" opt; do
  case "${opt}" in
  h | \?)
    fn_usage
    exit 0
    ;;
  [?])
    shift
    ;;
  esac
done

fn_fail_if_missing "${BOLD}AWS_REGION${RESET} is not defined" "${AWS_REGION:-}"
fn_fail_if_missing "${BOLD}AWS_ACCESS_KEY_ID${RESET} is not defined" "${AWS_ACCESS_KEY_ID:-}"
fn_fail_if_missing "${BOLD}AWS_SECRET_ACCESS_KEY${RESET} is not defined" "${AWS_SECRET_ACCESS_KEY:-}"

ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
echo -e "Account id is ${GREEN}${ACCOUNT_ID}${RESET}"

terraform init -backend-config="bucket=${ACCOUNT_ID}-terraform-remote-state" \
  -backend-config="key=${BACKEND_CONFIG_KEY}/terraform.tfstate" \
  -backend-config="dynamodb_table=${ACCOUNT_ID}-terraform-remote-state" \
  -backend-config="encrypt=true" \
  -backend-config="region=${AWS_REGION}"