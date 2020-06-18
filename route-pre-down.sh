#!/bin/sh

supervisorctl -c /etc/supervisord.conf stop go-shadowsocks2 http-proxy
sleep 1
cp /resolv.conf /etc/resolv.conf
