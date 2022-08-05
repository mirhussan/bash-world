#!/bin/bash

YEAR=2020
MO=01
##DAY=`seq 1 31`

DATE=$MO$YEAR

SPACENAME=examplespace

NGINXFILENAME=nginx.tar.gz
CODEFILENAME=vhosts-www.tar.bz2
STAGEMYSQLFILENAME=stage_db.sql.gz
LIVEMYSQLFILENAME=live_db.sql.gz

for i in `seq -w 1 31`
do
s3cmd del s3://wpbspace/$SPACENAME/nginx/$i$DATE"_000001"/$NGINXFILENAME
s3cmd del s3://wpbspace/$SPACENAME/nginx/$i$DATE"_120001"/$NGINXFILENAME
#
s3cmd del s3://wpbspace/$SPACENAME/code/$i$DATE"_000001"/$CODEFILENAME
s3cmd del s3://wpbspace/$SPACENAME/code/$i$DATE"_120001"/$CODEFILENAME
#
s3cmd del s3://wpbspace/$SPACENAME/mysqldump/$i$DATE"_000001"/$STAGEMYSQLFILENAME
s3cmd del s3://wpbspace/$SPACENAME/mysqldump/$i$DATE"_000001"/$LIVEMYSQLFILENAME
s3cmd del s3://wpbspace/$SPACENAME/mysqldump/$i$DATE"_120001"/$LIVEMYSQLFILENAME
s3cmd del s3://wpbspace/$SPACENAME/mysqldump/$i$DATE"_120001"/$STAGEMYSQLFILENAME


done


echo "done ALL."
