cmake_minimum_required(VERSION 2.6)
PROJECT(all)

cmake_policy(SET CMP0015 NEW)

add_subdirectory(base)
add_subdirectory(slog)
add_subdirectory(login_server)
add_subdirectory(route_server)
add_subdirectory(msg_server)
add_subdirectory(http_msg_server)
add_subdirectory(file_server)
add_subdirectory(push_server)
add_subdirectory(tools)
add_subdirectory(db_proxy_server)
add_subdirectory(msfs)



