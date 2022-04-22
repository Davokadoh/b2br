sudo apt install lighttpd mariadb-server php-cgi php-mysql build-essential pkg-config libssl-dev libpcre2-dev libargon2-0-dev libsodium-dev libc-ares-dev libcurl4-openssl-dev

sudo ufw allow 80
echo "Starting mysql_secure_installation"
echo "Answer no (n) only to the first question"
sudo mysql_secure_installation
echo "End of mysql_secure_installation"

echo "Creating database"
sudo mariadb -e "CREATE DATABASE mydb;"
echo "Granting privileges"
sudo mariadb -e "GRANT ALL ON mydb.* TO dumyuser@localhost IDENTIFIED BY dumypass WITH GRANT OPTION;"
sudo mariadb -e "FLUSH PRIVILEGES;"

echo "Changing directory"
cd /var/www/html
echo "Downloading Wordpress"
sudo wget http://wordpress.org/latest.tar.gz
echo "Extracting archive"
sudo tar -xzvf /var/www/html/latest.tar.gz
echo "Deleting archive"
sudo rm /var/www/html/latest.tar.gz
echo "Moving files"
sudo cp -r /var/www/html/wordpress/* /var/www/html
sudo rm -rf /var/www/html/wordpress
echo "Copying config from sample"
sudo cp /var/www/html/wp-config-sample.php /var/www/html/wp-config.php

echo "Inserting database and user names in config file"
sudo sed -i -e "s/'database_name_here'/mydb/g" /var/www/html/wp-config.php
sudo sed -i -e "s/'username_here'/dumyuser/g" /var/www/html/wp-config.php

echo "Enabling lighttpd mods"
sudo lighty-enable-mod fastcgi
sudo lighty-enable-mod fastcgi-php
sudo service lighttpd force-reload

cd /home/jleroux
sudo wget https://www.unrealircd.org/downloads/unrealircd-latest.tar.gz
sudo tar -xf unrealircd-latest.tar.gz
echo "Chmoding..."
sudo chmod u+rw unrealircd-6.0.3
cd unrealircd-6.0.3
./Config
make
make install
sudo su -c "cd /home/jleroux/unrealircd" root
sudo cp conf/examples/example.conf conf/unrealircd.conf
./unrealircd start

#me block
#<name-of-server>/irc.42.ch
#
#admin block
#"Joachim Leroux"
#"jojo"
#"lerouxjoachim@gmail.com"
