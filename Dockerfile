FROM php:7.2-apache


# Default ENV variables

# The following ENV variables are fetched from Vault and placed into .env file by the bash script start.sh
# .env file is overidden by Dockerfile or deployment file
# This means that any ENV variable which requires Vault must NOT be present in Dockerfile or deployment file
# DB_PASSWORD
# DB_USERNAME


ENV APP_KEY base64:3NULv5PWlxlw+g8Ta6ksEEY2BXXTlUSgjxuisbC8T54=
ENV APP_DEBUG "true"
ENV LOG_CHANNEL stack
ENV DB_CONNECTION mysql
ENV DB_DATABASE reporting
#ENV BROADCAST_DRIVER log
#ENV CACHE_DRIVER file
#ENV SESSION_DRIVER file
#ENV QUEUE_DRIVER sync
#ENV SHARED_URL https://shared.workland.com
#ENV ATLAS_UI_URL http://localhost:8100
#ENV RABBITMQ_HOST 172.24.0.2
#ENV RABBITMQ_PORT 5672
#ENV RABBITMQ_USERNAME rabbit
#ENV RABBITMQ_PASSWORD somerabbit
#ENV JWT_SECRET 66bcrkLfaeu1IyoPA5Ydz6U73sCDtV4r
#ENV INVITE_KEY_TTL 604800




# install the PHP extensions we need
RUN set -ex; \
    \
    apt-get update; \
    apt-get install --allow-unauthenticated -y \
        vim \
        sudo \
        apt-utils \
        unzip \
        libjpeg-dev \
        libpng-dev \
        libxml2-dev \
        curl \
        git \
        supervisor \
        python-pip\
    ; \
    rm -rf /var/lib/apt/lists/*; \
    docker-php-ext-configure gd \
        --with-png-dir=/usr/lib/x86_64-linux-gnu/ \
        --with-jpeg-dir=/usr/lib/x86_64-linux-gnu/; \
    docker-php-ext-install mysqli mbstring pdo pdo_mysql tokenizer xml bcmath sockets;


RUN  pecl install xdebug; \
     docker-php-ext-enable xdebug; \
     echo "error_reporting = E_ALL" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
     echo "display_startup_errors = On" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
     echo "display_errors = On" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini; \
     echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini;

# Install supervisor-stdout
RUN pip install supervisor-stdout

# Install Composer
RUN curl -s -L https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Install dockerize (https://github.com/jwilder/dockerize)
ENV DOCKERIZE_RELEASE v0.2.0/dockerize-linux-amd64-v0.2.0.tar.gz
RUN curl -s -L https://github.com/jwilder/dockerize/releases/download/${DOCKERIZE_RELEASE} \
  | tar -C /usr/bin -xzvf -

# Clean up
RUN apt-get clean \
 && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Create a directory for Lumen
RUN rm -rf /var/www/html/*
RUN mkdir -p /var/www/html
WORKDIR /var/www/html

# Configure and Start Apache2
RUN a2enmod rewrite
RUN apache2ctl configtest

ADD ./apache2/supervisord.conf /etc/supervisor/conf.d/apache.conf
ADD ./apache2/file_limit.conf /etc/apache2/conf-enabled/file_limit.conf
ADD ./apache2/000-default.conf /etc/apache2/sites-enabled/000-default.conf

ADD ./start.sh /start.sh
RUN chmod 755 /start.sh

ADD ./.htaccess /var/www/html

ADD ./src /var/www/html/

RUN cd /var/www/html; \
    rm composer.lock; \
    sudo rm -R vendor; \
    composer install -vvv --profile; \
    composer dump-autoload; 

RUN chown -R www-data:www-data /var/www/html
RUN sudo chmod -R 777 /var/www/html/storage
RUN sudo chmod -R 777 storage
RUN touch /var/log/error.log
RUN touch /var/log/access.log

#RUN php artisan swagger-lume:generate

EXPOSE 80

CMD ["/bin/bash", "/start.sh"]
