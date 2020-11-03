#Quickfix - Basebox for PHP7.2 Library now uses Debian "10" Buster, superceeding #libcurl3, stretch is most compatible at this time whilst devs workout backport.
#https://github.com/docker-library/php/issues/865

FROM php:7.2-apache-stretch

#Surpresses debconf complaints of trying to install apt packages interactively
#https://github.com/moby/moby/issues/4032#issuecomment-192327844

ARG DEBIAN_FRONTEND=noninteractive

RUN apt-get -y update
RUN apt-get -y upgrade --fix-missing --no-install-recommends

# Install important libraries
RUN apt-get -y install --fix-missing --no-install-recommends\
  apt-utils\
  build-essential\
  git\
  curl\
  libcurl3\
  libcurl3-dev\
  zip\
  openssl\
  memcached\
  libmemcached-dev\
  netcat\
  libpq-dev\
  libsqlite3-dev\
  libsqlite3-0\
  mysql-client\
  libfreetype6-dev\
  libjpeg62-turbo-dev\
  libpng-dev \
  libxml2-dev

# Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install xdebug
RUN pecl install xdebug-2.6.0
RUN docker-php-ext-enable xdebug

# Install memcached
RUN pecl install memcached
RUN docker-php-ext-enable memcached

# Other PHP7 Extensions
RUN docker-php-ext-install soap
RUN docker-php-ext-install opcache
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install mysqli

RUN docker-php-ext-install curl
RUN docker-php-ext-install tokenizer
RUN docker-php-ext-install json

RUN apt-get -y install zlib1g-dev
RUN docker-php-ext-install zip

RUN apt-get -y install libicu-dev
RUN docker-php-ext-install -j$(nproc) intl

RUN docker-php-ext-install mbstring
RUN docker-php-ext-install gettext

RUN docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ -with-png-dir=/usr/include/
RUN docker-php-ext-install -j$(nproc) gd



# Enable apache modules
RUN a2enmod rewrite headers

RUN rm -rf /var/lib/apt/lists/*
