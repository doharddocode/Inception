FROM alpine:3.13

RUN	apk update && apk upgrade && apk add nginx openssl

#create directory for ssl cert
RUN mkdir etc/nginx/ssl
#generate open ssl cert
RUN openssl req -new -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out /etc/nginx/ssl/oryndoon.pem \
            -keyout /etc/nginx/ssl/oryndoon.key -subj "/C=RU/ST=moscow/L=moscow/O=school21/CN=oryndoon"

#create directory for logs
RUN mkdir /var/tmp/logs/

# nginx config
RUN mkdir -p /run/nginx
COPY nginx.conf /etc/nginx/conf.d/default.conf

#start nginx
ENTRYPOINT ["nginx", "-g", "daemon off;"]