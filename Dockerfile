FROM php as BuildContainer
RUN apt update; apt install -y wget git libzip-dev
RUN pecl install zip; docker-php-ext-enable zip
RUN EXPECTED_CHECKSUM="$(wget -q -O - https://composer.github.io/installer.sig)"
RUN php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
RUN ACTUAL_CHECKSUM="$(php -r "echo hash_file('sha384', 'composer-setup.php');")"
RUN if [ "$EXPECTED_CHECKSUM" != "$ACTUAL_CHECKSUM" ]; then >&2 echo 'ERROR: Invalid installer checksum' && rm composer-setup.php && exit 1; fi
RUN php composer-setup.php --quiet --install-dir=/bin --filename=composer
RUN rm composer-setup.php
RUN composer --version
COPY . /usr/src/WebimageResizer
RUN cd /usr/src/WebimageResizer/display; composer -n i

FROM php:apache
ADD https://raw.githubusercontent.com/mlocati/docker-php-extension-installer/master/install-php-extensions /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions; sync; install-php-extensions imagick

COPY --from=BuildContainer /usr/src/WebimageResizer /var/www/html
RUN mkdir /var/www/html/img
