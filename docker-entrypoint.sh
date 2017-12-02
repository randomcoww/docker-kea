#!/bin/sh

echo -en "$CONFIG" > /etc/kea/kea.conf

## start
rm -f /var/kea/kea*.pid
exec "$@" -c /etc/kea/kea.conf
