#!/bin/bash

# System Update
sudo apt-get update
sudo apt-get upgrade -y

# Install Nginx
sudo apt-get install nginx -y

# Start and enable Nginx
sudo systemctl start nginx
sudo systemctl enable nginx

# Install MySQL
sudo apt-get install mysql-server -y

# Secure MySQL installation
echo "You will be prompted to configure your MySQL installation"
sudo mysql_secure_installation

# Install Node.js
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash -
sudo apt-get install -y nodejs

# Install Ghost CLI
sudo npm install ghost-cli@latest -g

# Create directory for Ghost installation
sudo mkdir -p /var/www/ghost
sudo chown $USER:$USER /var/www/ghost
sudo chmod 775 /var/www/ghost
cd /var/www/ghost

# Install Ghost
ghost install

echo "Ghost installation completed."
