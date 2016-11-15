#!/bin/bash

cd server/src

# pre-env-setup
./pre-env-setup.sh

# build servers
mkdir build
cd build
cmake ..
make
cd ../
./build.sh

# make install servers

cd ../../../auto_setup
# setup env and im_web
cd redis
./setup.sh install

cd ../nginx_php/nginx
./setup.sh install
cd ../../

yum -y install php php-fpm php-mysql

service php-fpm start

cd mariadb
./setup.sh install
cd ../..

./setip.sh

#zip -r php.zip php
#cp php.zip auto_setup/im_web
cd auto_setup/im_web
./setup install
cd ../..

systemctl stop firewalld.service
setenforce 0

# start servers


cd server/run
./startall.sh


ps -ef | grep redis
ps -ef | grep php
ps -ef | grep mysql
ps -ef | grep server
ps -ef | grep msfs






