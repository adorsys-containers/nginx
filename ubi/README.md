# nginx (ubi flavor)

## Paths

* `/usr/share/nginx/html/`: Webroot
* `/etc/nginx/conf.d/`: Configs for inside http block
* `/etc/nginx/default.d/` Configs for inside server block

## Environment

| Key | Description | Default |
|-----|-------------|---------|
| NGINX_DISABLE_ACCESS_LOG | If `true`, disable access log in console | `unset` |
