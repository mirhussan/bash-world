#!/bin/bash

DATE=`date '+%d%m%Y_%H%M%S'`


mysqldump -u root   redmine_default | gzip -9  | pv > /mnt/backup/sqldump/redmine_default_$DATE.sql.gz


tar -cjf /mnt/backup/code/usr_redmine_"$DATE".tar.bz2  /usr/share/redmine

tar -cjf /mnt/backup/code/lib_redmine_"$DATE".tar.bz2   /var/lib/redmine



###################   v2

#!/bin/bash

##  work script
DATE=`date '+%d%m%Y_%H%M%S'`
USER='root'
PASSWORD='UkehX*bb5=AX'

#DATABASES=$(mysql --user=$USER --password=$PASSWORD --batch --skip-column-names -e "SHOW DATABASES;" | grep -v '^mysql$\|^information_schema$\|^performance_schema$\|^sys$')

mysqldump -u root --password=$PASSWORD  --single-transaction --quick --all-databases | gzip -9  | aws s3 cp -  s3://bucketname/dump/work_alldb_$DATE.sql.gz

tar -cjf /root/live_www_"$DATE".tar.bz2  /var/www/
aws s3 mv /root/live_www_"$DATE".tar.bz2   s3://bucketname/code/live_www_"$DATE".tar.bz2


tar -czf /root/nginx_"$DATE".tgz    /etc/nginx
aws s3  mv  /root/nginx_"$DATE".tgz   s3://bucketname	/code/nginx_"$DATE".tgz

echo "All Backup done" | mailx -s upward_backup_"$DATE" mirhussan@gmail.com


###
01 */6 * * * /usr/bin/nice -n 9 /usr/bin/ionice -c2 -n4 sh /mnt/backup.sh
