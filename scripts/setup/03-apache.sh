#!/bin/bash

a2enmod rewrite
a2enmod headers

sed -i "s/www\/html/directus\/public/" /etc/apache2/sites-enabled/000-default.conf
sed -i "s/var\/www/var\/directus/" /etc/apache2/apache2.conf

service apache2 restart
