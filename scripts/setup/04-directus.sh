#!/bin/bash

mkdir -p /var/directus

git clone --branch "${DIRECTUS_VERSION}" --depth 1 https://github.com/directus/directus.git /var/directus

chown -Rf www-data:www-data /var/directus
