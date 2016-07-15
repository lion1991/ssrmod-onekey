#!/bin/sh
echo '#############################################
############欢迎使用SSR便捷安装包############
#########此脚本只在Centos下通过测试##########
###############感谢glzjin！##################'
echo '确认安装请按<Y>:'
read con
if [ "$con" == "Y" ] ; then
cd /root
yum install -y wget
yum install -y python-setuptools && easy_install pip
yum install -y git

echo ' ########开始安装libsodium#########'
yum -y groupinstall "Development Tools"
wget https://github.com/jedisct1/libsodium/releases/download/1.0.10/libsodium-1.0.10.tar.gz
tar xf libsodium-1.0.10.tar.gz && cd libsodium-1.0.10
./configure && make -j2 && make install
echo /usr/local/lib > /etc/ld.so.conf.d/usr_local_lib.conf
ldconfig
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
echo "请输入你的Mysql地址:"
read ip
echo "请输入你的Mysql用户名:"
read user
echo "请输入你的Mysql密码:"
read pwd
echo "请输入你的Mysql数据库名:"
read dbname
sed -i '/NODE_ID/d' userapiconfig.py
sed -i '1a NODE_ID = '$nodeid'' userapiconfig.py
sed -i '/MYSQL_HOST/d' userapiconfig.py
sed -i "17a MYSQL_HOST = '$ip'" userapiconfig.py
sed -i '/MYSQL_USER/d' userapiconfig.py
sed -i "19a MYSQL_USER = '$user'" userapiconfig.py
sed -i '/MYSQL_PASS/d' userapiconfig.py
sed -i "20a MYSQL_PASS = '$pwd'" userapiconfig.py
sed -i '/MYSQL_DB/d' userapiconfig.py
sed -i "17a MYSQL_DB = '$dbname'" userapiconfig.py

echo ' #########开始安装supervisiord#########'

wget –no-check-certificate https://pypi.python.org/packages/source/s/supervisor/supervisor-3.0.tar.gz
tar -zxvf supervisor-3.0.tar.gz && cd supervisor-3.0
python setup.py install
echo_supervisord_conf > /etc/supervisord.conf
sed -i '$a [program:shadowsocks]' /etc/supervisord.conf
sed -i '$a command = python server.py' /etc/supervisord.conf
sed -i '$a directory = /root/shadowsocks' /etc/supervisord.conf
sed -i '$a user=root' /etc/supervisord.conf
sed -i '$a autostart=true' /etc/supervisord.conf
sed -i '$a autorestart=true' /etc/supervisord.conf
sed -i '$a stderr_logfile = /var/log/shadowsocks.log' /etc/supervisord.conf
sed -i '$a stdout_logfile = /var/log/shadowsocks.log' /etc/supervisord.conf
sed -i '$a startsecs=3' /etc/supervisord.conf
/usr/bin/supervisord -c /etc/supervisord.conf
supervisorctl reload 
sed -i '$a\supervisord' /etc/rc.d/rc.local
fi

echo '如果你是Centos7，请按<Y>继续设置开机启动,否则按其他键退出:'
read c7
if [ "$c7" == "Y" ] ; then
cd /root
echo "#!/bin/sh" >supervisord.sh
sed -i '$a #chkconfig: 2345 80 80' supervisord.sh
sed -i '$a #description: auto start supervisord' supervisord.sh
sed -i '$a supervisord' supervisord.sh
chmod +x supervisord.sh
mv supervisord.sh /etc/init.d/ 
chkconfig --add supervisord.sh
chkconfig --list supervisord.sh
fi
echo "配置完成，Enjoy it！"
echo "查看SS日志命令为supervisorctl tail -f shadowsocks stderr"
echo "重启SS守护命令为supervisorctl restart shadowsocks"
echo "停止SS守护命令为supervisorctl stop shadowsocks"
echo "如果SS正常启动后，无法“上网”请检查iptables配置"
echo "制作人：Matt QQ：6637456"
echo "魔改交流群：567667802"
