#!/bin/sh

supervisorctl stop go-shadowsocks2
sleep 1
cp /resolv.conf /etc/resolv.conf
