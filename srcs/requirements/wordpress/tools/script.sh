cd /var/www/html/ || exit 1

#create new system user
adduser -S www-data
#create new system group
addgroup -S www-data

if [ ! -f ".wp_success" ];
then
  #download wordpress latest
  wp core download --allow-root
  #generate wp-config.php
  wp config create --dbname=$WP_DB_NAME --dbuser=$MYSQL_USER --dbpass=$MYSQL_USER_PASSWORD --dbhost=$MYSQL_HOST \
    --dbcharset="utf8" --dbcollate="utf8_general_ci" --skip-check --allow-root
  touch .wp_success
fi

#install wp
if ! $(wp core --allow-root is-installed);
then
  #install wordpress
  wp core install --url=$DOMAIN --title='Wordpress Inception Website' --admin_user=$WP_ADMIN_LOGIN \
    --admin_password=$WP_ADMIN_PASSWORD --admin_email=$WP_ADMIN_EMAIL --skip-email --allow-root
  #create common user
  wp user create $WP_USER_LOGIN $WP_USER_EMAIL --role=subscriber --user_pass=$WP_USER_PASSWORD --allow-root
fi

#start php-fpm
echo "Wordpress is ready!"
php-fpm7 -F