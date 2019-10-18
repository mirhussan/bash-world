#!/bin/bash -e
#sudo -s

echo "Enter your site name:"
read -e sitename

if [[ ! -e '$sitename' ]]; then
mkdir -p  /var/www/$sitename/{htdocs,logs}
fi

apt-get update

    
echo "=============================================="
echo "Nginx , Mysql And php7.0 going to Install"
echo "=============================================="
apt-get install -y wget curl mysql-server nginx  php7.0-cli  php7.0-common  php7.0-curl  php7.0-fpm   php7.0-gd   php7.0-json   php7.0-zip  php7.0-mysql  php7.0-readline    php7.0-sqlite3


sed -ie  's/\#\ server_tokens\ off/server_tokens\ off/g' /etc/nginx/nginx.conf

sed -ie 's/upload_max_filesize\ = .*/upload_max_filesize\ =\ 200M/g' /etc/php/7.0/fpm/php.ini
sed -ie 's/post_max_size\ = .*/post_max_size\ =\ 128M/g' /etc/php/7.0/fpm/php.ini
sed -ie 's/max_execution_time\ = .*/max_execution_time\ =\ 300/g' /etc/php/7.0/fpm/php.ini
sed -ie 's/memory_limit\ = .*/memory_limit\ =\ 512M/g' /etc/php/7.0/fpm/php.ini




cat <<EOF >  /etc/nginx/sites-available/$sitename.conf


server {


# location /nginx_status {
#        stub_status on;
#        access_log   off;
#        allow 103.255.4.90;
#        allow 104.131.149.45;
#        deny all;
#   }

    # Tell nginx to handle requests for the www.yoursite.com domain
    server_name  $sitename;
    index index.php index.html index.htm;
    root                /var/www/$sitename/htdocs;
    access_log          /var/www/$sitename/logs/access.log;
    error_log           /var/www/$sitename/logs/error.log;
    
    gzip                on;
    gzip_disable        "msie6";
    gzip_min_length     256;
    gzip_vary           on;
    gzip_proxied        any;
    gzip_comp_level     6;
    gzip_buffers        16 8k;
    gzip_types text/plain text/css application/javascript  application/json application/x-javascript text/xml application/xml application/xml+rss text/javascript application/vnd.ms-fontobject application/x-font-ttf font/opentype image/svg+xml image/x-icon;

    location / {
            try_files "$"uri "$"uri/ /index.php?$uri;
        #    try_files \$uri \$uri/ \$uri.html \$uri.php\$is_args\$query_string;
 ;
        #    try_files "$"uri "$"uri/ /index.php?action=$uri&item=$args;

    }
    location ~* \.(xml|ogg|ogv|svg|svgz|eot|otf|woff|mp4|ttf|css|rss|atom|js|jpg|jpeg|gif|png|ico|zip|tgz|gz|rar|bz2|doc|xls|exe|ppt|tar|mid|midi|wav|bmp|rtf)$ {
        expires         max;
        access_log      off;
    }
    location ~* /\.ht {
        deny            all;
        access_log      off;
        log_not_found   off;
    }

    location = /xmlrpc.php {
    deny all;
    access_log off;
    log_not_found off;
    }

    location = /wp-config.php {
    deny all;
    access_log off;
    log_not_found off;
    }

    location ~*  \.(jpg|svg|jpeg|png|gif|ico|css|js)$ {
        expires 365d; }
    location ~ ^/wp-content/uploads/edd/(.*?)\.zip$ { rewrite / permanent; }


    location ~* \.php$ {
#        fastcgi_index   index.php;
#        fastcgi_param  SCRIPT_FILENAME  \$document_root$fastcgi_script_name;
         fastcgi_pass unix:/run/php/php7.0-fpm.sock;
         include snippets/fastcgi-php.conf;
         include         fastcgi_params;

    }


location ~ \.php$ {
    try_files \$uri =404;
}



}
EOF

cat <<EOF   > /var/www/$sitename/htdocs/.htaccess

# BEGIN WordPress
<IfModule mod_rewrite.c>
RewriteEngine On
RewriteBase /
RewriteRule ^index\.php\$ - [L]
RewriteCond %{REQUEST_FILENAME} !-f
RewriteCond %{REQUEST_FILENAME} !-d
RewriteRule . /index.php [L]
</IfModule>
# END WordPress
EOF


ln -s /etc/nginx/sites-available/$sitename.conf  /etc/nginx/sites-enabled/

echo "==========================="
echo "Nginx And Mysql restarted"
echo "==========================="
service php7.0-fpm start
service nginx restart
service mysql restart


echo "========================================"
echo "Database and Username/Password creation"
echo "========================================"
echo "Database Name: "
read -e dbname
echo "Database User: "
read -e dbuser
echo "Dont use "@" character!!!"
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
sleep 3
clear
echo "================================================"
echo "Now WordPress Installing Need  y  to contiune"
echo "================================================"
sleep 2


echo "Do you also want to install Wordpress? y/n"
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
cp -rf wordpress/*  /var/www/$sitename/htdocs/


#remove files from wordpress folder
rm -rf wordpress

#create wp config
cp /var/www/$sitename/htdocs/wp-config-sample.php /var/www/$sitename/htdocs/wp-config.php

#set database details with perl find and replace
perl -pi -e "s/database_name_here/$dbname/g" /var/www/$sitename/htdocs/wp-config.php
perl -pi -e "s/username_here/$dbuser/g" /var/www/$sitename/htdocs/wp-config.php
perl -pi -e "s/password_here/$dbpass/g" /var/www/$sitename/htdocs/wp-config.php


## adding direct package installation for wordpress
echo "define('FS_METHOD', 'direct');" >> /var/www/$sitename/htdocs/wp-config.php

#create uploads folder and set permissions
mkdir /var/www/$sitename/htdocs/wp-content/uploads
#chmod 755 wp-content/uploads

echo "==================================="
echo "Temp allow apache to full WordPress"
echo "==================================="
chown  www-data:www-data -R /var/www/$sitename




echo "Now Cleaning up..."
sleep 3
#remove zip file
rm latest.tar.gz
#remove bash script
rm wp.sh
echo "========================="
echo "Installation is complete."
echo "========================="

fi

 