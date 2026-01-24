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
  echo
  echo -e  "${BOLD_WHITE}Positional arguments:${COLOUR_OFF}"
  echo "  MODULE    Name of the module/sub-directory"
  echo
  echo -e "${BOLD_YELLOW}NB${COLOUR_OFF} assumes that ${BOLD_WHITE}tfenv${COLOUR_OFF} is being used to manage Terraform versions!"
  echo
}

function fn_log() {
  echo -e "$@"
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
    if ! eval fn_file_exists "${filepath}"
    then
      touch "${filepath}"
      fn_log "  Created file ${BOLD_GREEN}${file}${COLOUR_OFF}"
    else
      fn_log "  ${BOLD_WHITE}${file}${COLOUR_OFF} already exists"
    fi
  done

  MD_FILES=(
    README.md
  )

  for file in "${MD_FILES[@]}"
  do
    filepath="${parent}/$file"
    if ! eval fn_file_exists "${filepath}"
    then
      touch "${filepath}"
      fn_log "  Created file ${BOLD_GREEN}${file}${COLOUR_OFF}"
    else
      fn_log "  ${BOLD_WHITE}${file}${COLOUR_OFF} already exists"
    fi
  done

  fn_start_main_tf "${parent}/main.tf"
  fn_start_versions_tf "${parent}/versions.tf"
  fn_start_variables_tf "${parent}/variables.tf"
  fn_start_readme_md "${parent}/README.md" "${parent}"
  fn_terraform_docs "${parent}/.terraform-docs.yml"
}

function fn_create_example() {
  local parent=$1
  local example=$2

  example_dir="${parent}/${example}"
  if ! eval fn_directory_exists "${example_dir}"
  then
    mkdir "${example_dir}"
    fn_log "  Created directory ${BOLD_GREEN}${example_dir}${COLOUR_OFF}"
  else
    fn_log "  Example directory ${BOLD_WHITE}${example}${COLOUR_OFF} already exists"
  fi

  fn_create_files "${example_dir}"
}

function fn_start_versions_tf() {
  local versions_tf=$1

  fn_log "Populating ${BOLD_WHITE}${versions_tf}${COLOUR_OFF}"
  tee "${versions_tf}" > /dev/null <<EOF
terraform {
  required_version = ">= ${TERRAFORM_VERSION}"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> ${AWS_PROVIDER_VERSION}"
    }
  }

  # uncomment for a remote S3 backend
  #backend "s3" {}
}
EOF
}

function fn_start_main_tf() {
  local main_tf=$1

  fn_log "Populating ${BOLD_WHITE}${main_tf}${COLOUR_OFF}"
  tee "${main_tf}" > /dev/null <<EOF
provider "aws" {
  region = "${AWS_REGION}"

  default_tags {
    tags = {
      terraform = "true"
    }
  }
}

EOF

  tee -a "${main_tf}" > /dev/null <<EOF
locals {}
EOF
}

function fn_start_variables_tf() {
  local variables_tf=$1

  fn_log "Populating ${BOLD_WHITE}${variables_tf}${COLOUR_OFF}"
  tee "${variables_tf}" > /dev/null <<EOF
variable "name" {
  type        = string
  description = "All resources will use this as a Name, or as a prefix to the Name"
  validation {
    condition     = var.name == lower(var.name)
    error_message = "The resources cannot have upper case characters."
  }
  default = "CHANGEME"
}

variable "tags" {
  type        = map(string)
  description = "Add these tags to all resources"
  default     = {}
}

EOF
}

function fn_start_readme_md() {
  local readme_md=$1
  local header=$2

  fn_log "Populating ${BOLD_WHITE}${readme_md}${COLOUR_OFF}"

  tee "${readme_md}" > /dev/null <<EOF
# ${header}
EOF

  for i in {1..5}
  do
    echo | tee -a "${readme_md}" > /dev/null
  done

  tee -a "${readme_md}" > /dev/null <<EOF
<!-- BEGIN_TF_DOCS -->
<!-- END_TF_DOCS -->
EOF
}

