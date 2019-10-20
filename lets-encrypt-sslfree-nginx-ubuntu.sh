#!/bin/bash

add-apt-repository ppa:certbot/certbot

apt update

apt-get install python-certbot-nginx




##Need to set cron
1 00 * * *  /usr/bin/certbot renew  --dry-run && service nginx restart > /root/ssl-certbot-renew.txt 2>&1


## for each domain use -d :)
certbot --apache certonly -n -d   yourdomain.com  -d www.yourdomain.com
