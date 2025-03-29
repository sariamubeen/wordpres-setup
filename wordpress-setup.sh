#!/bin/bash

# Ask for MySQL root password
read -sp "Enter MySQL root password: " MYSQL_ROOT_PASS
echo
read -p "Enter WordPress database name (default: wordpress): " WP_DB
WP_DB=${WP_DB:-wordpress}
read -p "Enter WordPress database user (default: wpuser): " WP_USER
WP_USER=${WP_USER:-wpuser}
read -sp "Enter WordPress database password: " WP_PASS
echo

# Update packages
sudo apt update && sudo apt upgrade -y

# Install Apache, MySQL, PHP, and extensions
sudo apt install -y apache2 mysql-server php php-cli php-mysql libapache2-mod-php php-curl php-xml php-mbstring php-zip php-gd php-soap php-intl unzip curl wget

# Enable Apache mod_rewrite
sudo a2enmod rewrite
sudo systemctl restart apache2

# Create WordPress database and user
sudo mysql -u root -p"$MYSQL_ROOT_PASS" <<MYSQL_SCRIPT
CREATE DATABASE IF NOT EXISTS $WP_DB DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER IF NOT EXISTS '$WP_USER'@'localhost' IDENTIFIED BY '$WP_PASS';
GRANT ALL PRIVILEGES ON $WP_DB.* TO '$WP_USER'@'localhost';
FLUSH PRIVILEGES;
MYSQL_SCRIPT

# Download and configure WordPress
cd /tmp
wget https://wordpress.org/latest.tar.gz
tar -xvzf latest.tar.gz
sudo rm -rf /var/www/html/*
sudo mv wordpress/* /var/www/html/

# Set up wp-config.php
cd /var/www/html
sudo cp wp-config-sample.php wp-config.php
sudo sed -i "s/database_name_here/$WP_DB/" wp-config.php
sudo sed -i "s/username_here/$WP_USER/" wp-config.php
sudo sed -i "s/password_here/$WP_PASS/" wp-config.php

# Set permissions
sudo chown -R www-data:www-data /var/www/html
sudo find /var/www/html/ -type d -exec chmod 755 {} \;
sudo find /var/www/html/ -type f -exec chmod 644 {} \;

# Generate secret keys
SECRET_KEYS=$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)
sudo sed -i "/AUTH_KEY/d" wp-config.php
sudo sed -i "/SECURE_AUTH_KEY/d" wp-config.php
sudo sed -i "/LOGGED_IN_KEY/d" wp-config.php
sudo sed -i "/NONCE_KEY/d" wp-config.php
sudo sed -i "/AUTH_SALT/d" wp-config.php
sudo sed -i "/SECURE_AUTH_SALT/d" wp-config.php
sudo sed -i "/LOGGED_IN_SALT/d" wp-config.php
sudo sed -i "/NONCE_SALT/d" wp-config.php
sudo sed -i "/@since 2.6.0/a $SECRET_KEYS" wp-config.php

# Restart Apache
sudo systemctl restart apache2

# Show success message
echo "\n✅ WordPress is installed at: http://your-server-ip"
echo "Make sure to update Apache config or DNS if needed."
