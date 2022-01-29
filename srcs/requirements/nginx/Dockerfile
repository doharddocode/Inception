FROM debian:buster

#update packets and install nginx
RUN apt update && apt install -y nginx openssl libssl-dev

#copy configuration to container
COPY nginx.conf /etc/nginx/conf.d/default.conf

#create directory for ssl cert
RUN mkdir etc/nginx/ssl

#generate open ssl cert
RUN openssl req -new -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out /etc/nginx/ssl/oryndoon.pem \
            -keyout /etc/nginx/ssl/oryndoon.key -subj "/C=RU/ST=moscow/L=moscow/O=school21/CN=oryndoon"

#create directory for log
RUN mkdir /var/tmp/logs/

#create website directory
WORKDIR /var/www/html

#start nginx
ENTRYPOINT ["nginx", "-g", "daemon off;"]