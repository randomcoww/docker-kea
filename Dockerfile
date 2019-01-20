FROM alpine:edge

RUN set -x \
  \
  && echo http://dl-cdn.alpinelinux.org/alpine/edge/testing >> /etc/apk/repositories \
  && apk add --no-cache \
    kea-dhcp4 \
    kea-dhcp6 \
    kea-dhcp-ddns \
    kea-ctrl-agent

COPY docker-entrypoint.sh /
ENTRYPOINT ["/docker-entrypoint.sh"]
