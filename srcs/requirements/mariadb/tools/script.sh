if [ ! -d "/run/mysqld" ]; then
	mkdir -p /run/mysqld
	chown -R mysql:mysql /run/mysqld
fi

if [ ! -d "/var/lib/mysql/mysql" ]; then
  chown -R mysql:mysql /var/lib/mysql
  #init database
  mysql_install_db -basedir="/usr" --user=mysql --datadir="/var/lib/mysql"
  touch .sql
  {
     echo "CREATE DATABASE $WP_DB_NAME;";
     echo "CREATE USER '${MYSQL_USER}' IDENTIFIED BY '${MYSQL_USER_PASSWORD}';";
     echo "GRANT ALL PRIVILEGES ON ${WP_DB_NAME}.* TO '${MYSQL_USER}'@'%';";
     echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '${MYSQL_ROOT_PASSWORD}';";
     echo "FLUSH PRIVILEGES;";
  } >> .sql
  /usr/bin/mysqld -user=root --bootstrap --skip-grant-tables=false < .sql
  rm .sql
fi

#allow all incoming connection
sed -i "s|.*bind-address\s*=.*|bind-address=0.0.0.0|g" /etc/my.cnf.d/mariadb-server.cnf
#improve perfomance responses \
sed -i "s|.*skip-networking.*|skip-networking|g" /etc/my.cnf.d/mariadb-server.cnf

#start mariadb daemon
exec /usr/bin/mysqld --user=root