function fn_terraform_docs() {
   local terraform_docs=$1

   fn_log "Populating ${BOLD_WHITE}${terraform_docs}${COLOUR_OFF}"

   tee -a "${terraform_docs}" > /dev/null <<EOF
---
formatter: markdown table

content: |-
 ## Table of Contents

 - [Requirements][1]
 - [Inputs][2]
 - [Outputs][3]
 - [Modules][4]
 - [Resources][5]

 {{ .Header }}

 {{ .Requirements }}{{"\n"}}
 {{ .Inputs }}{{"\n"}}
 {{ .Outputs }}{{"\n"}}
 {{ .Modules }}{{"\n"}}
 {{ .Resources }}{{"\n"}}
 [1]: #requirements
 [2]: #inputs
 [3]: #outputs
 [4]: #modules
 [5]: #resources

sort:
 enabled: true

output:
 file: README.md
 mode: inject
 template: |-
   <!-- BEGIN_TF_DOCS -->
   {{ .Content }}
   <!-- END_TF_DOCS -->

settings:
 indent: 2
 read-comments: false
 hide-empty: false
EOF
}

COLOUR_OFF='\033[0m'

BOLD_RED='\033[1;31m'
BOLD_GREEN='\033[1;32m'
BOLD_YELLOW='\033[1;33m'
BOLD_CYAN='\033[1;36m'
BOLD_WHITE='\033[1;37m'

### ENTRY
AWS_REGION="eu-west-2"
AWS_PROVIDER_VERSION="6.5"
TERRAFORM=$(command -v terraform)

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

shift $((OPTIND - 1))
if [ $# -ne 1 ]
then
  echo -e "${BOLD_RED}ERROR${COLOUR_OFF} - a single module name is required!"
  exit 1
fi
module_name=$1

# Terraform version
TFENV=$(command -v tfenv) || true
if [[ -n "${TFENV}" ]]
then
  TERRAFORM_VERSION=$($TFENV version-name)
else
  echo -e "${BOLD_YELLOW}TODO${COLOUR_OFF} handle case of ${BOLD_WHITE}tfenv${COLOUR_OFF} not being used to manage Terraform versions"
  TERRAFORM_VERSION=$($TERRAFORM --version)  # multi-line output if tfenv present
  exit 1
fi
fn_log "The current / local Terraform version is ${BOLD_CYAN}${TERRAFORM_VERSION}${COLOUR_OFF}"
echo

# look for modules folder, prompt to create if needed
MODULES="modules"
if ! eval fn_directory_exists "${MODULES}"
then
  echo -e "A ${BOLD_WHITE}${MODULES}${COLOUR_OFF} directory does not exist in the current directory - do you wish to create it?"
    while true
    do
      read -r -p "  Please enter 'y' or 'n': " response
      [[ "${response}" =~ ^[ny]$ ]] && break
    done

    if [[ "${response}" == "y" ]]
    then
      mkdir "${MODULES}"
      fn_log "Directory created!"
    fi

fi

# Module configuration
module_dir="${MODULES}/${module_name}"
fn_log "Starting directories and files for the ${BOLD_WHITE}${module_name}${COLOUR_OFF} module"
if ! eval fn_directory_exists "${module_dir}"
then
  mkdir "${module_dir}"
  fn_log "Created module directory ${BOLD_GREEN}${module_dir}${COLOUR_OFF}"
else
  fn_log "Directory ${BOLD_WHITE}${module_dir}${COLOUR_OFF} already exists"
fi

fn_log "Creating files in the ${BOLD_WHITE}${module_dir}${COLOUR_OFF} directory"
fn_create_files "${module_dir}"

# Examples
echo
examples_dir="${module_dir}/examples"
if ! eval fn_directory_exists "${examples_dir}"
then
  mkdir "${examples_dir}"
  fn_log "Created directory ${BOLD_GREEN}${examples_dir}${COLOUR_OFF}"
  echo
fi

examples=("complete")
for example in "${examples[@]}"
do
  fn_log "Creating directories and files for the ${BOLD_WHITE}${example}${COLOUR_OFF} example"
  fn_create_example "${examples_dir}" "${example}"
done

