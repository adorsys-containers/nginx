#!/bin/sh

set -e

if [ "${NGINX_DISABLE_ACCESS_LOG:-}" = "true" ]; then
  echo "access_log off;" > /etc/nginx/conf.d/logging.conf
fi
