#!/bin/bash

# Ensure the script is run as root
if [ "$(id -u)" != "0" ]; then
    echo "This script must be run as root" 1>&2
    exit 1
fi

# Create the ghostcms user and add to sudoers
adduser ghostcms
usermod -aG sudo ghostcms

# Update and upgrade packages
apt-get update && apt-get upgrade -y

# Install mysql server
apt-get install mysql-server -y

# Install curl (in case it's not installed)
apt-get install curl -y

# Install NVM for ghostcms user
sudo -u ghostcms bash -c 'curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.0/install.sh | bash'
# Wait a moment for nvm to install
sleep 5

# Use NVM to install Node.js v16 and set it as the default version
sudo -u ghostcms bash -c 'export NVM_DIR="$HOME/.nvm" && [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" && nvm install 16.14.0 && nvm use 16.14.0 && nvm alias default 16.14.0'

# Verify node and npm installation
sudo -u ghostcms bash -c 'node -v'
sudo -u ghostcms bash -c 'npm -v'

# Install NGINX
apt-get install nginx -y
systemctl start nginx
systemctl enable nginx

# Install Ghost-CLI
sudo -u ghostcms bash -c 'npm install ghost-cli@latest -g'

# Set up directory for Ghost installation
mkdir -p /var/www/ghost
chown ghostcms:ghostcms /var/www/ghost
chmod 775 /var/www/ghost

# sudo -u ghostcms bash -c 'cd /var/www/ghost && ghost install'

cd /var/www/ghost/

# run ghost install 
echo "Please run ghost install in /var/www/ghost/ for the interactive installer"
