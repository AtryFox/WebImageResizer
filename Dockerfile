FROM php as BuildContainer
RUN apt update && apt install git libzip-dev -y && pecl install zip && docker-php-ext-enable zip
RUN cd /usr/src && php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');" \
&& php -r "if (hash_file('sha384', 'composer-setup.php') === '48e3236262b34d30969dca3c37281b3b4bbe3221bda826ac6a9a62d6444cdb0dcd0615698a5cbe587c3f0fe57a54d8f5') { echo 'Installer verified'; } else { echo 'Installer corrupt'; unlink('composer-setup.php'); } echo PHP_EOL;" && \
php composer-setup.php --install-dir=/usr/local/bin --filename=composer && php -r "unlink('composer-setup.php');" && \
chmod +x /usr/local/bin/composer
COPY . /usr/src/WebimageResizer
RUN cd /usr/src/WebimageResizer/display && composer -n i

FROM php:apache
RUN apt update && apt install libmagick++-dev -y && pecl install imagick && docker-php-ext-enable imagick && \
a2enmod rewrite

COPY --from=BuildContainer /usr/src/WebimageResizer /var/www/html
RUN mkdir /var/www/html/img
