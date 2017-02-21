#!/bin/sh
echo '#############################################
############欢迎使用SSR便捷安装包############
#########此脚本只在Debian下通过测试##########
###############感谢glzjin！##################'
echo -e "\033[33m 确认安装请按Y： \033[0m"
read con
if [ "$con" == "Y" ] ; then
cd /root
apt-get update
apt-get install -y build-essential 
apt-get install -y python-pip
apt-get install -y git
echo -e \\n
echo -e \\n

echo ' ########开始安装libsodium#########'
apt-get install build-essential
wget https://github.com/jedisct1/libsodium/releases/download/1.0.10/libsodium-1.0.10.tar.gz
tar xf libsodium-1.0.10.tar.gz && cd libsodium-1.0.10
./configure && make -j2 && make install
ldconfig

echo -e \\n

echo ' ##########开始安装cymysql###########'
pip install cymysql

echo ' ##########开始安装魔改后端###########'
cd /root
git clone -b manyuser https://github.com/glzjin/shadowsocks.git
cd shadowsocks
fi

echo '#############################################
#############开始进行参数配置################
##############这里做基本配置#################
#############################################'

echo "按 <Y> 确认继续执行，其他键退出:"
read pd
if [ "$pd" == "Y" ] ; then
cp apiconfig.py userapiconfig.py
cp config.json user-config.json
echo "请输入你的节点ID:"
read nodeid
echo "请输入你的混淆参数:"
read suffix
echo "请输入你的webapi地址:"
read apiurl
echo "请输入你的webapi token:"
read apitoken
sed -i '/NODE_ID/d' userapiconfig.py
sed -i '1a NODE_ID = '$nodeid'' userapiconfig.py
sed -i '/MU_SUFFIX/d' userapiconfig.py
sed -i "11a MU_SUFFIX = '$suffix'" userapiconfig.py
sed -i '/WEBAPI_URL/d' userapiconfig.py
sed -i "17a WEBAPI_URL = '$apiurl'" userapiconfig.py
sed -i '/WEBAPI_TOKEN/d' userapiconfig.py
sed -i "18a WEBAPI_TOKEN = '$apitoken'" userapiconfig.py

echo ' #########开始安装supervisiord#########'

apt-get install -y supervisor
cd /etc/supervisor/conf.d/
echo "#守护配置文件" >shadowsocks.conf 
sed -i '$a [program:shadowsocks]' /etc/supervisor/conf.d/shadowsocks.conf
sed -i '$a command=python /root/shadowsocks/server.py' /etc/supervisor/conf.d/shadowsocks.conf
sed -i '$a user=root' /etc/supervisor/conf.d/shadowsocks.conf
sed -i '$a autostart=true' /etc/supervisor/conf.d/shadowsocks.conf
sed -i '$a autorestart=true' /etc/supervisor/conf.d/shadowsocks.conf
sed -i '$a stderr_logfile = /var/log/shadowsocks.log' /etc/supervisor/conf.d/shadowsocks.conf
sed -i '$a stdout_logfile = /var/log/shadowsocks.log' /etc/supervisor/conf.d/shadowsocks.conf
sed -i '$a stderr_logfile_maxbytes=4MB' /etc/supervisor/conf.d/shadowsocks.conf
sed -i '$a stderr_logfile_backups=10' /etc/supervisor/conf.d/shadowsocks.conf
sed -i '$a startsecs=3' /etc/supervisor/conf.d/shadowsocks.conf
sed -i '$a ulimit -n 51200' /etc/profile /etc/default/supervisor
sed -i '$a ulimit -Sn 4096' /etc/profile /etc/default/supervisor
sed -i '$a ulimit -Hn 8192' /etc/profile /etc/default/supervisor
service supervisor start
supervisorctl reload
echo "配置完成，Enjoy it！"
echo "查看SS日志命令为supervisorctl tail -f shadowsocks stderr"
echo "重载SS守护命令为supervisorctl reload"
echo "重启SS守护命令为service supervisor restart"
echo "停止SS守护命令为service supervisor stop"
echo "如果SS正常启动后，无法“上网”请检查iptables配置"
echo "制作人：Matt QQ：6637456"
fi
