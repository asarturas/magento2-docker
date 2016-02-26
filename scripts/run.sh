#!/bin/bash
set -e

service php-fpm start
service nginx start
service mysqld start
