#!/bin/bash

# Ghost Installation Script for Ubuntu based on https://ghost.org/docs/install/ubuntu/

# Ensure the script is run as root
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

# Update and upgrade system
apt-get update && apt-get upgrade -y

# Add the required repository and install Node.js
curl -sL https://deb.nodesource.com/setup_14.x | sudo -E bash
apt-get install -y nodejs

# Install npm (Though it typically comes bundled with Node.js from NodeSource)
apt-get install -y npm

# Install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash

# Refresh the environment to recognize nvm
source ~/.bashrc

# Use nvm to install Node.js 16.14.0 and set it as default
nvm install 16.14.0 && nvm use 16.14.0 && nvm alias default 16.14.0

# Adjust permissions for /home/ubuntu/
chmod o+rx /home/ubuntu/

# Install NGINX
apt-get install nginx -y
systemctl start nginx
systemctl enable nginx

# Install Ghost-CLI
npm install ghost-cli@latest -g

# Set up directory for Ghost installation
mkdir -p /var/www/ghost
chown $SUDO_USER:$SUDO_USER /var/www/ghost
chmod 775 /var/www/ghost

# Move to directory and install Ghost
cd /var/www/ghost && ghost install


echo "Ghost installation completed!"
