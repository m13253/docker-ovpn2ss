#!/bin/sh

supervisorctl -c /etc/supervisord.conf stop go-shadowsocks2 httproxy
sleep 1
cp /resolv.conf /etc/resolv.conf
