# PandocX

A Pandoc docker image with some extra tools and filters.

## Tools

### latest

- typst

### diagram

- graphviz
- plantuml

## Lua filters

- https://github.com/pandoc/lua-filters
- https://github.com/pandoc-ext/diagram

## Usage

### Basic usage

```bash
podman run --rm docker.io/blackdesk/pandocx \
  -v "$PWD:/data" \
  relative/path/to/source/file -o relative/path/to/output/file
```

### Advanced usage

Directory `/pandocx/share` in container is
prepended to environment variable `$XDG_DATA_DIRS`
**AND** set as `$XDG_DATA_HOME`,
which means that you can easily add external fonts and templates
to the pandoc (see pandoc document about `--data-dir` option)
inside container like this:

```bash
# Add host fonts to container
EXTERNAL_FONTS_DIR=/usr/share/fonts
# Add user pandoc templates
EXTERNAL_TEMPLATES_DIR="~/.local/share/pandoc/templates"

podman run --rm docker.io/blackdesk/pandocx \
  -v "$PWD:/data" \
  -v "$EXTERNAL_FONTS_DIR:/pandocx/share/fonts" \
  -v "$EXTERNAL_TEMPLATES_DIR:/pandocx/share/pandoc/templates" \
  relative/path/to/source/file -o relative/path/to/output/file
```
