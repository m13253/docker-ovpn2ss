#!/bin/sh

SS_SERVER="ss://AEAD_CHACHA20_POLY1305:password@:8388"

exec /root/go/bin/go-shadowsocks2 -s "${SS_SERVER}"
