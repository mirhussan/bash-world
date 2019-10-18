#!/bin/bash

DATE=$(date +'%d/%m/%Y')
HOSTNAME=$(hostname)

MEMORY=$(free -mt | grep Total | awk '{print $4}')
#MEMORY=$(free -m | awk 'NR==2{printf "%.2f%%\t\t", $3*100/$2 }' | cut -d"%" -f1 |cut -d'.' -f1)
if [ "$MEMORY" -le 300 ]
then
echo "Your Server Memory is running low! memory: $MEMORY MB, please check it -$DATE" | mailx -s $HOSTNAME-stats mirhussan@gmail.com

fi


DISK=$(df -h | awk '$NF=="/"{printf "%s\t\t", $5}' | cut -d"%" -f1)
if [ "$DISK" -ge 80 ]
then
echo "Your Server root Disk space usage is $DISK%, please check it -$DATE" | mailx -s $HOSTNAME-stats mirhussan@gmail.com

fi

CPULOAD=$(top -bn1 | grep load |  cut -d',' -f4,5,6)
CPU=$(top -bn1 | grep load | awk '{printf "%.2f%%\t\t\n", $(NF-2)}' | cut -d"%" -f1 |cut -d'.' -f1)
if [ "$CPU" -ge 3 ]
then
echo "Your Server CPU load is $CPULOAD, please check it  -$DATE" | mailx -s $HOSTNAME-stats mirhussan@gmail.com

fi


MYSQLSTATUS=$(netstat -atnpl |grep mysql |grep -v grep |wc -l)
if [ "$MYSQLSTATUS" < 1]
then
echo "MYSQL server has crashed please take a look!! - $DATE" | mailx -s $HOSTNAME-stats mirhussan@gmail.com
fi

NGINXSTATUS=$(netstat -atnpl |grep nginx |grep -v grep | wc -l)
if [ "$NGINXSTATUS" < 1]
then
echo " Nignx service is unable to respond or crashed please take a look!!  - $DATE" | mailx -s $HOSTNAME-stats mirhussan@gmail.com
fi

##### Please don't delete or edit script without informing me (mirhussan@gmail.com)   Thanks!!!!!!!!!!


----------------------------------------------
#!/bin/bash

DATE=$(date +'%d/%m/%Y')
Hostname=$(hostname)

MEMORY=$(free -m | awk 'NR==2{printf "%.2f%%\t\t", $3*100/$2 }' | cut -d"%" -f1 |cut -d'.' -f1)
if [ "$MEMORY" -ge 90 ]
then
echo "Your Server Memory load is $MEMORY%, please check it -$DATE" | mailx -s $Hostanme-stat mirhussan@gmail.com

fi


DISK=$(df -h | awk '$NF=="/"{printf "%s\t\t", $5}' | cut -d"%" -f1)
if [ "$DISK" -ge 80 ]
then
echo "Your Server root Disk space usage is $DISK%, please check it -$DATE" | mailx -s $Hostanme-stat mirhussan@gmail.com

fi


CPULOAD=$(top -bn1 | grep load |  cut -d',' -f4,5,6)
CPU=$(top -bn1 | grep load | awk '{printf "%.2f%%\t\t\n", $(NF-2)}' | cut -d"%" -f1 |cut -d'.' -f1)
if [ "$CPU" -ge 3 ]
then
echo "Your Server CPU load is $CPULOAD, please check it  -$DATE" | mailx -s $Hostanme-stat mirhussan@gmail.com

fi
