## based on haproxy dockerfile
## https://github.com/docker-library/haproxy/blob/master/1.8/alpine/Dockerfile

FROM alpine:3.6

ENV LOG_VERSION REL_1_2_0
ENV KEA_BRANCH 1_3_0

RUN set -x \
  \
  && apk add --no-cache --virtual .build-deps \
      libressl \
      mariadb-dev \
      postgresql-dev \
      boost-dev \
      autoconf \
      make \
      automake \
      libtool \
      g++ \
  \
  && mkdir -p /usr/src \
  \
## build log4cplus
  && cd / \
  && wget -O log4cplus.zip https://github.com/log4cplus/log4cplus/archive/$LOG_VERSION.zip \
  && unzip -d /usr/src log4cplus.zip \
  && rm log4cplus.zip \
  && cd /usr/src/log4cplus-$LOG_VERSION \
  \
  && autoreconf \
      --install \
      --force \
      --warnings=all \
  && CXXFLAGS='-Os' ./configure \
      --prefix=/usr/local \
      --with-working-locale \
      --enable-static=false \
  && make -j "$(getconf _NPROCESSORS_ONLN)" \
  && make install \
  \
## build kea
  && cd / \
  && wget -O kea.zip https://github.com/isc-projects/kea/archive/v$KEA_BRANCH.zip \
  && unzip -d /usr/src kea.zip \
  && rm kea.zip \
  && cd /usr/src/kea-$KEA_BRANCH \
  \
  && autoreconf \
      --install \
  && CXXFLAGS='-Os' ./configure \
      --prefix=/usr/local \
      --sysconfdir=/etc \
      --localstatedir=/var \
      --with-log4cplus=/usr/local/lib \
      --with-dhcp-mysql \
      --with-dhcp-pgsql \
      --with-openssl \
      --enable-static=false \
  && make -j "$(getconf _NPROCESSORS_ONLN)" \
  && make install \
  \
## cleanup
  && cd / \
  && rm -rf /usr/src \
  \
  && runDeps="$( \
    scanelf --needed --nobanner --format '%n#p' --recursive /usr/local \
      | tr ',' '\n' \
      | sort -u \
      | awk 'system("[ -e /usr/local/lib/" $1 " ]") == 0 { next } { print "so:" $1 }' \
  )" \
  && apk add --virtual .kea-rundeps $runDeps \
  && apk del .build-deps
