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

echo "配置完成，重新启动后端生效，Enjoy it！"
echo "需要修改参数时可再次执行此脚本"
echo "制作人：Matt QQ：6637456"
fi
