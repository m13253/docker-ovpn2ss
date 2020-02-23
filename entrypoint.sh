#!/bin/sh

GATEWAY_IPv4="$(ip -4 route get 192.0.2.1 dev eth0 | grep -o 'via\s\S*')"
GATEWAY_IPv6="$(ip -6 route get 2001:db8::1 dev eth0 | grep -o 'via\s\S*')"

# (Optionally) disable IPv6 if the VPN provider does not have IPv6 connectivity
#ip -6 route flush table main

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

nft add table inet mangle
nft add chain inet mangle input { type filter hook input priority mangle \; }
nft add rule inet mangle input iifname "eth0" counter meta mark set 0x8388
nft add rule inet mangle input counter ct mark set mark

nft add table ip mangle
nft add chain ip mangle output { type route hook output priority mangle \; policy accept \; }
nft add rule ip mangle output counter meta mark set ct mark

nft add table ip6 mangle
nft add chain ip6 mangle output { type route hook output priority mangle \; policy accept \; }
nft add rule ip6 mangle output counter meta mark set ct mark

nft add table ip nat
nft add chain ip nat prerouting { type nat hook prerouting priority dstnat \; policy accept \; }
nft add rule ip nat prerouting iifname "eth0" meta l4proto udp fib daddr type local counter redirect

nft add table ip6 nat
nft add chain ip6 nat prerouting { type nat hook prerouting priority dstnat \; policy accept \; }
nft add rule ip6 nat prerouting iifname "eth0" meta l4proto udp fib daddr type local counter redirect

umount /etc/resolv.conf
cp /resolv.conf /etc/resolv.conf
exec supervisord -n -c /etc/supervisord.conf
