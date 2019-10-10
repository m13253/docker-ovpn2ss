#!/bin/sh

cp /resolv-vpn.sh /etc/resolv.conf
supervisorctl start go-shadowsocks2
