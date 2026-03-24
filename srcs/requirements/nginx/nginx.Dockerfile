FROM nginx:stable-alpine

RUN apk add --no-cache openssl

COPY ./tools/nginx_gen.sh /usr/local/bin/nginx_gen.sh
RUN chmod +x /usr/local/bin/nginx_gen.sh

EXPOSE 443

CMD ["/usr/local/bin/nginx_gen.sh"]