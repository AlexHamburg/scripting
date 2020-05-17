#!/bin/bash

# Install CodeDeploy agent on EC2 instance:
sudo yum update
sudo yum install ruby
sudo yum install wget
cd /home/ec2-user
# Correct your AZ
wget https://aws-codedeploy-eu-central-1.s3.amazonaws.com/latest/install
chmod +x ./install
sudo ./install auto
sudo service codedeploy-agent status

# Create your application.zip and load it into CodeDeploy via S3
aws deploy create-application --application-name mywebapp
aws deploy push --application-name mywebapp --s3-location s3://<MY_BUCKET_NAME>/webapp.zip --ignore-hidden-files