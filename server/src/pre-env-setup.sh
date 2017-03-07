#!/bin/bash

HIREDIS=hiredis-master
LOG4CXX=apache-log4cxx-0.10.0
PROTOBUF=protobuf-2.6.1

JOBS=`cat /proc/cpuinfo| grep "processor"| wc -l`

check_user() {
    if [ $(id -u) != "0" ]; then
        echo "Error: You must be root to run this script, please use root to install im"
        exit 1
    fi
}

build() {
# hiredis
	find /usr/local/include/hiredis/hiredis.h /usr/local/lib/libhiredis.so /usr/local/lib/libhiredis.a \
		/usr/local/lib/pkgconfig/hiredis.pc > /dev/null
	if [ $? ] ; then
		echo "hiredis is installed"
	else
	    yum -y install cmake
    	yum -y install libuuid-devel
    	yum -y install openssl-devel
    	yum -y install curl-devel
    	yum -y install mariadb-devel

    	cd hiredis
   	 	unzip $HIREDIS.zip
   	 	cd $HIREDIS
		make -j$(JOBS)
    	make install
    	cd ..
    	rm -rf $HIREDIS
    	cd ..
		find /usr/local/include/hiredis/hiredis.h /usr/local/lib/libhiredis.so /usr/local/lib/libhiredis.a \
			/usr/local/lib/pkgconfig/hiredis.pc > /dev/null
		if [ $? ] ; then
				echo "install hiredis finished"
		else
				echo "install hiredis failed"
				exit 1
		fi
	fi

# log4cxx
	find /usr/local/lib/pkgconfig/liblog4cxx.pc /usr/local/include/log4cxx/log4cxx.h \
		/usr/local/lib/liblog4cxx* > /dev/null
	if [ $? ] ; then
		echo "log4cxx is installed"
	else
	    yum -y install apr-devel
    	yum -y install apr-util-devel
    	cd log4cxx
    	tar -xf $LOG4CXX.tar.gz
    	cd $LOG4CXX
    	./configure
    	cp -f ../inputstreamreader.cpp ./src/main/cpp/
    	cp -f ../socketoutputstream.cpp ./src/main/cpp/
    	cp -f ../console.cpp ./src/examples/cpp/
		make -j$(JOBS)
    	make install
    	cd ..
    	rm -rf $LOG4CXX
    	cd ..
		find /usr/local/lib/pkgconfig/liblog4cxx.pc /usr/local/include/log4cxx/log4cxx.h \
			/usr/local/lib/liblog4cxx* > /dev/null
		if [ $? ] ; then
			echo "install log4cxx finished"
		else
			echo "install log4cxx failed"
			exit 2;
		fi
	fi


# protobuf
	find /usr/local/include/google/protobuf/message.h /usr/local/lib/libprotobuf* > /dev/null
	if [ $? ] ; then
		echo "protobuf is installed"
	else
    	cd protobuf
    	tar -xf $PROTOBUF.tar.gz
   	 	cd $PROTOBUF
    	./configure
		make -j$(JOBS)
    	make install
    	cd ..
    	rm -rf $PROTOBUF
    	echo '/usr/local/lib' > /etc/ld.so.conf.d/teamtalk.conf
    	/sbin/ldconfig /usr/local/lib

		find /usr/local/include/google/protobuf/message.h /usr/local/lib/libprotobuf* > /dev/null
		if [ $? ] ; then
			echo "install protobuf finished"
		else
			echo "install protobuf failed"	
			exit 3
		fi
	fi


}

check_user;
build;

