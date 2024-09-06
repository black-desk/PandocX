# PandocX

A Pandoc docker image with some extra tools and filters.

## Avaiable tools in container

| tag       | tools                   |
| --------- | ----------------------- |
| `latest`  | typst                   |
| `diagram` | typst plantuml graphviz |

## Avaiable lua filters

- All filters in https://github.com/pandoc/lua-filters

  `include-files.lua` is patched.
  Check [the patch](./0001-include-files-add-pandoc_markdown-support.patch)
  for details.

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
# Default container engine is podman, you can use docker.
# export CONTAINER_ENGINE=podman
# Default container repository, you can use your own repository.
# export CONTAINER_REPOSITORY=docker.io/blackdesk/pandocx
make # for `latest` tag
make diagram # for `diagram` tag
```
