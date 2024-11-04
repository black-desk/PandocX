FROM docker.io/alpine AS builder

COPY . /tmp/source
WORKDIR /tmp/source
RUN \
        apk add --no-cache --update make && \
        make install && \
        apk del make

FROM docker.io/pandoc/core:latest

RUN apk add --no-cache --update typst

ARG extra_packages

RUN apk add --no-cache --update ${extra_packages}

COPY --from=builder /usr/local/share/pandoc /usr/local/share/pandoc

ENTRYPOINT ["/usr/local/bin/pandoc"]
