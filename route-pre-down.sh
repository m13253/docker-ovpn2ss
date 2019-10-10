#!/bin/sh

supervisorctl stop go-shadowsocks2
sleep 1
cp /resolv.sh /etc/resolv.conf
