FROM jenkins:1.609.1

MAINTAINER Yo-An Lin "yoanlin93@gmail.com"
MAINTAINER Azole Lai "azolelai@gmail.com"

ENV JENKINS_HOME /var/jenkins_home
ENV DEBIAN_FRONTEND noninteractive


USER root

# Add source.list
RUN echo "deb-src http://httpredir.debian.org/debian jessie main" > /etc/apt/sources.list
RUN echo "deb-src http://httpredir.debian.org/debian jessie-updates main" > /etc/apt/sources.list
RUN echo "deb-src http://security.debian.org jessie/updates main" > /etc/apt/sources.list

# Basic tools
RUN apt-get update \
  && apt-get -qqy install sudo \
  && apt-get -qqy install ant ant-contrib sqlite3 wget \
  && apt-get -qqy install \
    php5 \
    php5-dev \
    php5-cli \
    php-apc \
    php-pear \
    php5-curl \
    php5-fpm \
    php5-gd \
    php5-mysql \
    php5-xdebug \
    autoconf automake curl build-essential \
    libxslt1-dev re2c libxml2 libxml2-dev  \
    bison libbz2-dev libreadline-dev \
    libfreetype6 libfreetype6-dev libpng12-0 libpng12-dev libjpeg-dev libgd-dev libgd3 libxpm4 \
    libssl-dev openssl \
    gettext libgettextpo-dev libgettextpo0 \
    libicu-dev \
    libmhash2 libmhash-dev \
    libmcrypt4 libmcrypt-dev \
    libpcre3-dev libpcre++-dev

RUN apt-get clean -y \
  && apt-get autoclean -y \
  && apt-get autoremove -y \
  && rm -rf /var/lib/{apt,dpkg,cache,log}/ \
  && rm -rf /var/lib/apt/lists/*

# Install php tools
RUN  mkdir -p /usr/bin \
  && wget -q -O /usr/bin/phpunit https://phar.phpunit.de/phpunit.phar && chmod +x /usr/bin/phpunit \
  && wget -q -O /usr/bin/composer https://getcomposer.org/composer.phar && chmod +x /usr/bin/composer \
  && wget -q -O /usr/bin/phpmd http://static.phpmd.org/php/latest/phpmd.phar && chmod +x /usr/bin/phpmd \
  && wget -q -O /usr/bin/sami http://get.sensiolabs.org/sami.phar && chmod +x /usr/bin/sami \
  && wget -q -O /usr/bin/phpcov https://phar.phpunit.de/phpcov.phar && chmod +x /usr/bin/phpcov \
  && wget -q -O /usr/bin/phpcpd https://phar.phpunit.de/phpcpd.phar && chmod +x /usr/bin/phpcpd \
  && wget -q -O /usr/bin/phploc https://phar.phpunit.de/phploc.phar && chmod +x /usr/bin/phploc \
  && wget -q -O /usr/bin/phptok https://phar.phpunit.de/phptok.phar && chmod +x /usr/bin/phptok \
  && wget -q -O /usr/bin/box https://github.com/box-project/box2/releases/download/2.5.2/box-2.5.2.phar && chmod +x /usr/bin/box

RUN echo "jenkins ALL=NOPASSWD: ALL" >> /etc/sudoers

RUN echo "Asia/Taipei" > /etc/timezone && dpkg-reconfigure -f noninteractive tzdata

USER jenkins
COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt
