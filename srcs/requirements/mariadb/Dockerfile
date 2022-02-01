FROM alpine:3.13

#install mariadb server and mariadb command line tools
RUN apk update && apk upgrade && apk add mariadb mariadb-client mariadb-common openrc

#copy shell script to container
COPY tools/ ./tmp/tools

CMD ["sh", "tmp/tools/script.sh"]