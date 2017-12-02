FROM randomcoww/kea-alpine:1.3.0

COPY entrypoint.sh /
ENTRYPOINT ["/entrypoint.sh"]
