
[English Version](./README.md)

# TeamTalk
	TeamTalk是一个企业即时通讯解决方案
	最初的源代码来自https://github.com/meili/TeamTalk
	详细的其他信息请查看doc目录
	
# issues 
	有什么问题请建issue 
		
		* qq群:523380672

# 安装过程 
	
安装centos7，测试用的镜像为centos7-dvd-1511.iso

安装时选择安装server-with-gui和mariadb development and development tools软件包

以root登陆	

	su	
	git clone https://github.com/vonway/teamtalk-server.git
	cd teamtalk-server
	#安装软件，编译服务器，并启动
	./makerun.sh

#客户端
	
	ios: https://github.com/vonway/teamtalk-ios.git
	mac: https://github.com/vonway/teamtalk-mac.git
	android: https://github.com/vonway/teamtalk-android.git
	win: https://github.com/vonway/teamtalk-win.git

#TODO

	- 清理未使用的代码
	- 基于ubuntu系统构建
	
	
