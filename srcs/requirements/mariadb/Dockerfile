FROM debian:buster

#install mariaDB
RUN apt update && apt install -y mariadb-server

#copy config
COPY tools/configure.sh /temp/configure.sh

#launch config scripts
CMD ["bash", "/temp/configure.sh"]