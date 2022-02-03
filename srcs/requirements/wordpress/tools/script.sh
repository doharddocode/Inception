#create new system user
adduser -S www-data
#create new system group
addgroup -S www-data

cd /var/www/html/ || exit 1
if [ ! -d "wordpress" ]; then
  mkdir wordpress
fi
cd wordpress || exit 1

#wait for mariaddb
while ! mariadb -h$MYSQL_HOST -u$MYSQL_USER -p$MYSQL_USER_PASSWORD $WP_DB_NAME
do
  echo "wait for database connection ..."
  sleep 1
done

if [ ! -f ".wp_success" ];
then
  #download wordpress latest
  wp core download --allow-root
  #generate wp-config.php
  wp config create --dbname=$WP_DB_NAME --dbuser=$MYSQL_USER --dbpass=$MYSQL_USER_PASSWORD --dbhost=$MYSQL_HOST \
    --dbcharset="utf8" --dbcollate="utf8_general_ci" --allow-root
  touch .wp_success
fi
if ! $(wp core --allow-root is-installed);
then
  #install wordpress
  wp core install --url='localhost/wordpress' --title='Wordpress Inception Website' --admin_user=$WP_ADMIN_LOGIN \
    --admin_password=$WP_ADMIN_PASSWORD --admin_email=$WP_ADMIN_EMAIL --skip-email --allow-root
  #create general user
  wp user create $WP_USER_LOGIN $WP_USER_EMAIL --role=subscriber --user_pass=$WP_USER_PASSWORD --allow-root
fi

#start fpm
echo "Done!"
/usr/sbin/php-fpm7 -F -R