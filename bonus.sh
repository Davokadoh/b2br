apt install lighttpd mariadb-server php-fastcgi php-mysql

ufw allow 80
echo "Starting mysql_secure_installation"
echo "Answer no (n) only to the first question"
mysql_secure_installation
echo "End of mysql_secure_installation"

echo "Creating database"
mariadb -e "CREATE DATABASE mydb;"
echo "Granting privileges"
mariadb -e "GRANT ALL ON mydb.* TO dumyuser@localhost WITH GRANT OPTION;"
mariadb -e "FLUSH PRIVILEGES;"

echo "Downloading Wordpress"
wget http://wordpress.org/latest.tar.gz -P /var/www/html
echo "Extracting archive"
tar -xzvf /var/www/html/latest.tar.gz /var/www/html
echo "Deleting archive"
rm /var/www/html/latest.tar.gz
echo "Moving files"
cp -r /var/www/html/wordpress/* /var/www/html
rm -rf /var/www/html/wordpress
echo "Copying config from sample"
cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

echo "Inserting database and user names in config file"
sed -i -e "s/'database_name_here'/mydb/g" /var/www/html/wp-config.php
sed -i -e "s/'username_here'/dumyuser/g" /var/www/html/wp-config.php

echo "Enabling lighttpd mods (?)"
lighty-enable-mod fastcgi
lighty-enable-mod fastcgi-php
service lighttpd force-reload

git clone git@github.com:unrealircd/unrealircd.git
cd unrealircd.git
./Config
make
make install
cd /home/jleroux/unrealircd
cp conf/examples/example.conf conf/unrealircd.conf
modify unrealircd.conf
./unrealircd start



me block
<name-of-server>/irc.42.ch

admin block
"Joachim Leroux"
"jojo"
"lerouxjoachim@gmail.com"
