#!/bin/bash

sudo yum update
sudo yum install httpd -y
service httpd start
chkconfig httpd on
cd /var/www/html