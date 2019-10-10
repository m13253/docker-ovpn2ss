#!/bin/sh

umount /etc/resolv.conf
cp /resolv.conf /etc/resolv.conf
exec supervisord -n -c /etc/supervisord.conf
