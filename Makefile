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

.PHONY: latest
latest: filters templates
	$(CONTAINER_ENGINE) build . -t $(CONTAINER_REPOSITORY):latest

.PHONY: diagram
diagram: filters templates
	$(CONTAINER_ENGINE) build . -t $(CONTAINER_REPOSITORY):diagram \
		--build-arg extra_packages="graphviz plantuml" 

.PHONY: filters
filters: lua-filters/.build/lua-filters/filters
	cp -r ./lua-filters/.build/lua-filters/filters .
	cp -L ./diagram/diagram.lua ./filters

lua-filters/.build/lua-filters/filters:
	cd ./lua-filters && make collection

.PHONY: clean
clean:
	rm -rf ./filters
	rm -rf ./templates/*.typst
	rm -rf ./lua-filters/.build

.PHONY: install-data
install-data:
	$(INSTALL) -d "$(DESTDIR)$(datarootdir)"/pandoc/filters
	find filters -type f -exec $(INSTALL_DATA) "{}" "$(DESTDIR)$(datarootdir)/pandoc/filters" \;
	$(INSTALL) -d "$(DESTDIR)$(datarootdir)"/pandoc/templates
	find templates -type f -exec $(INSTALL_DATA) "{}" "$(DESTDIR)$(datarootdir)/pandoc/templates" \;

.PHONY: install
install: install-data
