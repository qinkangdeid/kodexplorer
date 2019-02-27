# Base images 基础镜像
FROM php:7.1-apache-jessie

#RUN 执行以下命令
RUN set -x \
  && mkdir -p /usr/src/kodexplorer \
  && mkdir -p /var/www/html/kodexplorer \
  && apt-get update && apt-get install -y --no-install-recommends ca-certificates wget && rm -rf /var/lib/apt/lists/* \
  && apt-get purge -y --auto-remove ca-certificates wget \
  && rm -rf /var/cache/apk/* \
  && rm -rf /tmp/*


RUN set -x \
  && apt-get update && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libmcrypt-dev \
        libpng12-dev \
  && docker-php-ext-install -j$(nproc) iconv mcrypt \
  && docker-php-ext-configure gd --with-freetype-dir=/usr/include/ --with-jpeg-dir=/usr/include/ \
  && docker-php-ext-install -j$(nproc) gd \
  && rm -rf /var/cache/apk/*

#WORKDIR 相当于cd
WORKDIR /usr/src/kodexplorer
#ADD  文件放在当前目录下，拷过去会自动解压
ADD kodexplorer.tar.gz .


WORKDIR /var/www/html

COPY entrypoint.sh /usr/local/bin/

VOLUME /var/www/html /data

#EXPOSE 映射端口
EXPOSE 80

#ENTRYPOINT 运行以下命令
ENTRYPOINT ["entrypoint.sh"]
#CMD 运行以下命令
CMD ["apache2-foreground"]  
