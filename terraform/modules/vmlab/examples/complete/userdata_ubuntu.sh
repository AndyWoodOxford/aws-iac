#!/usr/bin/env bash

set -o nounset
set -o errexit
set -o pipefail

sudo apt update -y
sudo apt install apache2 -y
sudo systemctl start apache2

echo "Hello World" | sudo tee /var/www/html/index.html