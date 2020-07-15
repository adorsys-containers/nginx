#!/bin/bash

set -euo pipefail

trap 'if docker inspect nginx > /dev/null 2>&1; then docker logs nginx; docker rm -f nginx; fi' INT TERM EXIT

docker run --rm "${DOCKER_IMAGE}:${TAG}" nginx -V
docker run --rm "${DOCKER_IMAGE}:${TAG}" nginx -t
docker run -eNGINX_DISABLE_ACCESS_LOG=true --rm "${DOCKER_IMAGE}:${TAG}" nginx -t

docker run --rm "${DOCKER_IMAGE}:${TAG}" envsubst --help

docker run --rm "${DOCKER_IMAGE}:${TAG}" bash -c 'date | grep -E "CES?T"'
docker run --rm "${DOCKER_IMAGE}:${TAG}" bash -c 'locale | grep -E LC_ALL=.+\.UTF-8'

# Test as Openshift UID
docker run --rm -u 1000090000:0 "${DOCKER_IMAGE}:${TAG}" whoami
docker run --rm -u 1000090000:0 "${DOCKER_IMAGE}:${TAG}" nginx -t

# Test /docker-entrypoint.d/*.sh
docker run --rm -v "$(git rev-parse --show-toplevel)/test-applications/docker-entrypoint.d/test-docker-entrypoint.d.sh":/docker-entrypoint.d/test.sh "${DOCKER_IMAGE}:${TAG}" nginx -t | grep "TEST-ENTRYPOINT-HOOK-WORKS!"

# Test starting nginx
docker run --rm --name nginx -u 1000090000:0 -d -p8080:8080 -v "$(git rev-parse --show-toplevel)/test-applications/nginx/index.html":/usr/share/nginx/html/index.html "${DOCKER_IMAGE}:${TAG}"
sleep 2

curl -sSf localhost:8080 | grep OK
docker logs nginx | grep "GET / HTTP"

curl -sS localhost:8080/non-exists -o /dev/null
docker logs nginx | grep -v '404.html" failed'

