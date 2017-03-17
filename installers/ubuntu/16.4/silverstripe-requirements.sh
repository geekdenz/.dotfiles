#!/bin/sh

sudo add-apt-repository ppa:ondrej/php
sudo apt-get update
sudo apt install -y php5.6-gd php5.6-mysql php5.6-pgsql php5.6-curl php5.6-cli php5.6-dom php5.6-mbstring php5.6 php5.6-sqlite3 php5.6-xml php5.6-curl php5.6-tidy
sudo apt install -y mysql-server mysql-client
sudo apt-get install -y php7.0 php5.6 php5.6-mysql php-gettext php5.6-mbstring php-xdebug libapache2-mod-php5.6 libapache2-mod-php7.0
sudo a2dismod php7.0 ; sudo a2enmod php5.6 ; sudo service apache2 restart
sudo update-alternatives --set php /usr/bin/php5.6
chmod -R a+w .htaccess mysite/_config.php assets/
