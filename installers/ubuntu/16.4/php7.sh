#!/usr/bin/env bash

# Works on Ubuntu 16.4

source "`dirname $0`/config.sh"

set -e

install php7.1
install php7.1-bcmath
install php7.1-curl
install php7.1-gd
install php7.1-intl
install php7.1-mbstring
install php7.1-mysql
install php7.1-xsl

if [ ! -f /usr/bin/composer.phar ]; then
  mecho "Installing composer..."

  curl -sS https://getcomposer.org/installer | php
  sudo mv composer.phar /usr/bin
  sudo ln -fs /usr/bin/composer.phar /usr/bin/composer
fi

if [ ! -f /etc/php/7.1/mods-available/xdebug.ini ]; then
  mecho "Installing xdebug"

  rm -f /tmp/xdebug-2.4.0.tgz
  wget -O /tmp/xdebug-2.4.0.tgz http://xdebug.org/files/xdebug-2.4.0.tgz
  cd /tmp && sudo tar xzvf xdebug-2.4.0.tgz
  cd xdebug-2.4.0
  sudo phpize
  sudo ./configure
  sudo make
  sudo cp modules/xdebug.so /usr/lib/php/20151012
  sudo ln -s /etc/php/7.1/mods-available/xdebug.ini /etc/php/7.1/cli/conf.d/20-xedebug.ini
  sudo ln -s /etc/php/7.1/mods-available/xdebug.ini /etc/php/7.1/fpm/conf.d/20-xedebug.ini
fi
