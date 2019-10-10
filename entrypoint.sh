#!/bin/sh

umount /etc/resolv.conf
cp /resolv.conv /etc/resolv.conf
exec supervisord -n -c /etc/supervisord.conf
