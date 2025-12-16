#!/usr/bin/env bash

set -o nounset
set -o errexit
set -o pipefail

sudo apt update -y
sudo apt install apache2 -y
sudo systemctl start apache2

hostname=$(hostname)
echo "Welcome to ${hostname}" | sudo tee /var/www/html/index.html