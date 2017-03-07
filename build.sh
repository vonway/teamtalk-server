#!/bin/bash

cd server/src
# env for build server eg: log4cxx protobuf hiredis
./pre-env-setup.sh
# build servers
./build.sh

cd ../..
./setip.sh
systemctl stop firewalld.service
setenforce 0

