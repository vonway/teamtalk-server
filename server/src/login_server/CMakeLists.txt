cmake_minimum_required(VERSION 2.6)
PROJECT(loginserver)

cmake_policy(SET CMP0015 NEW)
AUX_SOURCE_DIRECTORY(./ SRC_LIST)

#SET(LIBRARY_OUTPUT_PATH ./)
SET(EXECUTABLE_OUTPUT_PATH  ../bin/)

ADD_DEFINITIONS( -g -W -Wall -D_REENTRANT -D_FILE_OFFSET_BITS=64 -DAC_HAS_INFO
-DAC_HAS_WARNING -DAC_HAS_ERROR -DAC_HAS_CRITICAL -DTIXML_USE_STL
-DAC_HAS_DEBUG -DLINUX_DAEMON -std=c++11)

INCLUDE_DIRECTORIES(./ ../base ../base/pb/protocol ../base/jsoncpp/ )
LINK_DIRECTORIES(./ ../lib/)

#ADD_LIBRARY(${PROJECTNAME} SHARED/STATIC ${SRC_LIST})
ADD_EXECUTABLE(login_server ${SRC_LIST})

TARGET_LINK_LIBRARIES(login_server base protobuf-lite slog pthread) 
