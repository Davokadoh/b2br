apt install lighttpd mariadb-server php-cgi php-mysql build-essential pkg-config libssl-dev libpcre2-dev libargon2-0-dev libsodium-dev libc-ares-dev libcurl4-openssl-dev

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

echo "Changing directory"
cd /var/www/html
echo "Downloading Wordpress"
wget http://wordpress.org/latest.tar.gz -P /var/www/html
echo "Extracting archive"
tar -xzvf /var/www/html/latest.tar.gz
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

cd
wget --trust-server-names https://www.unrealircd.org/downloads/unrealircd-latest.tar.gz
tar xzvf unrealircd-6.0.3.tar.gz
cd unrealircd-6.0.3
./Config
make
make install
cd /home/jleroux/unrealircd
cp conf/examples/example.conf conf/unrealircd.conf
modify unrealircd.conf
./unrealircd start

#me block
#<name-of-server>/irc.42.ch
#
#admin block
#"Joachim Leroux"
#"jojo"
#"lerouxjoachim@gmail.com"
