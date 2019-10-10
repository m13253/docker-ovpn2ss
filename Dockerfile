FROM alpine:edge

RUN apk update && \
    apk upgrade && \
    apk add build-base openvpn git go supervisor && \
    go get -u -v github.com/shadowsocks/go-shadowsocks2

ADD openvpn.ovpn /etc/openvpn/openvpn.ovpn

EXPOSE 8388/tcp
EXPOSE 8388/udp
CMD ["/bin/sh", "-c", "/entrypoint.sh"]
