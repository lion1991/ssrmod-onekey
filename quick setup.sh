#!/bin/sh

echo '#############################################
##################参数配置###################
###############这里做基本配置################
#####请将脚本放入shadowsocks根目录下执行#####
#############################################'

echo "按 <Y> 确认继续配置，其他键退出:"
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

echo "配置完成，Enjoy it！"
echo "需要修改参数时可再次执行此脚本"
echo "制作人：Matt QQ：6637456"
echo "魔改交流群：567667802"

fi
