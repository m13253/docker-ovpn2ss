#!/bin/sh

supervisorctl -c /etc/supervisord.conf stop go-shadowsocks2 httpproxy
sleep 1
cp /resolv.conf /etc/resolv.conf
