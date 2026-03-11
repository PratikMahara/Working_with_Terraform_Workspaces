#!/bin/bash

sudo apt-get update
sudo apt-get install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx

echo "<h1>I am learning Terraform from TWS</h1>" | sudo tee /var/www/html/index.html