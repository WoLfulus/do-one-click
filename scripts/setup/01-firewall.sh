#!/bin/bash

sudo ufw default deny incoming
sudo ufw default allow outgoing

sudo ufw allow ssh
sudo ufw allow http
sudo ufw allow https

sed -i -e '/^ENABLED/s/^.*$/ENABLED=yes/' /etc/ufw/ufw.conf

echo "y" | sudo ufw enable
