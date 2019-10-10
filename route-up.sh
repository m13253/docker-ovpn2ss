#!/bin/sh

cp /resolv-vpn.conf /etc/resolv.conf
supervisorctl start go-shadowsocks2
