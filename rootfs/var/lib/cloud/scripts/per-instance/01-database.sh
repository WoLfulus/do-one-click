#!/bin/bash

# Scripts in this directory will be executed by cloud-init on the first boot of droplets
# created from your image.  Things ike generating passwords, configuration requiring IP address
# or other items that will be unique to each instance should be done in scripts here.

export DEBIAN_FRONTEND=noninteractive

MYSQL_ROOT_PASSWORD=$(openssl rand -base64 32 | tr -dc 'a-zA-Z0-9' | head -c 16)
MYSQL_PASSWORD=$(openssl rand -base64 32 | tr -dc 'a-zA-Z0-9' | head -c 16)

mysql -e "CREATE DATABASE directus;"
mysql -e "GRANT ALL ON directus.* TO directus@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';"

expect -c "
set timeout 10
spawn mysql_secure_installation

expect \"Press y|Y for Yes, any other key for No:\"
send \"n\r\"

expect \"New password:\"
send \"${MYSQL_ROOT_PASSWORD}\r\"

expect \"Re-enter new password:\"
send \"${MYSQL_ROOT_PASSWORD}\r\"

expect \"Remove anonymous users? (Press y|Y for Yes, any other key for No) :\"
send \"y\r\"

expect \"Disallow root login remotely? (Press y|Y for Yes, any other key for No) :\"
send \"n\r\"

expect \"Remove test database and access to it? (Press y|Y for Yes, any other key for No) :\"
send \"y\r\"

expect \"Reload privilege tables now? (Press y|Y for Yes, any other key for No) :\"
send \"y\r\"

expect eof
"

echo "            MySQL Root Username: root" >> /var/directus/credentials.txt
echo "            MySQL Root Password: ${MYSQL_ROOT_PASSWORD}" >> /var/directus/credentials.txt
echo " " >> /var/directus/credentials.txt
echo "                 MySQL Database: directus" >> /var/directus/credentials.txt
echo "                 MySQL Username: directus" >> /var/directus/credentials.txt
echo "                 MySQL Password: ${MYSQL_PASSWORD}" >> /var/directus/credentials.txt
