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

EXPOSE 8080

USER 0

ENV TZ=Europe/Berlin \
    LC_ALL=C.UTF-8

# https://bugzilla.redhat.com/show_bug.cgi?id=1611117
COPY --from=TZDATA /usr/share/zoneinfo/UTC /usr/share/zoneinfo/UTC
COPY --from=TZDATA /usr/share/zoneinfo/Europe/Berlin /usr/share/zoneinfo/Europe/Berlin

WORKDIR /usr/share/nginx/html

# Workaround for
# https://github.com/rpm-software-management/microdnf/issues/50
RUN mkdir -p /run/user/$(id -u)

# https://github.com/nginxinc/docker-nginx-unprivileged/blob/master/mainline/stretch/Dockerfile
RUN microdnf update -y && microdnf clean all && rm -rf /var/cache/yum \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && microdnf install --nodocs -y nginx && microdnf clean all \
    && mkdir -p /var/cache/nginx \
    && chown -R 1001:0 /var/cache/nginx /usr/share/nginx/html \
    && chmod -R g=u /var/cache/nginx /usr/share/nginx/html /etc/passwd \
    && rm -rf /usr/share/nginx/html/* \
    && sed -i -e '/listen/!b' -e '/80 default_server;/!b' -e 's/80 default_server;/8080;/' /etc/nginx/nginx.conf \
    && sed -i -e '/user/!b' -e '/nginx/!b' -e '/nginx/d' /etc/nginx/nginx.conf \
    && sed -i 's!/run/nginx.pid!/var/cache/nginx/nginx.pid!g' /etc/nginx/nginx.conf \
    && sed -i "/^http {/a \    proxy_temp_path /var/cache/nginx/proxy_temp;\n    client_body_temp_path /var/cache/nginx/client_temp;\n    fastcgi_temp_path /var/cache/nginx/fastcgi_temp;\n    uwsgi_temp_path /var/cache/nginx/uwsgi_temp;\n    scgi_temp_path /var/cache/nginx/scgi_temp;\n" /etc/nginx/nginx.conf \
    && sed -ri '/location \//,/.*\}/d' /etc/nginx/nginx.conf \
    && grep access_log /etc/nginx/nginx.conf > /etc/nginx/conf.d/logging.conf \
    && sed -i '/access_log/d' /etc/nginx/nginx.conf \
    && sed -i '/error_page/,+2d' /etc/nginx/nginx.conf \
    && chown -R 1001:0 /etc/nginx/conf.d/logging.conf \
    && chmod -R g=u /etc/nginx/conf.d/logging.conf \
    && ln -sf /dev/stdout /var/log/nginx/access.log \
    && ln -sf /dev/stderr /var/log/nginx/error.log

COPY root /

USER 1001

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["nginx", "-g", "daemon off;"]
