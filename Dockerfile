FROM nginx:alpine-slim

ARG PHP_UPSTREAM_CONTAINER=php-fpm
ARG PHP_UPSTREAM_PORT=9000

RUN apk update --no-cache && \
    apk upgrade --no-cache
RUN apk add --no-cache \
    logrotate

RUN set -x ; \
    addgroup -g 82 -S www-data ; \
    adduser -u 82 -D -S -G www-data www-data && exit 0 ; exit 1

# Copy 'logrotate' config file
COPY ./nginx.conf /etc/nginx/
COPY ./logrotate/nginx /etc/logrotate.d/
COPY ./startup.sh /opt/startup.sh
RUN sed -i 's/\r//g' /opt/startup.sh

# Create 'messages' file used from 'logrotate'
RUN touch /var/log/messages
# Set Remove the default conf
RUN rm /etc/nginx/conf.d/default.conf
# Set upstream conf
RUN echo "upstream php-upstream { server ${PHP_UPSTREAM_CONTAINER}:${PHP_UPSTREAM_PORT}; }" > /etc/nginx/conf.d/upstream.conf

CMD ["/bin/sh", "/opt/startup.sh"]
