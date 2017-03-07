#!/bin/bash


ip=`ifconfig | sed -n '2p' | awk -F " " '{print $2}'`
echo "----------------"
echo "  set ip to $ip "
sed -i "s/0.0.0.0/$ip/g" /var/www/html/php/application/config/config.php
cd server/run/
sed -i "s/0.0.0.0/$ip/g" */*.conf
sed -i "s/127.0.0.1/$ip/g" */*.conf
echo "  set ip done! "
echo "----------------"

