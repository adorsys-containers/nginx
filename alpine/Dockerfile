FROM nginx:stable-alpine

LABEL maintainer="adorsys GmbH & Co. KG" \
      vendor="adorsys GmbH & Co. KG" \
      name="adorsys/nginx:alpine" \
      org.label-schema.vendor="adorsys GmbH & Co. KG" \
      org.label-schema.name="adorsys/nginx:alpine" \
      io.k8s.display-name="adorsys/nginx:alpine" \
      summary="adorsys/nginx:alpine" \
      io.k8s.description="adorsys/nginx:alpine" \
      org.label-schema.description="adorsys/nginx:alpine" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.usage="" \
      org.label-schema.license="" \
      org.label-schema.build-date=""

EXPOSE 8080

USER 0

ENV TZ=Europe/Berlin

WORKDIR /usr/share/nginx/html

COPY root /

# https://github.com/nginxinc/docker-nginx-unprivileged/blob/master/mainline/stretch/Dockerfile
RUN apk --no-cache upgrade \
    && mkdir -p /var/cache/nginx /etc/nginx/conf.default.d/ /etc/nginx/default.d/ \
    && chown -R 1001:0 /var/cache/nginx /usr/share/nginx/html /etc/nginx/conf.d/default.conf \
    && chmod -R g=u /var/cache/nginx /usr/share/nginx/html /etc/passwd \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && rm -rf /usr/share/nginx/html/* /docker-entrypoint.d/10-listen-on-ipv6-by-default.sh \
    && sed -i -e '/listen/!b' -e '/80;/!b' -e 's/80;/8080;/' /etc/nginx/conf.d/default.conf \
    && sed -i -e '/user/!b' -e '/nginx/!b' -e '/nginx/d' /etc/nginx/nginx.conf \
    && sed -i 's!/var/run/nginx.pid!/var/cache/nginx/nginx.pid!g' /etc/nginx/nginx.conf \
    && sed -i "/^http {/a \    proxy_temp_path /var/cache/nginx/proxy_temp;\n    client_body_temp_path /var/cache/nginx/client_temp;\n    fastcgi_temp_path /var/cache/nginx/fastcgi_temp;\n    uwsgi_temp_path /var/cache/nginx/uwsgi_temp;\n    scgi_temp_path /var/cache/nginx/scgi_temp;\n" /etc/nginx/nginx.conf \
    && sed -ri '/location \//,/.*\}/d' /etc/nginx/conf.d/default.conf \
    && sed -i -e '/localhost/a\' -e'    include /etc/nginx/conf.default.d/*.conf;' /etc/nginx/conf.d/default.conf \
    && sed -i -e '/localhost/a\' -e'    include /etc/nginx/default.d/*.conf;' /etc/nginx/conf.d/default.conf \
    && sed -i -e '/localhost/a\' -e'    root         \/usr\/share\/nginx\/html;' /etc/nginx/conf.d/default.conf \
    && grep access_log /etc/nginx/nginx.conf > /etc/nginx/conf.d/logging.conf \
    && sed -i '/access_log/d' /etc/nginx/nginx.conf \
    && chown -R 1001:0 /etc/nginx/conf.d/logging.conf \
    && chmod -R g=u /etc/nginx/conf.d/logging.conf

USER 1001
