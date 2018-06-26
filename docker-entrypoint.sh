#!/bin/sh

if [ -n "$KEA_LOCAL_CONFIG" ]; then
  echo -en "$KEA_LOCAL_CONFIG" > /etc/kea/kea.conf
fi

## start
rm -f /var/kea/kea*.pid
exec "$@" -c /etc/kea/kea.conf
