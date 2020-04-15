#!/bin/bash

echo "Enter domain name:"
read domain
echo "Enter your email:"
read email

sudo apt-get update

echo
echo "Installing nginx..."
sudo apt-get -y install nginx
sudo ufw allow 'Nginx HTTP'

echo
echo "Installing the project on a server..."
echo "Ensuring preconditions..."

shouldExit=false
shouldAWSConfigCreated=false

proxyConfFile="/etc/nginx/proxy.conf"
if [ -f "$proxyConfFile" ]
then
    echo
	echo "$proxyConfFile found... [OK]"
else
    echo
	echo "$proxyConfFile does not exist [WARNING]"
    echo "Link to proxy.config will be created"
    sudo cp ./nginx/proxy.conf /etc/nginx/proxy.conf -f
fi

echo "Should be created AWS config? Enter 'y' or 'n':" 
read choice

if [ "$choice" = "y" ]
then
    echo
	echo "AWS config not found [WARNING]"
    echo "Enter aws_access_key_id:"
    read aws_access_key_id
    echo "Enter aws_secret_access_key:"
    read aws_secret_access_key
    
    if [ "${#aws_access_key_id}" -le 1 ]
    then
        shouldExit=true
    fi
    if [ "${#aws_secret_access_key}" -le 1 ]
    then
        shouldExit=true
    fi
else
    echo 
    echo "AWS config will be not installed"
fi

if [ "$shouldExit" = true ]
then
    echo
	echo "===== ERROR - Please install the necessary stuff manually ====="
	exit
fi
echo

if [ "$shouldAWSConfigCreated" = true ]
then
    echo
	echo "AWS config will be created..."
    sudo mkdir ~/.aws/
    echo "[default]" > ~/.aws/config
    echo "aws_access_key_id=${aws_access_key_id}" > ~/.aws/config
    echo "aws_secret_access_key=${aws_secret_access_key}" > ~/.aws/config
fi

echo
echo "Creating link to sites-enabled in nginx"
sudo ln -s nginx/sites-enabled /etc/nginx/sites-enabled
sudo invoke-rc.d nginx reload

echo
echo "Installing cerbot..."
sudo add-apt-repository -y ppa:certbot/certbot
sudo apt-get update
sudo apt-get -y install python-certbot-nginx
sudo apt -y install python3-certbot-dns-route53

echo
echo "Retrieve certificate"
sudo certbot certonly -d $domain -d *.$domain --dns-route53 --agree-tos --email $email --non-interactive --server https://acme-v02.api.letsencrypt.org/directory
sudo systemctl reload nginx

sudo rm -R ~/.aws

echo
echo "===== OK - Installation finished successfully ====="
exit