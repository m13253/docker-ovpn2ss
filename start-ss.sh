#!/bin/sh

SS_SERVER="ss://CHACHA20-IETF:password@:8388"

exec /root/go/bin/go-shadowsocks2 -verbose -s "${SS_SERVER}"
