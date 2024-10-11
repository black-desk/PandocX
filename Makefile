CONTAINER_ENGINE := podman
CONTAINER_REPOSITORY := docker.io/blackdesk/pandocx

.PHONY: all
all: filters
	$(CONTAINER_ENGINE) build . -t $(CONTAINER_REPOSITORY):latest

.PHONY: diagram
diagram: filters
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
	rm -rf ./lua-filters/.build
