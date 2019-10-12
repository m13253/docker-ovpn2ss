#!/bin/sh

GATEWAY_IPv4="$(ip -4 route get 192.0.2.1 dev eth0 | grep -o 'via\s\S*')"
GATEWAY_IPv6="$(ip -6 route get 2001:db8::1 dev eth0 | grep -o 'via\s\S*')"

# (Optionally) disable IPv6 if the VPN provider does not have IPv6 connectivity
#ip -6 addr flush dev eth0
#ip -6 route flush all
if [ -n "$GATEWAY_IPv4" ]
then
    ip -4 route add default $GATEWAY_IPv4 dev eth0 table 8388
    ip -4 rule add fwmark 0x8388 table 8388 priority 8388
fi
if [ -n "$GATEWAY_IPv6" ]
then
    ip -4 route add default $GATEWAY_IPv6 dev eth0 table 8388
    ip -6 rule add fwmark 0x8388 table 8388 priority 8388
fi
iptables -t mangle -A INPUT -i eth0 -j MARK --set-mark 0x8388
iptables -t mangle -A INPUT -j CONNMARK --save-mark
iptables -t mangle -A OUTPUT -j CONNMARK --restore-mark
ip6tables -t mangle -A INPUT -i eth0 -j MARK --set-mark 0x8388
ip6tables -t mangle -A INPUT -j CONNMARK --save-mark
ip6tables -t mangle -A OUTPUT -j CONNMARK --restore-mark

umount /etc/resolv.conf
cp /resolv.conf /etc/resolv.conf
exec supervisord -n -c /etc/supervisord.conf
