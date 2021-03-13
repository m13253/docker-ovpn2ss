FROM alpine:edge

RUN apk update && \
    apk upgrade && \
    apk add build-base nftables openvpn git go py3-setuptools supervisor && \
    go get -u -v github.com/justmao945/httproxy github.com/shadowsocks/go-shadowsocks2

ADD entrypoint.sh resolv-vpn.conf resolv.conf route-pre-down.sh route-up.sh start-ss.sh /
ADD supervisord.conf /etc
ADD openvpn.ovpn openvpn.secrets /etc/openvpn/

EXPOSE 8388/tcp
EXPOSE 8388/udp
CMD ["/bin/sh", "-c", "/entrypoint.sh"]
