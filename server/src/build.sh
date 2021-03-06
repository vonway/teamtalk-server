#!/bin/bash

build() {
	if [ ! -d build ]; then
		mkdir build
	fi
	cd build
	cmake ..
	make
	cd ..

    mkdir -p ../run/login_server
    mkdir -p ../run/route_server
    mkdir -p ../run/msg_server
    mkdir -p ../run/file_server
    mkdir -p ../run/msfs
    mkdir -p ../run/push_server
    mkdir -p ../run/http_msg_server
    mkdir -p ../run/db_proxy_server

	#copy executables to run/ dir
	cp build/bin//login_server ../run/login_server/

	cp build/bin/route_server ../run/route_server/

	cp build/bin/msg_server ../run/msg_server/

    cp build/bin/http_msg_server ../run/http_msg_server/

    cp build/bin/file_server ../run/file_server/

    cp build/bin/push_server ../run/push_server/

    cp build/bin/db_proxy_server ../run/db_proxy_server/

    cp build/bin/msfs ../run/msfs/

    cp build/bin/daeml ../run/


    cp conf/log4cxx.properties conf/loginserver.conf ../run/login_server/

    cp conf/log4cxx.properties conf/routeserver.conf ../run/route_server/

    cp conf/log4cxx.properties conf/msgserver.conf ../run/msg_server/

    cp conf/log4cxx.properties conf/httpmsgserver.conf ../run/http_msg_server/

    cp conf/log4cxx.properties conf/fileserver.conf ../run/file_server/

    cp conf/log4cxx.properties conf/pushserver.conf ../run/push_server/

    cp conf/log4cxx.properties conf/dbproxyserver.conf ../run/db_proxy_server/

    cp conf/log4cxx.properties conf/msfs.conf ../run/msfs/


}

clean() {
	cd build
	make clean
}

print_help() {
	echo "Usage: "
	echo "  $0 clean --- clean all build"
	echo "  $0 version version_str --- build a version"
}

case $1 in
	clean)
		clean
		;;
	*)
		build 
		;;
esac
