#!/usr/bin/env bash

set -o nounset
set -o errexit
set -o pipefail

function fn_usage() {
  echo
  echo "Apply the Terraform plan. No arguments - configuration is driven by environment"
  echo "variables."
  echo
  echo -e  "${CYAN}Options${RESET}"
  echo -e "  ${YELLOW}-h${RESET}    ${BOLD}Show this usage message and exit${RESET}"
  echo
  echo -e "The optional ${YELLOW}\"TF_EXTRA_VARS\"${RESET} environment variable is passed into the plan."
  echo
  echo -e "${BOLD}IMPORTANT${RESET} The script checks that these environment variables are defined:"
  echo -e "  ${BOLD}TERRAFORM_PLAN_FILE${RESET}  Terraform plan, e.g. \"plan.cache\""
  echo
  echo "The following environment variables - if defined - will manage the outputs"
  echo "of this script:"
  echo "  TERRAFORM_CURRENT_STATE - Human readable file containing current Terraform state"
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
BOLD="\033[1m"
CYAN="\033[1;36m"
RED="\033[1;31m"
YELLOW='\033[1;33m'
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

fn_fail_if_missing "${BOLD}TERRAFORM_PLAN_FILE${RESET} is not defined" "${TERRAFORM_PLAN_FILE:-}"

# shellcheck disable=SC2086
terraform apply -auto-approve ${TERRAFORM_PLAN_FILE}

#------------------------------------------------------------------------------
# Artifacts
if [[ -n "${TERRAFORM_CURRENT_STATE:-}" ]]
then
  # Full state in human readable form
  printf %80s ' ' | tr ' ' '-'
  printf "\n"
  echo "Copying state into ${TERRAFORM_CURRENT_STATE}"
  terraform show -no-color > "${TERRAFORM_CURRENT_STATE}"
fi

exit 0