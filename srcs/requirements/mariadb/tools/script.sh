if [ ! -d "/run/mysqld" ]; then
	mkdir -p /run/mysqld
	chown -R mysql:mysql /run/mysqld
fi

if [ ! -f ".sql" ]; then
  chown -R mysql:mysql /var/lib/mysql
  mysql_install_db --basedir=/usr --datadir=/var/lib/mysql --user=mysql
  touch .sql
  {
    echo "USE mysql;";
    echo "DELETE FROM	mysql.user WHERE User='';";
    echo "DROP DATABASE test;";
    echo "DELETE FROM mysql.db WHERE Db='test';";
    echo "DELETE FROM mysql.user WHERE User='root' AND Host NOT IN ('localhost', '127.0.0.1', '::1');";
    echo "CREATE DATABASE $WP_DB_NAME;"
    echo "CREATE USER '$MYSQL_USER'@'%' IDENTIFIED BY '$MYSQL_USER_PASSWORD';";
    echo "GRANT ALL PRIVILEGES ON $WP_DB_NAME.* TO '$MYSQL_USER'@'%';";
    echo "ALTER USER 'root'@'localhost' IDENTIFIED BY '$MYSQL_ROOT_PASSWORD';";
    echo "FLUSH PRIVILEGES;";
  } >> .sql
  /usr/bin/mysqld --user=mysql --bootstrap --skip-grant-tables=false < .sql
fi

#allow all incoming connection
sed -i "s|skip-networking|# skip-networking|g" /etc/my.cnf.d/mariadb-server.cnf
#improve perfomance responses
sed -i "s|.*bind-address\s*=.*|bind-address=0.0.0.0|g" /etc/my.cnf.d/mariadb-server.cnf

#start mysql daemon
/usr/bin/mysqld --user=mysql
