#!/bin/bash
set -e

service php-fpm start
service nginx start
service mysqld start
service varnish start
mysql -e 'CREATE DATABASE IF NOT EXISTS magento;'
bash
