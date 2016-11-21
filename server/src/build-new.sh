#!/bin/bash

HIREDIS=hiredis-master
LOG4CXX=apache-log4cxx-0.10.0
PROTOBUF=protobuf-2.6.1

check_user() {
    if [ $(id -u) != "0" ]; then
        echo "Error: You must be root to run this script, please use root to install im"
        exit 1
    fi
}

build() {
    yum -y install cmake
    yum -y install libuuid-devel
    yum -y install openssl-devel
    yum -y install curl-devel
    yum -y install mariadb-devel

	echo "#ifndef __VERSION_H__" > base/version.h
	echo "#define __VERSION_H__" >> base/version.h
	echo "#define VERSION \"$1\"" >> base/version.h
	echo "#endif" >> base/version.h

# hiredis
    cd hiredis
    unzip $HIREDIS.zip
    cd $HIREDIS
    make
    make install
    cd ..
    rm -rf $HIREDIS
    cd ..

# log4cxx
    yum -y install apr-devel
    yum -y install apr-util-devel
    cd log4cxx
    tar -xf $LOG4CXX.tar.gz
    cd $LOG4CXX
    ./configure
    cp ../inputstreamreader.cpp ./src/main/cpp/
    cp ../socketoutputstream.cpp ./src/main/cpp/
    cp ../console.cpp ./src/examples/cpp/
    make
    make install
    cd ..
    rm -rf $LOG4CXX
    cd ..

# protobuf
    cd protobuf
    tar -xf $PROTOBUF.tar.gz
    cd $PROTOBUF
    ./configure
    make
    make install
    cd ..
    rm -rf $PROTOBUF

    echo '/usr/local/lib' > /etc/ld.so.conf.d/teamtalk.conf

    /sbin/ldconfig /usr/local/lib


}

clean() {
	echo " cleaning ..."
}

print_help() {
	echo "Usage: "
	echo "  $0 clean --- clean all build"
	echo "  $0 version version_str --- build a version"
}

case $1 in
	clean)
		echo "clean all build..."
		clean
		;;
	version)
		if [ $# != 2 ]; then 
			echo $#
			print_help
			exit
		fi

		echo $2
		echo "build..."
		build $2
		check_user		
		;;
	*)
		print_help
		;;
esac
