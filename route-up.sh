#!/bin/sh

cp /resolv-vpn.conf /etc/resolv.conf
supervisorctl -c /etc/supervisord.conf start go-shadowsocks2 httpproxy
