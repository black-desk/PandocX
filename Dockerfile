FROM docker.io/alpine AS builder

COPY . /tmp/source
WORKDIR /tmp/source
RUN \
        apk add --no-cache --update make && \
        make install

RUN \
        apk add --no-cache --update curl

RUN \
        mkdir -p /opt/plantuml && \
        curl -o /opt/plantuml/plantuml.jar -L "http://github.com/plantuml/plantuml/releases/latest/download/plantuml.jar" && \
        printf '#!/bin/sh\nexec java -Djava.awt.headless=true -jar /opt/plantuml/plantuml.jar "$@"' > /usr/local/bin/plantuml && \
        chmod +x /usr/local/bin/plantuml

RUN \
        mkdir -p /usr/local/share/fonts && \
        curl -o /usr/local/share/fonts/LXGWWenKai-Light.ttf -L "http://github.com/lxgw/LxgwWenKai/releases/latest/download/LXGWWenKai-Light.ttf" && \
        curl -o /usr/local/share/fonts/LXGWWenKai-Medium.ttf -L "http://github.com/lxgw/LxgwWenKai/releases/latest/download/LXGWWenKai-Medium.ttf" && \
        curl -o /usr/local/share/fonts/LXGWWenKai-Regular.ttf -L "http://github.com/lxgw/LxgwWenKai/releases/latest/download/LXGWWenKai-Regular.ttf" && \
        curl -o /usr/local/share/fonts/LXGWWenKaiMono-Light.ttf -L "http://github.com/lxgw/LxgwWenKai/releases/latest/download/LXGWWenKaiMono-Light.ttf" && \
        curl -o /usr/local/share/fonts/LXGWWenKaiMono-Medium.ttf -L "http://github.com/lxgw/LxgwWenKai/releases/latest/download/LXGWWenKaiMono-Medium.ttf" && \
        curl -o /usr/local/share/fonts/LXGWWenKaiMono-Regular.ttf -L "http://github.com/lxgw/LxgwWenKai/releases/latest/download/LXGWWenKaiMono-Regular.ttf" && \
        curl -o /usr/local/share/fonts/LXGWWenKaiTC-Light.ttf -L "http://github.com/lxgw/LXGWWenKaiTC/releases/latest/download/LXGWWenKaiTC-Light.ttf" && \
        curl -o /usr/local/share/fonts/LXGWWenKaiTC-Medium.ttf -L "http://github.com/lxgw/LXGWWenKaiTC/releases/latest/download/LXGWWenKaiTC-Medium.ttf" && \
        curl -o /usr/local/share/fonts/LXGWWenKaiTC-Regular.ttf -L "http://github.com/lxgw/LXGWWenKaiTC/releases/latest/download/LXGWWenKaiTC-Regular.ttf" && \
        curl -o /usr/local/share/fonts/LXGWWenKaiMonoTC-Light.ttf -L "http://github.com/lxgw/LXGWWenKaiTC/releases/latest/download/LXGWWenKaiMonoTC-Light.ttf" && \
        curl -o /usr/local/share/fonts/LXGWWenKaiMonoTC-Medium.ttf -L "http://github.com/lxgw/LXGWWenKaiTC/releases/latest/download/LXGWWenKaiMonoTC-Medium.ttf" && \
        curl -o /usr/local/share/fonts/LXGWWenKaiMonoTC-Regular.ttf -L "http://github.com/lxgw/LXGWWenKaiTC/releases/latest/download/LXGWWenKaiMonoTC-Regular.ttf"

RUN \
        curl -o /tmp/typst.tar.xz -L "http://github.com/typst/typst/releases/latest/download/typst-x86_64-unknown-linux-musl.tar.xz" && \
        tar -xvf /tmp/typst.tar.xz -C /tmp && \
        mv /tmp/typst-x86_64-unknown-linux-musl/typst /usr/local/bin/typst

FROM docker.io/pandoc/core:latest AS latest
COPY --from=builder /usr/local/bin/typst /usr/local/bin/typst
COPY --from=builder /usr/local/share/pandoc /usr/local/share/pandoc
ENTRYPOINT ["/usr/local/bin/pandoc"]

FROM latest AS diagram
RUN apk add --no-cache --update graphviz openjdk8-jre
COPY --from=builder /opt/plantuml /opt/plantuml
COPY --from=builder /usr/local/bin/plantuml /usr/local/bin/plantuml

FROM diagram AS extra
RUN apk add --no-cache --update font-noto font-noto-cjk-extra
COPY --from=builder /usr/local/share/fonts /usr/local/share/fonts
