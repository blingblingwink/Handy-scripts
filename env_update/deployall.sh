#!/bin/bash

SERVERS="x.x.x.x y.y.y.y"   #需要配置的主机名
 
for server in $SERVERS #遍历要发送到各个主机的ip
do
# ssh免密必须顺序执行不可以并发，否则会出错
ssh $server "./autossh.sh"
ssh $server "./install.sh" &
done