#!/usr/bin/env bash

set -o nounset
set -o errexit
set -o pipefail

function fn_usage() {
  echo
  echo "A wrapper for a \"terraform plan\" command."
  echo
  echo "Usage: $0 [-h]"
  echo
  echo -e  "${CYAN}Options${RESET}"
  echo -e "  ${YELLOW}-h${RESET}    ${BOLD}Show this usage message and exit${RESET}"
  echo
  echo -e "The optional ${YELLOW}\"TF_EXTRA_VARS\"${RESET} environment variable is passed into the plan."
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

fn_fail_if_missing "${BOLD}AWS_REGION${RESET} is not defined" "${AWS_REGION:-}"
fn_fail_if_missing "${BOLD}AWS_ACCESS_KEY_ID${RESET} is not defined" "${AWS_ACCESS_KEY_ID:-}"
fn_fail_if_missing "${BOLD}AWS_SECRET_ACCESS_KEY${RESET} is not defined" "${AWS_SECRET_ACCESS_KEY:-}"

# Terraform plan
if [[ -z "${TERRAFORM_PLAN_FILE:-}" ]]
then
  TERRAFORM_PLAN_FILE="${USER}.tfplan"
fi

# shellcheck disable=SC2086
terraform plan ${TF_EXTRA_VARS:-} -out="${TERRAFORM_PLAN_FILE}"

# Providers (show output)
if [[ -n "${TERRAFORM_PROVIDERS:-}" ]]
then
  printf %80s ' ' | tr ' ' '-'
  printf "\n"
  echo "Provider Requirements:"
  terraform providers
fi

# Summary of create/update/delete counts (show output)
if [[ -n "${TERRAFORM_PLAN_JSON:-}" ]]
then
  printf %80s ' ' | tr ' ' '-'
  printf "\n"
  echo "Summary of changes:"
  terraform show \
     --json "${TERRAFORM_PLAN_FILE}" \
     | jq -r '([.resource_changes[]?.change.actions?]|flatten)|{"create":(map(select(.=="create"))|length),"update":(map(select(.=="update"))|length),"delete":(map(select(.=="delete"))|length)}' \
     | tee "${TERRAFORM_PLAN_JSON}"
fi

exit 0
