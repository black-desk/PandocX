FROM docker.io/pandoc/core:latest

RUN apk add --no-cache --update typst

ARG extra_packages

RUN apk add --no-cache --update ${extra_packages}

ENV PANDOCX_PREFIX /pandocx
ENV PANDOCX_DATA_DIR ${PANDOCX_PREFIX}/share
ENV PANDOCX_PANDOC_DATA_DIR ${PANDOCX_DATA_DIR}/pandoc

ENV XDG_DATA_DIRS="${XDG_DATA_DIRS:-/usr/local/share:/usr/share}:${PANDOCX_DATA_DIR}"
ENV XDG_DATA_HOME="${PANDOCX_DATA_DIR}"

COPY lua-filters/.build/lua-filters/filters ${PANDOCX_PANDOC_DATA_DIR}/filters
COPY diagram/diagram.lua ${PANDOCX_PANDOC_DATA_DIR}/filters/

ENTRYPOINT ["/usr/local/bin/pandoc"]
