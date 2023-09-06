FROM ubuntu:22.04

# Make sure php installation is quiet 
RUN ln -fs /usr/share/zoneinfo/America/Los_Angeles /etc/localtime
RUN apt-get update && apt-get -q -y install tzdata

# Install debug tools
RUN apt-get install \
	-y \
	-q \
	vim \
	net-tools \
	lsof \
	curl

# Local dev env only
RUN apt-get install \
	-y \
	-q \
	mysql-server
RUN 

RUN apt-get install \
	-y \
	-q \
	php8.1-fpm \
	php8.1-gd \
	php8.1-xml \
	php8.1-curl \
	php8.1-dom \
	php8.1-mysql \
        nginx \
	git \
	composer

# php.ini fixes
RUN sed -s 's/short_open_tag = Off/short_open_tag = On/g' -i /etc/php/8.1/fpm/php.ini

RUN mkdir -p /var/www/html/log /var/www/html/tmp
RUN chown www-data /var/www/html/log /var/www/html/tmp
RUN echo "<? phpinfo(); ?>" > /var/www/html/phpinfo.php

RUN cd /var/www/html && \
	git clone https://github.com/BookStackApp/BookStack.git --branch release --single-branch && \
	chown -R www-data BookStack/public/uploads && \
	chown -R www-data BookStack/storage && \
	chown -R www-data BookStack/bootstrap/cache

RUN cd /var/www/html/BookStack && \
	composer install --no-dev 


COPY conf/etc/php/8.1/fpm/pool.d/www.conf /etc/php/8.1/fpm/pool.d/www.conf
COPY conf/etc/nginx/sites-available/default /etc/nginx/sites-available/default 
COPY .env /var/www/html/BookStack/.env
