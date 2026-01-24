#!/usr/bin/env bash

set -o nounset
set -o errexit
set -o pipefail

function fn_usage() {
  echo
  echo "Creates \"scaffolding\" for a Terraform module in the current directory."
  echo "Terraform Registry conventions are used."
  echo
  echo "Usage: $0 [-hv] MODULE"
  echo
  echo -e  "${BOLD_WHITE}Options:${COLOUR_OFF}"
  echo "  -h     Show this usage message and exit"
  echo "  -v     Verbose mode"
  echo
  echo -e  "${BOLD_WHITE}Positional arguments:${COLOUR_OFF}"
  echo "  MODULE    Name of the module/sub-directory"
  echo
  echo -e "${BOLD_YELLOW}NB${COLOUR_OFF} assumes that ${BOLD_WHITE}tfenv${COLOUR_OFF} is being used to manage Terraform versions!"
  echo
}

function fn_log() {
  if ${VERBOSE_MODE}
  then
    echo -e "$@"
  fi
}

function fn_directory_exists() {
    local dir=$1
    if test -d "${dir}"
    then
      return 0
    else
      return 1
    fi
}

function fn_file_exists() {
    local file=$1
    test -f "${file}"
}

function fn_create_files() {
  local parent=$1

  TF_FILES=(
    main.tf
    outputs.tf
    variables.tf
    versions.tf
  )

  for file in "${TF_FILES[@]}"
  do
    filepath="${parent}/$file"
    touch "${filepath}"
  done

  MD_FILES=(
    CHANGELOG.md
    README.md
  )

  for file in "${MD_FILES[@]}"
  do
    filepath="${parent}/$file"
    touch "${filepath}"
  done
}

function fn_examples() {
  local module_root=$1

  if ! eval fn_directory_exists "${module_root}/examples"
  then
    mkdir "${module_root}/examples"
    fn_log "Created directory ${BOLD_GREEN}${module_root}/examples${COLOUR_OFF}"
  fi

  example_complete_dir="${module_root}/examples/complete"
  if ! eval fn_directory_exists "${example_complete_dir}"
  then
    mkdir "${example_complete_dir}"
    fn_log "Created directory ${BOLD_GREEN}${example_complete_dir}${COLOUR_OFF}"
  fi

  fn_create_files "${example_complete_dir}"
}

COLOUR_OFF='\033[0m'

BOLD_RED='\033[1;31m'
BOLD_GREEN='\033[1;32m'
BOLD_YELLOW='\033[1;33m'
BOLD_CYAN='\033[1;36m'
BOLD_WHITE='\033[1;37m'

### ENTRY
TERRAFORM=$(command -v terraform)

VERBOSE_MODE=false
while getopts "hv" opt; do
  case "${opt}" in
  h | \?)
    fn_usage
    exit 0
    ;;
  v)
    VERBOSE_MODE=true
    ;;
  [?])
    shift
    ;;
  esac
done

shift $((OPTIND - 1))
if [ $# -ne 1 ]
then
  echo -e "${BOLD_RED}ERROR${COLOUR_OFF} - a single module name is required!"
  exit 1
fi
module_name=$1

# look for modules folder, prompt to create if needed
MODULES="modules"
fn_log "Checking if a ${BOLD_WHITE}${MODULES}${COLOUR_OFF} directory exists"
if ! eval fn_directory_exists ${MODULES}
then
  echo -e "A ${BOLD_WHITE}${MODULES}${COLOUR_OFF} directory does not exist in the current directory - do you wish to create it?"
    while true
    do
      read -r -p "  Please enter 'y' or 'n': " response
      [[ "${response}" =~ ^[ny]$ ]] && break
    done

    if [[ "${response}" == "y" ]]
    then
      mkdir ${MODULES}
      fn_log "Directory created!"
    fi

fi

module_root="$(pwd)/${MODULES}/${module_name}"
if ! eval fn_directory_exists "${module_root}"
then
  mkdir "${module_root}"
  fn_log "Created directory ${BOLD_GREEN}${module_root}${COLOUR_OFF}"
fi

fn_create_files "${module_root}"
fn_examples "${module_root}"





TFENV=$(command -v tfenv) || true
if [[ -n "${TFENV}" ]]
then
  terraform_version=$($TFENV version-name)
else
  echo -e "${BOLD_YELLOW}TODO${COLOUR_OFF} handle case of ${BOLD_WHITE}tfenv${COLOUR_OFF} not being used to manage Terraform versions"
  exit 1
fi

fn_log "The current / local Terraform version is ${BOLD_CYAN}${terraform_version}${COLOUR_OFF}"