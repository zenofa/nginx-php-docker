FROM zenofa/nginx-pagespeed:1.14.2

LABEL maintainer=marda.firmansyah@gmail.com

ENV DEBIAN_FRONTEND noninteractive

RUN wget --no-check-certificate -O - https://download.newrelic.com/548C16BF.gpg | apt-key add - && \
    sh -c 'echo "deb http://apt.newrelic.com/debian/ newrelic non-free" > /etc/apt/sources.list.d/newrelic.list' && \
	add-apt-repository ppa:ondrej/php -y && \
    apt-get update && \
    apt-get -y --no-install-recommends install \
		exim4 \
		php7.3 \
		php7.3-cli \
		php7.3-curl \
        php7.3-fpm \
		php7.3-gd \
		php7.3-imagick \
		php7.3-imap \
        php7.3-intl \
        php7.3-mbstring \
        php7.3-mysql \
        php7.3-memcached \
        php7.3-memcache \
        php7.3-recode \
        php7.3-redis \
        php7.3-soap \
		php7.3-xdebug \
		php7.3-xml \
		php7.3-xsl \
		php7.3-zip \
		newrelic-php5 && \
    newrelic-install install && \
	apt-get clean && \
    rm -Rf /tmp/* /var/tmp/* /var/lib/apt/lists/*

RUN mkdir /root/bin/ && \
	echo "export PATH=/root/bin:$PATH" > /root/.bashrc

EXPOSE 443
EXPOSE 8080

ENV PHP_VERSION 7.3

ENV DEFAULT_ADMIN_EMAIL nobody@example.com
ENV DEFAULT_APP_ENV production
ENV DEFAULT_CHOWN_APP_DIR false
ENV DEFAULT_VIRTUAL_HOST example.com
ENV DEFAULT_APP_HOSTNAME example.com
ENV DEFAULT_APP_USER app
ENV DEFAULT_APP_GROUP app
ENV DEFAULT_APP_UID 1000
ENV DEFAULT_APP_GID 1000
ENV DEFAULT_UPLOAD_MAX_SIZE 30M
ENV DEFAULT_NGINX_MAX_WORKER_PROCESSES 8
ENV DEFAULT_NGINX_KEEPALIVE_TIMEOUT 30 
ENV DEFAULT_PHP_MEMORY_LIMIT 128M
ENV DEFAULT_PHP_MAX_EXECUTION_TIME 300
ENV DEFAULT_PHP_MAX_INPUT_VARS 2000
ENV DEFAULT_PHP_PROCESS_MANAGER dynamic
ENV DEFAULT_PHP_MAX_CHILDREN 6
ENV DEFAULT_PHP_START_SERVERS 3
ENV DEFAULT_PHP_MIN_SPARE_SERVERS 2
ENV DEFAULT_PHP_MAX_SPARE_SERVERS 3
ENV DEFAULT_PHP_MAX_REQUESTS 500
ENV DEFAULT_PHP_DISABLE_FUNCTIONS false
ENV DEFAULT_PHP_XDEBUG_REMOTE_HOST 172.17.42.1
ENV DEFAULT_PHP_XDEBUG_REMOTE_PORT 9000
ENV DEFAULT_PHP_XDEBUG_IDE_KEY default_ide_key
ENV DEFAULT_PHP_CLEAR_ENV yes
ENV DEFAULT_EXIM_DELIVERY_MODE local
ENV DEFAULT_EXIM_MAIL_FROM example.com
ENV DEFAULT_EXIM_SMARTHOST smtp.example.org::587
ENV DEFAULT_EXIM_SMARTHOST_AUTH_USERNAME postmaster@example.com
ENV DEFAULT_EXIM_SMARTHOST_AUTH_PASSWORD password_123

ENV DEFAULT_NEWRELIC_ENABLED true
ENV DEFAULT_NEWRELIC_LICENSE DISABLED

COPY . /app

RUN chmod 750 /app/bin/*

RUN /app/bin/init_php.sh

ENTRYPOINT ["/app/bin/boot.sh"]

CMD ["/sbin/my_init"]
