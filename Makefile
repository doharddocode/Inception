all: up

up:
	@systemctl stop nginx
	@systemctl stop mysql
	@mkdir -p /home/oryndoon/data/mariadb
	@mkdir -p /home/oryndoon/data/wordpress
	@echo "127.0.0.1 oryndoon.42.fr" >> /etc/hosts
	@docker-compose -f ./srcs/docker-compose.yml up --build

down:
	@docker-compose -f ./srcs/docker-compose.yml down --volumes

clean:
	@docker system prune --force
	@rm -rf /home/oryndoon/data

re: down clean up

.PHONY: up down clean re