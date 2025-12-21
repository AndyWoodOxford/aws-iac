#!/usr/bin/env bash

set -o nounset
set -o errexit
set -o pipefail

sudo apt update -y
sudo apt install apache2 -y
sudo systemctl start apache2

created_at=$(date +'%Y-%m-%d %H:%M:%S')
hostname=$(hostname)

cat > /var/www/html/index.html <<EOF
<h1>Welcome to ${hostname}</h1>
<p>Apache webserver created at ${created_at}</p>
EOF
