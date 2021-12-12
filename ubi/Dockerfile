FROM registry.access.redhat.com/ubi8/ubi:latest AS TZDATA

FROM registry.access.redhat.com/ubi8/ubi-minimal:latest

LABEL maintainer="adorsys GmbH & Co. KG" \
      vendor="adorsys GmbH & Co. KG" \
      name="adorsys/nginx:ubi" \
      org.label-schema.vendor="adorsys GmbH & Co. KG" \
      org.label-schema.name="adorsys/nginx:ubi" \
      io.k8s.display-name="adorsys/nginx:ubi" \
      summary="adorsys/nginx:ubi" \
      io.k8s.description="adorsys/nginx:ubi" \
      org.label-schema.description="adorsys/nginx:ubi" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.usage="" \
      org.label-schema.license="" \
      org.label-schema.build-date=""

ARG NGINX_STREAM=1.20

EXPOSE 8080

USER 0

ENV TZ=Europe/Berlin \
    LC_ALL=C.UTF-8

# https://bugzilla.redhat.com/show_bug.cgi?id=1611117
COPY --from=TZDATA /usr/share/zoneinfo/UTC /usr/share/zoneinfo/UTC
COPY --from=TZDATA /usr/share/zoneinfo/Europe/Berlin /usr/share/zoneinfo/Europe/Berlin

WORKDIR /usr/share/nginx/html

# https://github.com/nginxinc/docker-nginx-unprivileged/blob/master/mainline/stretch/Dockerfile
RUN microdnf --noplugins update -y && microdnf --noplugins clean all && rm -rf /var/cache/yum \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && printf '[nginx]\nname=nginx\nstream=%s\nprofiles=\nstate=enabled' "${NGINX_STREAM}" > /etc/dnf/modules.d/nginx.module \
    && microdnf --noplugins install --nodocs -y nginx gettext && microdnf --noplugins clean all \
    && mkdir -p /var/cache/nginx \
    && rm -rf /usr/share/nginx/html/* \
    && sed -i -e '/listen/!b' -e '/80;/!b' -e 's/80;/8080;/' /etc/nginx/nginx.conf \
    && sed -i -e '/user/!b' -e '/nginx/!b' -e '/nginx/d' /etc/nginx/nginx.conf \
    && sed -i 's!/run/nginx.pid!/var/cache/nginx/nginx.pid!g' /etc/nginx/nginx.conf \
    && sed -i "/^http {/a \    proxy_temp_path /var/cache/nginx/proxy_temp;\n    client_body_temp_path /var/cache/nginx/client_temp;\n    fastcgi_temp_path /var/cache/nginx/fastcgi_temp;\n    uwsgi_temp_path /var/cache/nginx/uwsgi_temp;\n    scgi_temp_path /var/cache/nginx/scgi_temp;\n" /etc/nginx/nginx.conf \
    && grep access_log /etc/nginx/nginx.conf > /etc/nginx/conf.d/logging.conf \
    && sed -i '/access_log/d' /etc/nginx/nginx.conf \
    && sed -i '/error_page/,+2d' /etc/nginx/nginx.conf \
    && chown -R 999:0 /var/cache/nginx /usr/share/nginx/html /etc/nginx/conf.d \
    && chmod -R g=u /var/cache/nginx /usr/share/nginx/html /etc/passwd /etc/nginx/conf.d/ \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

COPY root /

USER 999

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]
