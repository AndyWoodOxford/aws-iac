#!/usr/bin/env bash

set -o nounset
set -o errexit
set -o pipefail

function fn_usage() {
  echo
  echo "A wrapper for a \"terraform destroy\" command."
  echo
  echo "Usage: $0 [-h]"
  echo
  echo -e  "${CYAN}Options${RESET}"
  echo -e "  ${YELLOW}-h${RESET}    ${BOLD}Show this usage message and exit${RESET}"
  echo
  echo -e "The optional ${YELLOW}\"TF_EXTRA_VARS\"${RESET} environment variable is passed into the plan, e.g."
  echo -e "export TF_EXTRA_VARS=\"-target=aws_instance.vm\""
  echo
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

# shellcheck disable=SC2086
terraform destroy --auto-approve  ${TF_EXTRA_VARS:-}

exit 0
