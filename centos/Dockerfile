FROM centos/nginx-116-centos7:latest

LABEL maintainer="adorsys GmbH & Co. KG" \
      vendor="adorsys GmbH & Co. KG" \
      name="adorsys/nginx:centos" \
      org.label-schema.vendor="adorsys GmbH & Co. KG" \
      org.label-schema.name="adorsys/nginx:centos" \
      io.k8s.display-name="adorsys/nginx:centos" \
      summary="adorsys/nginx:centos" \
      io.k8s.description="adorsys/nginx:centos" \
      org.label-schema.description="adorsys/nginx:centos" \
      org.label-schema.schema-version="1.0" \
      org.label-schema.usage="" \
      org.label-schema.license="" \
      org.label-schema.build-date=""

EXPOSE 8080

USER 0

ENV TZ=Europe/Berlin

COPY root/docker-entrypoint.sh /
COPY root/opt/app-root/etc/nginx.default.d /opt/app-root/etc/nginx.default.d

# https://github.com/sclorg/nginx-container/issues/58
RUN yum update -y && yum clean all && rm -rf /var/cache/yum \
    && sed -i '/^\s*location \/ {/ { N; /^\s*location \/ {\n\s*}/d }' "${NGINX_CONF_PATH}" \
    && sed -i 's/default_server//' "${NGINX_CONF_PATH}" \
    && ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone \
    && chmod g=u /etc/passwd \
    && ln -sf /opt/rh/rh-nginx${NGINX_SHORT_VER}/root/usr/share/nginx/html/404.html /opt/app-root/src/404.html \
    && ln -sf /opt/rh/rh-nginx${NGINX_SHORT_VER}/root/usr/share/nginx/html/50x.html /opt/app-root/src/50x.html \
    && touch /opt/app-root/etc/nginx.default.d/logging.conf \
    && chown -R 1001:0 /opt/app-root/etc/nginx.default.d/logging.conf ${NGINX_APP_ROOT}/src \
    && chmod -R g=u /opt/app-root/etc/nginx.default.d/logging.conf ${NGINX_APP_ROOT}/src

# Required if nginx is updated via yum
# should be the same like
# https://github.com/sclorg/nginx-container/blob/master/1.14/Dockerfile#L60
# expect the sed line
RUN chmod a+rwx ${NGINX_CONF_PATH} && \
    chmod -R a+rwx ${NGINX_APP_ROOT}/etc && \
    chmod -R a+rwx /var/opt/rh/rh-nginx${NGINX_SHORT_VER} && \
    chmod -R a+rwx ${NGINX_CONTAINER_SCRIPTS_PATH}/nginx-start && \
    chown -R 1001:0 ${NGINX_APP_ROOT} && \
    chown -R 1001:0 /var/opt/rh/rh-nginx${NGINX_SHORT_VER} && \
    chown -R 1001:0 ${NGINX_CONTAINER_SCRIPTS_PATH}/nginx-start && \
    rpm-file-permissions

USER 1001

ENTRYPOINT ["/docker-entrypoint.sh"]

CMD ["/usr/libexec/s2i/run"]
