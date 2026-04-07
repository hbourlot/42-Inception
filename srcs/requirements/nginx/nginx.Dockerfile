FROM alpine:3.22

RUN apk update && apk upgrade

RUN apk add --no-cache nginx openssl

RUN mkdir -p /var/lib/nginx /var/www/html \
	&& chown -R nginx:nginx /var/lib/nginx /var/www

COPY ./tools/nginx_gen.sh /usr/local/bin/nginx_gen.sh
RUN chmod +x /usr/local/bin/nginx_gen.sh

EXPOSE 443

CMD ["/usr/local/bin/nginx_gen.sh"]

