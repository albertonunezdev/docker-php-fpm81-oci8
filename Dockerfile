FROM php:8.1-fpm

# Instala dependencias
RUN apt-get update && apt-get upgrade -y && apt-get install -y \
        libz-dev \
        libpq-dev \
        libjpeg-dev \
        libpng-dev \
        libfreetype6-dev \
        libssl-dev \
        zlib1g-dev \
        libxml2-dev \
        libonig-dev \
        zip \
        curl \
        libmemcached-dev \
        build-essential \
        libaio1 \
        libzip-dev \
        gnupg \
        libmagickwand-dev --no-install-recommends \
        libsodium-dev \
        libbz2-dev \
        libicu-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libxpm-dev \
        libvpx-dev \
        libfreetype6-dev \
        libreadline-dev \
        libedit-dev \
        libxslt1-dev \
        libffi-dev \
        imagemagick \
        unzip \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-configure intl \
    && docker-php-ext-install -j$(nproc) gd \
    && docker-php-ext-install pdo_mysql \
    && docker-php-ext-install mysqli \
    && docker-php-ext-install zip \
    && docker-php-ext-install bcmath \
    && docker-php-ext-install exif \
    && docker-php-ext-install intl \
    && docker-php-ext-install soap \
    && docker-php-ext-install sockets \
    && docker-php-ext-install sodium \
    && docker-php-ext-install opcache \
    && docker-php-ext-install bz2 \
    && pecl install imagick \
    && docker-php-ext-enable imagick \
    && docker-php-source delete

# Copia Oracle Instant Client desde la carpeta Oracle
COPY oracle/instantclient-basic-linux.x64-19.23.0.0.0dbru.zip /tmp/
COPY oracle/instantclient-sdk-linux.x64-19.23.0.0.0dbru.zip /tmp/
COPY oracle/instantclient-sqlplus-linux.x64-19.23.0.0.0dbru.zip /tmp/

# Verifica los archivos copiados
RUN ls -l /tmp/instantclient*.zip

RUN unzip -o /tmp/instantclient-basic-linux.x64-19.23.0.0.0dbru.zip -d /usr/local/ \
    && unzip -o /tmp/instantclient-sdk-linux.x64-19.23.0.0.0dbru.zip -d /usr/local/ \
    && unzip -o /tmp/instantclient-sqlplus-linux.x64-19.23.0.0.0dbru.zip -d /usr/local/

RUN ln -s /usr/local/instantclient_19_23 /usr/local/instantclient || true
RUN ln -sf /usr/local/instantclient_19_23/libclntsh.so.19.1 /usr/local/instantclient/libclntsh.so
RUN ln -sf /usr/local/instantclient_19_23/libocci.so.19.1 /usr/local/instantclient/libocci.so
RUN ln -sf /usr/local/instantclient_19_23/sqlplus /usr/bin/sqlplus

RUN sh -c 'echo /usr/local/instantclient > /etc/ld.so.conf.d/oracle-instantclient.conf'

RUN echo 'export ORACLE_HOME=/usr/local/instantclient' >> /root/.bashrc
RUN echo 'export LD_LIBRARY_PATH=/usr/local/instantclient' >> /root/.bashrc
RUN echo 'export PATH=$PATH:/usr/local/instantclient' >> /root/.bashrc

RUN echo "LD_LIBRARY_PATH=/usr/local/instantclient" >> /etc/environment \
    && echo "ORACLE_HOME=/usr/local/instantclient" >> /etc/environment

RUN ldconfig

RUN pecl channel-update pecl.php.net

# Instala oci8 3.2.1
RUN echo "instantclient,/usr/local/instantclient" | pecl install oci8-3.2.1 \
    && docker-php-ext-enable oci8

# Instala y habilita pdo-oci
RUN docker-php-ext-configure pdo_oci --with-pdo-oci=instantclient,/usr/local/instantclient,19.23 \
    && docker-php-ext-install pdo_oci

# Copia php.ini al contenedor
COPY php/php.ini /usr/local/etc/php/

RUN docker-php-ext-enable opcache

# Instala Composer
RUN curl -sS https://getcomposer.org/installer | php -- \
    --install-dir=/usr/local/bin \
    --filename=composer

WORKDIR /var/www/html

# Añade usuario para la aplicación
RUN useradd -G www-data,root -u 1000 -d /var/www/html www

# Crea el directorio para Composer y ajustar permisos
RUN mkdir -p /var/www/html/.composer \
    && chown -R www:www /var/www/html \
    && chmod -R 755 /var/www/html

# Cambia el usuario actual a www
USER www

# Expone el puerto 9000
EXPOSE 9000

# Inicia el servidor PHP-FPM
CMD ["php-fpm"]
