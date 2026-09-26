#!/bin/bash

sudo apt-get update
sudo apt-get install nginx
sudo systemctl  start nginx
sudo systemctl  status nginx
sudo systemctl   enable nginx



echo "<h1> Terraform In One Shot by tws </h1>" | sudo tee /var/www/html/index.html