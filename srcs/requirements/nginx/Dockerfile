FROM debian:buster

#update packets and install nginx
RUN apt update && apt install -y nginx

#copy configuration to container
COPY ./nginx-configuration ./etc/nginx/conf.d/default.conf

#create directory for ssl cert
RUN mkdir etc/nginx/ssl

#generate open ssl cert
RUN openssl req -new -newkey rsa:4096 -x509 -sha256 -days 365 -nodes -out /etc/nginx/ssl/oryndoon.pem \
            -keyout /etc/nginx/ssl/oryndoon.key -subj "/C=RU/ST=moscow/L=moscow/O=school21/CN=oryndoon"

#start nginx
ENTRYPOINT ["nginx", "daemon off"]

