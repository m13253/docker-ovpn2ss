#!/bin/sh

GATEWAY_IPv4="$(ip -4 route get 192.0.2.1 dev eth0 | grep -o 'via\s\S*')"
GATEWAY_IPv6="$(ip -6 route get 2001:db8::1 dev eth0 | grep -o 'via\s\S*')"

# Assume we connect to the VPN server through an IPv4 connection,
# Disable IPv6 outside the VPN connection to prevent leaking.
# If we connect to the VPN server through IPv6, change "-6" to "-4".
ip -6 route flush table main

ip -4 route add blackhole default dev eth0 metric 2147483647 table 8388
ip -4 rule add ipproto udp sport 8388 table 8388 priority 8388
ip -4 rule add fwmark 0x8388 table 8388 priority 8389
ip -6 route add blackhole default dev eth0 metric 2147483647 table 8388
ip -6 rule add ipproto udp sport 8388 table 8388 priority 8388
ip -6 rule add fwmark 0x8388 table 8388 priority 8389
if [ -n "$GATEWAY_IPv4" ]
then
    ip -4 route add default $GATEWAY_IPv4 dev eth0 table 8388
fi
if [ -n "$GATEWAY_IPv6" ]
then
    ip -6 route add default $GATEWAY_IPv6 dev eth0 table 8388
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

nft add table inet filter
nft add chain inet filter input { type filter hook input priority filter \; policy accept \; }
nft add rule inet filter input iifname != "eth0" tcp dport 8080 counter reject with tcp reset
nft add rule inet filter input iifname != "eth0" tcp dport 8388 counter reject with tcp reset
nft add rule inet filter input iifname != "eth0" udp dport 8388 counter reject

umount /etc/resolv.conf
cp /resolv.conf /etc/resolv.conf
exec supervisord -c /etc/supervisord.conf
