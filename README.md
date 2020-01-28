[![](https://img.shields.io/docker/pulls/adorsys/nginx.svg?logo=docker)](https://hub.docker.com/r/adorsys/nginx/)
[![](https://img.shields.io/docker/stars/adorsys/nginx.svg?logo=docker)](https://hub.docker.com/r/adorsys/nginx/)

# adorsys/nginx

https://hub.docker.com/r/adorsys/nginx/

## Description

Provides nginx. If possible use the `ubi` flavor based on the official [`nginx:alpine`](https://hub.docker.com/_/nginx) docker image. 

For secure rootless environments nginx listen on port `8080` by default.

## Example Dockerfile

Copy your files to distribute just to `.`. It points the web root directory
of the nginx container

```dockerfile
FROM adorsys/nginx

COPY dist/ .
```

## Entrypoint hooks

If you need to run addition logic on container start, e.g. correct backend url for angular you can just copy your shell
script to `/docker-entrypoint.d/`.

**Before you do this manually, checkout best-practice example how to run angular apps inside docker without modify the source at
container start: https://github.com/adorsys/example-angular**

#### Example

angular-url.sh
```bash
if [ -f main.js ]; then
  sed -i -e \
    's#___SB_BACKEND_URL___#'"$BACKEND_URL"'#g' \
    main.js
else
  sed -i -e \
    's#___SB_BACKEND_URL___#'"$BACKEND_URL"'#g' \
    main.*.js
fi
```

```dockerfile
FROM adorsys/nginx

COPY dist/ .
COPY angular-url.sh /docker-entrypoint.d/
```

The current directory points to the web http root directory.


## Tags

| Name | Description | Size |
| ---- | ----------- | ---- |
| centos | Based on [RH SCL nginx](https://github.com/sclorg/nginx-container) 1.14 | ![](https://images.microbadger.com/badges/image/adorsys/nginx.svg) |
| alpine | Based on [`nginx:alpine`](https://hub.docker.com/_/nginx) | ![](https://images.microbadger.com/badges/image/adorsys/nginx:alpine.svg) |
| ubi | Based on [RHEL8 UBI](https://developers.redhat.com/blog/2019/05/31/working-with-red-hat-enterprise-linux-universal-base-images-ubi/) | ![](https://images.microbadger.com/badges/image/adorsys/nginx:ubi.svg) |
| latest | Based on [RHEL8 UBI](https://developers.redhat.com/blog/2019/05/31/working-with-red-hat-enterprise-linux-universal-base-images-ubi/) | ![](https://images.microbadger.com/badges/image/adorsys/nginx:ubi.svg) |
