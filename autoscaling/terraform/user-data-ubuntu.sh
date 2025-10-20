#!/usr/bin/env bash

set -o nounset
set -o errexit
set -o pipefail

fn_install_ssm_agent() {
  local DIR=$1
  cd "${DIR}"

  curl -O https://s3.amazonaws.com/ec2-downloads-windows/SSMAgent/latest/linux_amd64/amazon-ssm-agent.rpm

  # Should check first if the RPM is already installed
  (rpm -qa amazon-ssm-agent | grep amazon-ssm-agent) || yum install -y amazon-ssm-agent.rpm
  systemctl start amazon-ssm-agent
}

fn_httpd_server() {
  local DIR=$1
  cd "${DIR}"

  echo "Hello World" > index.html
  nohup busybox httpd -f -p 80 &
}

tmpdir=$(mktemp -d)
#fn_install_ssm_agent "${tmpdir}"
fn_httpd_server "${tmpdir}"