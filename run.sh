#!/bin/bash

# run servers
cd server/run
./startall.sh

ps -ef | grep redis
ps -ef | grep php
ps -ef | grep mysql
ps -ef | grep server
ps -ef | grep msfs

