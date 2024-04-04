#!/bin/bash

yes | sudo apt update
yes | sudo apt install apache2

# Create the main index.html with server details
echo "<h1>Server Details</h1><p><strong>Hostname:</strong> $(hostname)</p><p><strong>IP Address:</strong> $(hostname -I | cut -d' ' -f1)</p>" > /var/www/html/index.html

# Create the /foo subdirectory
sudo mkdir /var/www/html/foo

# Create the index.html file in the /foo subdirectory
echo "<h1>Hi from foo</h1><p>this is the foo folder from $(hostname)</p>" > /var/www/html/foo/index.html

# Set the correct permissions for the /foo directory and its contents
sudo chown -R www-data:www-data /var/www/html/foo
sudo chmod -R 755 /var/www/html/foo

# Create the /bar subdirectory
sudo mkdir /var/www/html/bar
# Create the index.html file in the /bar subdirectory
echo "<h1>Hi from bar</h1><p>this is the bar folder from $(hostname)</p>" > /var/www/html/bar/index.html
# Set the correct permissions for the /bar directory and its contents
sudo chown -R www-data:www-data /var/www/html/bar
sudo chmod -R 755 /var/www/html/bar

# Restart the Apache2 service to apply changes
sudo systemctl restart apache2
