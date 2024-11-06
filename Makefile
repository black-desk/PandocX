DESTDIR ?=

prefix      ?= /usr/local
bindir      ?= $(prefix)/bin
libdir      ?= $(prefix)/lib
libexecdir  ?= $(prefix)/libexec
datarootdir ?= $(prefix)/share

INSTALL         ?= install
INSTALL_PROGRAM ?= $(INSTALL)
INSTALL_DATA    ?= $(INSTALL) -m 644

SHELL = sh

CONTAINER_ENGINE := podman
CONTAINER_REPOSITORY := docker.io/blackdesk/pandocx

.PHONY: all
all: filters

.PHONY: images
images: image-latest image-diagram image-extra

.PHONY: image-latest
image-latest: filters templates
	$(CONTAINER_ENGINE) build --network=host . --target latest -t $(CONTAINER_REPOSITORY):latest

.PHONY: image-diagram
image-diagram: filters templates
	$(CONTAINER_ENGINE) build --network=host . --target diagram -t $(CONTAINER_REPOSITORY):diagram

.PHONY: image-extra
image-extra: filters templates
	$(CONTAINER_ENGINE) build --network=host . --target extra -t $(CONTAINER_REPOSITORY):extra

.PHONY: push-images
push-images: push-image-latest push-image-diagram push-image-extra

.PHONY: push-image-latest
push-image-latest:
	$(CONTAINER_ENGINE) push $(CONTAINER_REPOSITORY):latest

.PHONY: push-image-diagram
push-image-diagram:
	$(CONTAINER_ENGINE) push $(CONTAINER_REPOSITORY):diagram

.PHONY: push-image-extra
push-image-extra:
	$(CONTAINER_ENGINE) push $(CONTAINER_REPOSITORY):extra

.PHONY: filters
filters: lua-filters/.build/lua-filters/filters
	cp -r ./lua-filters/.build/lua-filters/filters .
	cp -L ./diagram/diagram.lua ./filters

lua-filters/.build/lua-filters/filters:
	cd ./lua-filters && make collection

.PHONY: clean
clean:
	rm -rf ./filters
	rm -rf ./lua-filters/.build

.PHONY: install-data
install-data:
	$(INSTALL) -d "$(DESTDIR)$(datarootdir)"/pandoc/filters
	$(INSTALL_DATA) ./filters/abstract-to-meta.lua "$(DESTDIR)$(datarootdir)/pandoc/filters"
	$(INSTALL_DATA) ./filters/author-info-blocks.lua "$(DESTDIR)$(datarootdir)/pandoc/filters"
	$(INSTALL_DATA) ./filters/bibexport.lua "$(DESTDIR)$(datarootdir)/pandoc/filters"
	$(INSTALL_DATA) ./filters/cito.lua "$(DESTDIR)$(datarootdir)/pandoc/filters"
	$(INSTALL_DATA) ./filters/diagram-generator.lua "$(DESTDIR)$(datarootdir)/pandoc/filters"
	$(INSTALL_DATA) ./filters/diagram.lua "$(DESTDIR)$(datarootdir)/pandoc/filters"
	$(INSTALL_DATA) ./filters/doi2cite.lua "$(DESTDIR)$(datarootdir)/pandoc/filters"
	$(INSTALL_DATA) ./filters/first-line-indent.lua "$(DESTDIR)$(datarootdir)/pandoc/filters"
	$(INSTALL_DATA) ./filters/include-code-files.lua "$(DESTDIR)$(datarootdir)/pandoc/filters"
	$(INSTALL_DATA) ./filters/include-files.lua "$(DESTDIR)$(datarootdir)/pandoc/filters"
	$(INSTALL_DATA) ./filters/latex-hyphen.lua "$(DESTDIR)$(datarootdir)/pandoc/filters"
	$(INSTALL_DATA) ./filters/lilypond.lua "$(DESTDIR)$(datarootdir)/pandoc/filters"
	$(INSTALL_DATA) ./filters/list-table.lua "$(DESTDIR)$(datarootdir)/pandoc/filters"
	$(INSTALL_DATA) ./filters/lua-debug-example.lua "$(DESTDIR)$(datarootdir)/pandoc/filters"
	$(INSTALL_DATA) ./filters/math2svg.lua "$(DESTDIR)$(datarootdir)/pandoc/filters"
	$(INSTALL_DATA) ./filters/mhchem.lua "$(DESTDIR)$(datarootdir)/pandoc/filters"
	$(INSTALL_DATA) ./filters/minted.lua "$(DESTDIR)$(datarootdir)/pandoc/filters"
	$(INSTALL_DATA) ./filters/multiple-bibliographies.lua "$(DESTDIR)$(datarootdir)/pandoc/filters"
	$(INSTALL_DATA) ./filters/not-in-format.lua "$(DESTDIR)$(datarootdir)/pandoc/filters"
	$(INSTALL_DATA) ./filters/pagebreak.lua "$(DESTDIR)$(datarootdir)/pandoc/filters"
	$(INSTALL_DATA) ./filters/pandoc-quotes.lua "$(DESTDIR)$(datarootdir)/pandoc/filters"
	$(INSTALL_DATA) ./filters/revealjs-codeblock.lua "$(DESTDIR)$(datarootdir)/pandoc/filters"
	$(INSTALL_DATA) ./filters/scholarly-metadata.lua "$(DESTDIR)$(datarootdir)/pandoc/filters"
	$(INSTALL_DATA) ./filters/scrlttr2.lua "$(DESTDIR)$(datarootdir)/pandoc/filters"
	$(INSTALL_DATA) ./filters/section-refs.lua "$(DESTDIR)$(datarootdir)/pandoc/filters"
	$(INSTALL_DATA) ./filters/short-captions.lua "$(DESTDIR)$(datarootdir)/pandoc/filters"
	$(INSTALL_DATA) ./filters/spellcheck.lua "$(DESTDIR)$(datarootdir)/pandoc/filters"
	$(INSTALL_DATA) ./filters/table-short-captions.lua "$(DESTDIR)$(datarootdir)/pandoc/filters"
	$(INSTALL_DATA) ./filters/track-changes.lua "$(DESTDIR)$(datarootdir)/pandoc/filters"
	$(INSTALL_DATA) ./filters/wordcount.lua "$(DESTDIR)$(datarootdir)/pandoc/filters"
	$(INSTALL) -d "$(DESTDIR)$(datarootdir)"/pandoc/templates
	$(INSTALL_DATA) ./templates/PandocX.typst "$(DESTDIR)$(datarootdir)/pandoc/templates"
	$(INSTALL_DATA) ./templates/PandocX-template.typ "$(DESTDIR)$(datarootdir)/pandoc/templates"
	$(INSTALL_DATA) ./templates/PandocX-definitions.typ "$(DESTDIR)$(datarootdir)/pandoc/templates"
	$(INSTALL_DATA) ./templates/PandocX-include-before.typ "$(DESTDIR)$(datarootdir)/pandoc/templates"

.PHONY: install-bin
install-bin:
	$(INSTALL) -d "$(DESTDIR)$(bindir)"
	$(INSTALL_PROGRAM) ./pandocx "$(DESTDIR)$(bindir)"

.PHONY: install
install: install-data install-bin
