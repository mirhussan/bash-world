#!/bin/bash -e
#sudo -s

echo "Enter your site name:"
read -e sitename

if [[ ! -e '$sitename' ]]; then
mkdir  /var/www/$sitename
fi

apt-get update
#echo "=============================================="
#echo "Apache2.4 , Mysql And php7.2 going to Install"
#echo "=============================================="
#apt-get -y install apache2 mysql-server php7.2 libapache2-mod-php7.2  php7.2-mbstring  php7.2-mcrypt  php7.2-curl php7.2-json   php7.2-opcache  php7.2-zip  php7.2-mysql php7.2-xml

echo "=============================================="
echo "Apache2.4 , Mysql And php7.0 going to Install"
echo "=============================================="
apt-get install -y wget curl mysql-server apache2 php7.0 libapache2-mod-php7.0  php7.0-mbstring  php7.0-mcrypt  php7.0-curl php7.0-json   php7.0-opcache  php7.0-zip  php7.0-mysql php7.0-xml



cat <<EOF > /etc/apache2/sites-available/$sitename.conf
<VirtualHost *:80>
    ServerAdmin admin@$sitename
    ServerName $sitename
    DocumentRoot /var/www/$sitename

    <Files wp-config.php>
	Require all denied
	</Files>

	<Files xmlrpc.php>
	Require all denied
	</Files>

# Protect `wp-config.php` from HTTP access
	<Files wp-config.php>
	Require all denied
	</Files>

# Prevent directory access (i.e. example.com/wp-content/uploads/)
# The `options` directive does not use a module and requires no if statement
# @link https://httpd.apache.org/docs/2.4/mod/core.html#options

Options -Indexes

    <Directory /var/www/$sitename>
        Options  FollowSymLinks MultiViews
        AllowOverride All
        Require all granted
    </Directory>
    LogLevel warn
    ErrorLog /var/log/apache2/$sitename_error.log
    CustomLog /var/log/apache2/$sitename_access.log combined

</VirtualHost>
EOF

ln -s /etc/apache2/sites-available/$sitename.conf   /etc/apache2/sites-enabled/$sitename.conf

echo "###########################"
echo "php parameters added"
echo "###########################"


sed -ie 's/upload_max_filesize\ = .*/upload_max_filesize\ =\ 200M/g' /etc/php/7.0/fpm/php.ini
sed -ie 's/post_max_size\ = .*/post_max_size\ =\ 128M/g' /etc/php/7.0/fpm/php.ini
sed -ie 's/max_execution_time\ = .*/max_execution_time\ =\ 300/g' /etc/php/7.0/fpm/php.ini
sed -ie 's/memory_limit\ = .*/memory_limit\ =\ 512M/g' /etc/php/7.0/fpm/php.ini




echo "========================================"
echo "Database and Username/Password creation"
echo "========================================"
echo "Database Name: "
read -e dbname
echo "Database User: "
read -e dbuser
echo "Database Password: "
read -s dbpass


echo "========================================"
echo "Please wait while Database working"
echo "========================================"
mysql -u root -e "CREATE DATABASE $dbname"
mysql -u root -e "GRANT ALL PRIVILEGES ON    $dbname.* TO '$dbuser'@'%'  IDENTIFIED BY  '$dbpass'"
mysql -u root -e "FLUSH PRIVILEGES"

echo "==============="
echo "DB config done"
echo "==============="



clear
echo "================================================"
echo "Now WordPress Installing Need  y  to contiune"
echo "================================================"

echo "run install? y/n"
read -e run
if [ "$run" == n ] ; then
exit
else
echo "==================================================="
echo "A robot Script is now installing WordPress for you"
echo "==================================================="

#download wordpress
wget https://wordpress.org/latest.tar.gz

#unzip wordpress
tar -zxf latest.tar.gz

#copy file to parent dir
cp -rf wordpress/*  /var/www/$sitename/


#remove files from wordpress folder
rm -rf wordpress

#create wp config
cp /var/www/$sitename/wp-config-sample.php /var/www/$sitename/wp-config.php

#set database details with perl find and replace
perl -pi -e "s/database_name_here/$dbname/g" /var/www/$sitename/wp-config.php
perl -pi -e "s/username_here/$dbuser/g" /var/www/$sitename/wp-config.php
perl -pi -e "s/password_here/$dbpass/g" /var/www/$sitename/wp-config.php



#create uploads folder and set permissions
mkdir /var/www/$sitename/wp-content/uploads
#chmod 755 wp-content/uploads

echo "==================================="
echo "Temp allow apache to full WordPress"
echo "==================================="
chown  www-data:www-data -R /var/www/$sitename

cat <<EOF   > /var/www/$sitename/.htaccess

# BEGIN WordPress
<IfModule mod_rewrite.c>
RewriteEngine On
RewriteBase /
RewriteRule ^index\.php$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.php [L]
</IfModule>
# END WordPress
EOF


echo "======================="
echo "Enabling Rewrite module"
echo "======================="
a2enmod rewrite

echo "==========================="
echo "Apache And Mysql restarted"
echo "==========================="
service apache2 restart
service mysql restart


echo "Now Cleaning up..."
#remove zip file
rm latest.tar.gz
#remove bash script
rm wp.sh
echo "========================="
echo "Installation is complete."
echo "========================="

fi