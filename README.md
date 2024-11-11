# NGINX base image

A base image to build nginx docker images fast.

The image sets up log rotation, upstream and periodic server restart.
The server defines upstream by default to be `php-fpm:9000`.

## Build
For local build, use for instance:

```
docker build -t base-nginx:alpine-slim . 
```

For docker hub build, use:

```
docker build -t ifullgaz/base-nginx:alpine-slim . 
```

To upload the docker hub build  to docker hub, use (providing you have the appropriate permissions):

```
docker push ifullgaz/base-nginx:alpine-slim
```

## Usage
1] Use the **FROM** tag at the top of the Dockerfile, such as:

```
FROM ifullgaz/base-nginx:alpine-slim
```

2] Copy any site definition files to `/etc/nginx/sites-available/`. For example:

```
COPY ./docker/nginx/sites/* /etc/nginx/sites-available/
```

3] Should the upstream destination be different from the default, the following lines may be added:

```
ARG PHP_UPSTREAM_CONTAINER=php-fpm
ARG PHP_UPSTREAM_PORT=9000
RUN echo "upstream php-upstream { server ${PHP_UPSTREAM_CONTAINER}:${PHP_UPSTREAM_PORT}; }" > /etc/nginx/conf.d/upstream.conf
```
