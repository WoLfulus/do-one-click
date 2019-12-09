#!/bin/bash

a2enmod rewrite
a2enmod headers

a2dissite 000-default
a2enconf directus
a2ensite directus

service apache2 restart
