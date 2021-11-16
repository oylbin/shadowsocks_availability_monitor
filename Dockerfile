FROM alpine:3.10.9
RUN apk add --no-cache bash build-base git autoconf automake gettext pcre-dev libtool asciidoc xmlto udns-dev c-ares-dev libev-dev libsodium-dev mbedtls-dev linux-headers && \
    git clone --recurse-submodules --depth 1 --branch v3.1.3 https://github.com/shadowsocks/shadowsocks-libev /tmp/shadowsocks-libev && \
    cd /tmp/shadowsocks-libev && \
    ./autogen.sh && ./configure && make && make install && \
    git clone --recurse-submodules --depth 1 --branch v0.0.5 https://github.com/shadowsocks/simple-obfs.git /tmp/simple-obfs && \
    cd /tmp/simple-obfs && \
    ./autogen.sh && ./configure && make && make install && \
    apk del build-base git autoconf automake gettext libtool asciidoc xmlto linux-headers && \
    rm -rf /tmp/shadowsocks-libev && \
    rm -rf /tmp/simple-obfs 
