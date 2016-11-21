#!/bin/bash

cd server/src

# pre-env-setup
./build-new.sh

# build servers
mkdir build
cd build
cmake ..
make

# make install servers

cd ../../
cd auto_setup
# setup env and im_web
cd redis
./setup install

cd ../nginx_php/nginx
./setup install

yum -y install php php-fpm php-mysql
cd ../../

cd mariadb
./setup install

cd ../..
zip -r php.zip php
cp php.zip auto_setup/im_web
cd auto_setup/im_web
./setup install


cd ../..

systemctl stop firewalld.service
setenforce 0


# start servers

cd ..
./build.sh

cd ../run
./startall.sh







