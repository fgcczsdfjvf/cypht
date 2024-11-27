FROM php:8.1-apache

# 安装依赖
RUN apt-get update && apt-get install -y \
    libxml2-dev \
    git \
    libc-client-dev \
    libkrb5-dev \
    unzip \
    && docker-php-ext-configure imap --with-kerberos --with-imap-ssl \
    && docker-php-ext-install imap xml

# 安装 Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# 启用 Apache 模块
RUN a2enmod rewrite

# 克隆 Cypht
RUN git clone https://github.com/cypht-org/cypht.git /var/www/html/

# 安装依赖
WORKDIR /var/www/html
RUN composer install --no-dev

# 设置权限
RUN chown -R www-data:www-data /var/www/html/

EXPOSE 80
