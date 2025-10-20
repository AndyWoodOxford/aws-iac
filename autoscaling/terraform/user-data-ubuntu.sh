#!/usr/bin/env bash

set -o nounset
set -o errexit
set -o pipefail

fn_httpd_server() {
  local DIR=$1
  cd "${DIR}"

  echo "Hello World" > index.html
  nohup busybox httpd -f -p 80 &
}

tmpdir=$(mktemp -d)
fn_httpd_server "${tmpdir}"