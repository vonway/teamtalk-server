#!/bin/bash
check_user() {
    if [ $(id -u) != "0" ]; then
        echo "Error: You must be root to run this script, please use root to install im"
        exit 1
    fi
}

check_user;

./envsetup.sh

./build.sh

./run.sh

