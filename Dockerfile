FROM  ubuntu:16.04
MAINTAINER flycmd<root@flycmd.com>

USER root
ENV TIME_ZONE=Asia/Shanghai
RUN echo "${TIME_ZONE}" > /etc/timezone \
    && ln -sf /usr/share/zoneinfo/${TIME_ZONE} /etc/localtime

COPY ./source/zookeeper-0.3.0.tgz /
COPY ./source/zookeeper-3.4.12.tar.gz /

RUN apt-get update && apt-get install -y --no-install-recommends\
    apt-utils \
    build-essential \
    gcc \
    autoconf \
    automake \
    libtool \
    make \
    re2c \
    cmake  \
    curl \
    wget \
    libpcre3-dev \
    vim \
    supervisor \
    nginx \
    python-software-properties \
    software-properties-common \
    openssl \
    libssl-dev \
    libyaml-dev \
    && LC_ALL=C.UTF-8 add-apt-repository ppa:ondrej/php \
    && apt-get update && apt-get install -y --no-install-recommends \
    php7.0-dev \
    php7.0-fpm \
    php7.0-mysql \
    php7.0-common \
    php7.0-curl \
    php7.0-cli \
    php7.0-mcrypt \
    php7.0-mbstring \
    php7.0-dom \
    php-redis \
    php-mongodb \
    php-gd \
    php7.0-bcmath \
    && apt-get clean \
    && rm -fr /var/lib/apt/lists/* \
####
#zookeeper
####
    && cd / \
    && tar -xvzf zookeeper-3.4.12.tar.gz \
    && cd zookeeper-3.4.12/src/c \
    && ./configure --prefix=/usr/local/zookeeper \
    && make \
    && make install \
###
#zookeeper extentsion
###
    && cd / \
    && tar -zxvf zookeeper-0.3.0.tgz \
    && cd zookeeper-0.3.0 \
    && phpize \
    && ./configure --with-php-config=/usr/bin/php-config --with-libzookeeper-dir=/usr/local/zookeeper/ \
    && make \
    && make install \
    && rm -rf /zookeeper-0.3.0.tgz \
    && rm -rf /zookeeper-3.4.12.tar.gz \
    && rm -rf /zookeeper-0.3.0 \
    && rm -rf /zookeeper-3.4.12

#nginx conf 目录  /etc/nginx/nginx.conf
ADD nginx/sites-enabled/default /etc/nginx/sites-enabled/
ADD nginx/nginx.conf /etc/nginx/nginx.conf
ADD  ./conf/php.ini /etc/php/7.0/fpm/php.ini
ADD  ./conf/supervisord.conf /etc/supervisor/conf.d/supervisord.conf
ADD  ./script/run.sh /run.sh
RUN  chmod 755 /run.sh

VOLUME ["/var/www"]
WORKDIR "/var/www"
EXPOSE 80

CMD ["/run.sh"]