#!/bin/bash

./restart.sh db_proxy_server
./restart.sh file_server
./restart.sh msfs
./restart.sh login_server
./restart.sh route_server
./restart.sh msg_server
./restart.sh http_msg_server
./restart.sh push_server

