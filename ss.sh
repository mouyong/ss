#!/bin/bash

#add PORT NUMBER and PASSWORD of shadowsocks
#author: mouyong mail: my24251325@gmail.com

clear

config=/etc/shadowsocks/server.json
if [ -s $config ];then
	read -t 30 -n 1 -p 'Please enter your choose(add or delete)[a|d]: ' choose
		case $choose in
			a)
				echo
				cat $config | grep '"[0-9]*"'
				read -t 30 -n 4 -p 'Please enter you want use PORT NUMBER in 8331~8440: ' port
				echo
				read -t 30 -n 16 -p 'Please enter you want use PASSWORD: ' password

				sed -i '3a\\t\t"'$port'":"'$password'",' $config
				clear

echo "You shadowsocks imforation is: "
cat << EOF
server	:vps.iwnweb.com
port	:$port
passpord:$password
method	:rc4-md5
EOF
			;;
			d)
				echo
				cat $config | grep '"[0-9]*"'
				read -t 30 -n 4 -p 'Please enter you want delete PORT NUMBER in 8331~8440: ' port
				sed -i "/$port/d" $config
				clear
				echo 'delete success'
			;;
esac

else

sudo touch $config

cat >$config<<EOF
{
	"server":"vps.iwnweb.com",
	"port_password":{
		"8331":"test"
	},
	"timeout":300,
	"method":"rc4-md5",
	"fast_open":false,
	"workers":10
}
EOF
	if [ -n $(sudo iptables -L | grep ':833[0-9]') ];then
		sudo iptables -A INPUT -p tcp --dport 8331:8400 -j ACCEPT
		sudo iptables-save
	fi
	
	if [ -n $(cat /etc/rc.local | grep ssserver) ];then
cat >>/etc/rc.local<<EOF
rm /var/log/shadowsocks.log -f
#sslocal -c /etc/shadowsocks/zbb.json --pid-file /var/run/shadowsocks/zbb.pid --log-file /var/log/shadowsocks/zbb -d start
ssserver -c /etc/shadowsocks/server.json -d start
EOF
	fi
	
clear
fi
