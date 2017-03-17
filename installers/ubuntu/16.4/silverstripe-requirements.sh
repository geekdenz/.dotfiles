#!/bin/sh

sudo apt install php5.6-gd php5.6-mysql php5.6-pgsql php5.6-curl php5.6-cli php5.6-dom php5.6-mbstring php5.6 php5.6-sqlite3 php5.6-xml php5.6-curl php5.6-tidy
sudo apt install mysql-server mysql-client
chmod -R a+w .htaccess mysite/_config.php assets/
