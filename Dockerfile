## based on haproxy dockerfile
## https://github.com/docker-library/haproxy/blob/master/1.8/alpine/Dockerfile

FROM alpine:edge

ENV KEA_VERSION kea-1-4-0-p1

RUN set -x \
  \
  && echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories \
  && apk add --no-cache --virtual .build-deps \
    mariadb-dev \
    postgresql-dev \
    boost-dev \
    log4cplus-dev \
    autoconf \
    make \
    automake \
    libtool \
    g++ \
  \
## build kea
  && cd / \
  && wget -O kea.tar.gz https://www.isc.org/downloads/file/$KEA_VERSION/?version=tar-gz \
  && mkdir -p /usr/src/kea \
  && tar xf kea.tar.gz --strip-components=1 -C /usr/src/kea \
  && rm kea.tar.gz \
  && cd /usr/src/kea \
  \
  && autoreconf \
    --install \
  && CXXFLAGS='-Os' ./configure \
    --prefix=/usr/local \
    --sysconfdir=/etc \
    --localstatedir=/var \
    --with-mysql \
    --with-pgsql \
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


COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
