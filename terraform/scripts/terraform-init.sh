#!/usr/bin/env bash

set -o nounset
set -o errexit
set -o pipefail

function fn_usage() {
  echo
  echo "A wrapper for a \"terraform init\" command. S3 remote state is used with"
  echo "DynamoDB state locking. The AWS region is ${AWS_REGION}."
  echo
  echo "Usage: $0 [-h] KEY"
  echo
  echo -e  "${CYAN}Options${RESET}"
  echo "  -d       \"Dry Run\" - show but do not execute the \"terraform init\" command"
  echo "  -h       Show this usage message and exit"
  echo
  echo -e "${CYAN}Positional arguments${RESET}"
  echo -e "  ${BOLD}KEY${RESET}      Key for Terraform remote state (S3 folder/DynamoDB item)"
  echo
}

function fn_fail_if_unset() {
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

BOLD="\033[1m"
CYAN="\033[1;36m"
GREEN="\033[1;32m"
RED="\033[1;31m"
YELLOW='\033[0;33m'
RESET="\033[0m"

dryrun=false
while getopts "dh" opt; do
  case "${opt}" in
  d)
    dryrun=true
    ;;
  h | \?)
    fn_usage
    exit 0
    ;;
  [?])
    shift
    ;;
  esac
done

# The remote state key is a mandatory argument
shift $((OPTIND - 1))
if [ $# -ne 1 ]
then
  echo -e  "${RED}ERROR${RESET} A name for the remote state key is required!"
  echo     "Use the \"-h\" option to view the usage message."
  exit 1
fi
remote_state_key="$1"

# AWS programmatic credentials
fn_fail_if_unset "${BOLD}AWS_ACCESS_KEY_ID${RESET} is not defined" "${AWS_ACCESS_KEY_ID:-}"
fn_fail_if_unset "${BOLD}AWS_SECRET_ACCESS_KEY${RESET} is not defined" "${AWS_SECRET_ACCESS_KEY:-}"

ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
echo -e "Account id is ${GREEN}${ACCOUNT_ID}${RESET}"
echo

if [ "${dryrun}" = true ]
then
  echo "This script is running in \"Dry Run\" mode. This command would have otherwise been executed:"
  echo -e "${YELLOW}terraform init \\ \n\
  -backend-config=\"bucket=${ACCOUNT_ID}-terraform-remote-state\" \\ \n\
  -backend-config=\"key=${remote_state_key}/terraform.tfstate\" \\ \n\
  -backend-config=\"dynamodb_table=${ACCOUNT_ID}-terraform-remote-state\" \\ \n\
  -backend-config=\"region=${AWS_REGION}\" \\ \n\
  -backend-config=\"encrypt=true\"\n\
  ${RESET}"
else
  terraform init -backend-config="bucket=${ACCOUNT_ID}-terraform-remote-state" \
    -backend-config="key=${remote_state_key}/terraform.tfstate"                \
    -backend-config="dynamodb_table=${ACCOUNT_ID}-terraform-remote-state"      \
    -backend-config="region=${AWS_REGION}"                                     \
    -backend-config="encrypt=true"
fi

  exit 0