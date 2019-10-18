
#####
####
###
##
#   Script have two enviroments one is Staging and second is Live.. 
#   Umcomment required enviroment and run the script after grant execute permissoin.
# Steps:
#   chmod +x  script.sh
#   sh -x script.sh



#!/bin/bash
SB_DB_NAME="dbdd"
SB_DB_USER="dev_dd"
SB_DB_PASSWORD='C6WSAFA'

DATE="06042019_080001.tgz"
USER="root"
PASSWORD='GHR234su$2zx'
DB_USER="sbdb-res"
DB_PASSWORD="34VF64#D"
DB_NAME="sbdbdd_restore"


## From scratch... use following commmands.
#mysql -u root -p$PASSWORD -e "CREATE DATABASE $DB_NAME"
#mysql -u root -p$PASSWORD -e "GRANT ALL PRIVILEGES ON    $DB_NAME.* TO '$DB_USER'@'%'  IDENTIFIED BY  '$DB_PASSWORD'"
#mysql -u root -p$PASSWORD -e "FLUSH PRIVILEGES"


##Staging
#aws s3 cp   s3://s3-dd-wp/mysqldump/sb/sb-dd-"$DATE".sql.gz   /tmp
##Live
aws s3 cp   s3://s3-dd-wp/mysqldump/live/dd-"$DATE".sql.gz   /tmp


##Staging
#gzip -d /tmp/sb-dd-"$DATE".sql.gz
##Live
gzip -d /tmp/dd-"$DATE".sql.gz


##Staging
#mysql --user=$USER --password=$PASSWORD $SB_DB_NAME   < /tmp/sb-dd-"$DATE".sql
##Live
mysql --user=$USER --password=$PASSWORD $SB_DB_NAME   < /tmp/dd-"$DATE".sql


##Staging
#aws s3 cp s3://s3-dd-wp/sb.dd.org/sb-dd_"$DATE".tgz   /tmp/
##Live
aws s3 cp s3://s3-dd-wp/live.dd.org/live-dd_"$DATE".tgz   /tmp/


##Staging
#tar -xzf /tmp/sb-dd_"$DATE".tgz  -C /
##Live
tar -xzf /tmp/live-dd_"$DATE".tgz  -C /    ; mv /var/www/vhost/sb.dd.org /var/www/vhost/sb.dd.org-bak && mv /var/www/vhost/live.dd.org /var/www/vhost/sb.dd.org
mv /var/www/vhost/sb.dd.org/htdocs/wp-config.php /var/www/vhost/sb.dd.org/htdocs/wp-config.php-live; cp /var/www/vhost/sb.dd.org-bak/htdocs/wp-config.php   /var/www/vhost/sb.dd.org/htdocs/wp-config.php 

 
##Staging
#aws s3  cp s3://s3-dd-wp/sb.dd.org/nginx_"$DATE".tgz    /tmp/
##Live
#aws s3  cp s3://s3-dd-wp/live.dd.org/nginx_"$DATE".tgz    /tmp/

