#!/usr/bin/env bash

set -o nounset
set -o errexit
set -o pipefail

# Based on code from https://github.com/hashicorp-education/learn-terraform-aws-asg

yum update -y
yum -y remove httpd
yum -y remove httpd-tools
yum install -y httpd php
service httpd start
chkconfig httpd on

usermod -a -G apache ec2-user
chown -R ec2-user:apache /var/www
chmod 2775 /var/www
find /var/www -type d -exec chmod 0775 {} \;
find /var/www -type f -exec chmod 0664 {} \;
cd /var/www/html
curl http://169.254.169.254/latest/meta-data/instance-id -o index.html
curl https://raw.githubusercontent.com/hashicorp/learn-terramino/master/index.php -O
