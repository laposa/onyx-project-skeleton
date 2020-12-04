FROM debian:stretch

USER root

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update \
  && apt-get -y upgrade \
  && apt-get install -y apache2 php php-fpm php-recode php-pgsql php-tidy php-gd php-imagick php-curl php-mcrypt php-xml\
  php-mbstring postgresql-client imagemagick php-memcached php-memcache php-soap php-zip php-bcmath php-intl unzip memcached \
  supervisor curl wget gnupg apt-transport-https vim locales-all

COPY ./etc/ /etc/
COPY entrypoint.sh /usr/local/bin/

# Fix Vim mouse issue
RUN echo "let skip_defaults_vim = 1\nsyntax on\nset mouse-=a\nset expandtab\nset shiftwidth=4\nset tabstop=4" > /etc/vim/vimrc.local

ADD . /var/www/
WORKDIR /var/www/

RUN a2enconf laposa 
RUN a2enmod vhost_alias ssl rewrite expires headers deflate

# enable php-fpm
RUN a2enmod proxy_fcgi setenvif \
  && a2enconf php7.0-fpm \
  && a2dismod php7.0

# logs should go to stdout / stderr
RUN ln -sfT /dev/stderr /var/log/apache2/error.log \
        && ln -sfT /dev/stdout /var/log/apache2/access.log \
        && ln -sfT /dev/stdout /var/log/apache2/other_vhosts_access.log \
        && ln -sfT /dev/stdout /var/log/php7.0-fpm.log

# need this to create /run/php/php7.0-fpm.pid and /run/php/php7.0-fpm.sock
RUN service php7.0-fpm start

# can be overwriten in k8s?
ENV APACHE_LISTEN_PORT 8080
ENV APACHE_LISTEN_PORT_TLS 8443

EXPOSE ${APACHE_LISTEN_PORT}/tcp
EXPOSE ${APACHE_LISTEN_PORT_TLS}/tcp

# fix permissions for running as non-root
RUN adduser www-data tty \
  && chown -R www-data /var/log/ \
  && chown www-data -R /var/run/

# allow to change configuration in container for debugging
RUN chown -R www-data /var/www/conf/

# install composer
RUN cd /tmp && \
    curl -sS https://getcomposer.org/installer | php && \
    mv composer.phar /usr/local/bin/composer && \
    mkdir /var/www/.composer && \
    chown -R www-data:www-data /var/www/.composer

# install packages
RUN cd /var/www/ && \
    composer install --no-interaction

# link onyx to vendor package
RUN ln -s vendor/laposa/onyx

# allow vendor directory writeble for debugging
#RUN chown -R www-data vendor

# switch to non-root, disable for debugging
USER www-data

ENV DEBIAN_FRONTEND teletype

ENTRYPOINT ["entrypoint.sh"]
