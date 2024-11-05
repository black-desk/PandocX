# PandocX

A Pandoc docker image with some extra tools and filters.

## Avaiable tools in container

| tag       | tools                         |
| --------- | ----------------------------- |
| `latest`  | typst                         |
| `diagram` | typst plantuml graphviz       |
| `extra`   | typst plantuml graphviz fonts |

## Avaiable lua filters

- All filters in https://github.com/black-desk/lua-filters

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

## Build

```bash
git submodule update --init
# Default container engine is podman, you can use docker.
# export CONTAINER_ENGINE=podman
# Default container repository, you can use your own repository.
# export CONTAINER_REPOSITORY=docker.io/blackdesk/pandocx
make images
```
