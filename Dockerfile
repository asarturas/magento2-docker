FROM centos:centos6

# Installing base components
RUN yum -y install wget curl unzip supervisor g++ make mc vim tar gcc pcre-devel openssl-devel patch libmcrypt-devel libxml2-devel bzip2-devel libcurl-devel readline-devel git
RUN yum -y update

# Installing PHP 5.6
RUN yum -y install https://mirror.webtatic.com/yum/el6/latest.rpm
RUN yum -y install php56w-pecl-memcache php56w-fpm php56w-intl php56w-mcrypt php56w-mbstring php56w-mysql php56w-pdo php56w-mbstring php56w-soap php56w-pecl-zendopcache php56w-xml php56w-gd php56w-opcache php56w-pecl-imagick

# Installing MySQL 5.6
RUN rpm -Uvh http://dev.mysql.com/get/mysql-community-release-el6-5.noarch.rpm
RUN yum -y install mysql-community-server

# Installing Nginx
RUN wget http://nginx.org/packages/centos/6/noarch/RPMS/nginx-release-centos-6-0.el6.ngx.noarch.rpm
RUN rpm -ivh nginx-release-centos-6-0.el6.ngx.noarch.rpm
RUN yum -y install nginx

# Installing Varnish
RUN yum -y upgrade ca-certificates
RUN yum -y install https://repo.varnish-cache.org/redhat/varnish-4.0.el6.rpm
RUN yum -y install epel-release
RUN yum -y install varnish

# Installing Composer
RUN curl -sS https://getcomposer.org/installer | php
RUN mv composer.phar /usr/local/bin/composer

# nginx
ADD etc/nginx.conf/fastcgi_params.conf /etc/nginx/conf/fastcgi_params.conf
ADD etc/nginx.conf/magento.conf /etc/nginx/conf/magento.conf
RUN mv /etc/nginx/conf.d/default.conf /etc/nginx/conf.d/default.conf.default
ADD etc/nginx.conf/default.conf /etc/nginx/conf.d/default.conf

# php
ADD etc/php.conf/php.ini /etc/php.ini

# php fpm
RUN mv /etc/php-fpm.d/www.conf /etc/php-fpm.d/www.conf.default
ADD etc/php-fpm.conf/www.conf /etc/php-fpm.d/www.conf
RUN mkdir -p /var/lib/php/session
RUN mkdir -p /var/lib/php/wsdlcache
RUN chmod -R 777 /var/lib/php/session
RUN chmod -R 777 /var/lib/php/wsdlcache

# varnish
RUN mv /etc/sysconfig/varnish /etc/sysconfig/default.varnish
ADD etc/varnish.conf/varnish /etc/sysconfig/varnish
ADD etc/varnish.conf/default.vcl /etc/varnish/default.vcl

# bash
ADD scripts /scripts
RUN chmod +x -R /scripts

VOLUME ["/var/www/app/magento2.docker.loc/magento2"]
ENTRYPOINT /scripts/install.sh
