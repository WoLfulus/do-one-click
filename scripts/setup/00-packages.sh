#!/bin/bash

apt -qqy update
apt -qqy -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' full-upgrade
apt -qqy -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' install \
  lamp-server^ \
  expect \
  autoconf \
  dpkg-dev \
  file \
  g++ \
  gcc \
  libc-dev \
  make \
  pkg-config \
  re2c \
  xz-utils \
  ca-certificates \
  git \
  curl \
  apache2-dev \
  imagemagick \
  libcurl4-openssl-dev \
  libedit-dev \
  libsodium-dev \
  libsqlite3-dev \
  libssl-dev \
  libxml2-dev \
  zlib1g-dev \
  libpng-dev \
  libjpeg-dev \
  libzip-dev \
  libfreetype6-dev \
  libmagickwand-dev
apt -qqy -o Dpkg::Options::='--force-confdef' -o Dpkg::Options::='--force-confold' install \
  php-mbstring \
  php-curl \
  php-zip \
  php-exif \
  php-xml \
  php-gd \
  php-sqlite3 \
  php-imagick
