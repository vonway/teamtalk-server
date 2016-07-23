/*
 * login_server.cpp
 *
 *  Created on: 2013-6-21
 *      Author: ziteng@mogujie.com
 */

#include "LoginConn.h"
#include "netlib.h"
#include "ConfigFileReader.h"
#include "version.h"
#include "HttpConn.h"
#include "ipparser.h"

IpParser* pIpParser = NULL;
string strMsfsUrl;
string strDiscovery;//发现获取地址
//--> client callback is set when server-side socket listen to ip:port
//--> this callback will be called and replaced by imconn_callback() in OnConnect2() when server-side socket accepts a connect request
//--> result:	- add a loginconn for client in g_client_conn_map
//-->			- set basesocket's callback function to imconn_callback, callback_data to g_client_conn_map
void client_callback(void* callback_data, uint8_t msg, uint32_t handle, void* pParam)
{
	if (msg == NETLIB_MSG_CONNECT)
	{
		CLoginConn* pConn = new CLoginConn();
		pConn->OnConnect2(handle, LOGIN_CONN_TYPE_CLIENT);
	}
	else
	{
		log("!!!error msg: %d ", msg);
	}
}

//--> msg server callback is set when server-side socket listen to ip:port
//--> this callback will be called and replaced by imconn_callback() in OnConnect2() when server-side socket accepts a connect request
//--> result:	- add a loginconn for msg server in g_msg_serv_conn_map
//-->			- set basesocket's callback function to imconn_callback, callback_data to g_msg_serv_conn_map
void msg_serv_callback(void* callback_data, uint8_t msg, uint32_t handle, void* pParam)
{
    log("msg_server come in");

	if (msg == NETLIB_MSG_CONNECT)
	{
		CLoginConn* pConn = new CLoginConn();
		pConn->OnConnect2(handle, LOGIN_CONN_TYPE_MSG_SERV);
	}
	else
	{
		log("!!!error msg: %d ", msg);
	}
}

//--> http callback is set when server-side socket listen to ip:port
//--> this callback will be called and replaced by httpconn_callback() in OnConnect() when server-side socket accepts a connect request
//--> result:	- add a httpconn for http in g_http_conn_map
//-->			- set basesocket's callback function to httpconn_callback, callback_data to m_conn_handle,get remote ip to m_peer_ip
void http_callback(void* callback_data, uint8_t msg, uint32_t handle, void* pParam)
{
    if (msg == NETLIB_MSG_CONNECT)
    {
        CHttpConn* pConn = new CHttpConn();
        pConn->OnConnect(handle);
    }
    else
    {
        log("!!!error msg: %d ", msg);
    }
}

int main(int argc, char* argv[])
{
	//--> login_server -v 		show version info
	if ((argc == 2) && (strcmp(argv[1], "-v") == 0)) {
		printf("Server Version: LoginServer/%s\n", VERSION);
		printf("Server Build: %s %s\n", __DATE__, __TIME__);
		return 0;
	}
	//--> stop server to exit in case of revc a SIGPIPE signal (send msg to a shutdown socket) 
	signal(SIGPIPE, SIG_IGN);
	//--> read config parameter from config file
	CConfigFileReader config_file("loginserver.conf");

    char* client_listen_ip = config_file.GetConfigName("ClientListenIP");
    char* str_client_port = config_file.GetConfigName("ClientPort");
    char* http_listen_ip = config_file.GetConfigName("HttpListenIP");
    char* str_http_port = config_file.GetConfigName("HttpPort");
	char* msg_server_listen_ip = config_file.GetConfigName("MsgServerListenIP");
	char* str_msg_server_port = config_file.GetConfigName("MsgServerPort");
    char* str_msfs_url = config_file.GetConfigName("msfs");
    char* str_discovery = config_file.GetConfigName("discovery");

	if (!msg_server_listen_ip || !str_msg_server_port || !http_listen_ip
        || !str_http_port || !str_msfs_url || !str_discovery) {
		log("config item missing, exit... ");
		return -1;
	}

	uint16_t client_port = atoi(str_client_port);
	uint16_t msg_server_port = atoi(str_msg_server_port);
    uint16_t http_port = atoi(str_http_port);
    strMsfsUrl = str_msfs_url;
    strDiscovery = str_discovery;
    
    //--> 
    pIpParser = new IpParser();
    
	int ret = netlib_init();

	if (ret == NETLIB_ERROR)
		return ret;
	//--> we support multiple ip
	CStrExplode client_listen_ip_list(client_listen_ip, ';');
	for (uint32_t i = 0; i < client_listen_ip_list.GetItemCnt(); i++) {
		//--> - for each ip:port, new a basesocket bind and listen to ; set callback and data; add basesocket to g_socket_map
		//--> - add event to watch socket actions
		ret = netlib_listen(client_listen_ip_list.GetItem(i), client_port, client_callback, NULL);
		if (ret == NETLIB_ERROR)
			return ret;
	}

	CStrExplode msg_server_listen_ip_list(msg_server_listen_ip, ';');
	for (uint32_t i = 0; i < msg_server_listen_ip_list.GetItemCnt(); i++) {
		ret = netlib_listen(msg_server_listen_ip_list.GetItem(i), msg_server_port, msg_serv_callback, NULL);
		if (ret == NETLIB_ERROR)
			return ret;
	}
    
    CStrExplode http_listen_ip_list(http_listen_ip, ';');
    for (uint32_t i = 0; i < http_listen_ip_list.GetItemCnt(); i++) {
        ret = netlib_listen(http_listen_ip_list.GetItem(i), http_port, http_callback, NULL);
        if (ret == NETLIB_ERROR)
            return ret;
    }
    

			printf("server start listen on:\nFor client %s:%d\nFor MsgServer: %s:%d\nFor http:%s:%d\n",
			client_listen_ip, client_port, msg_server_listen_ip, msg_server_port, http_listen_ip, http_port);
	//--> set login|http conn callback timer for timely do OnTimer()
	init_login_conn();
    init_http_conn();

	printf("now enter the event loop...\n");
    //--> write current server pid to file server.pid
    writePid();
	//--> start dispatch: socket acts for diff perpose; checktimer checkloop
	netlib_eventloop();

	return 0;
}
