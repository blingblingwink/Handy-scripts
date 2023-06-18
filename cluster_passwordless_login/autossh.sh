#!/bin/bash

# ssh-keygen
expect <(cat << EOF
spawn ssh-keygen
expect {
        "Enter file in which to save the key*"  { send "\n";exp_continue }
        "Overwrite (y/n)?*"     { send "y\n";exp_continue }
        "Enter passphrase*"     { send "\n";exp_continue }
        "Enter same passphrase again:*" { send "\n"}
}
interact
EOF
)

SERVERS="x.x.x.x y.y.y.y"   #需要配置的主机名
 
#将本机生成的公钥复制到其他机子上
#如果（yes/no）则自动选择yes继续下一步
#expect部分的缩进不要改，会报错
for SERVER in $SERVERS #遍历要发送到各个主机的ip
do
expect <(cat << EOF
spawn ssh-copy-id -i /root/.ssh/id_rsa.pub $SERVER
expect {
        "*yes/no"       { send "yes\r";exp_continue }
        "*Password:"    { send "YOUR_PASSWORD\r" }
}
interact
EOF
)
done