CONTAINER_ENGINE := podman
CONTAINER_REPOSITORY := docker.io/blackdesk/pandocx

.PHONY: all
all: lua-filters/.build/lua-filters/filters
	$(CONTAINER_ENGINE) build . -t $(CONTAINER_REPOSITORY):latest

.PHONY: diagram
diagram: lua-filters/.build/lua-filters/filters
	$(CONTAINER_ENGINE) build . -t $(CONTAINER_REPOSITORY):diagram \
		--build-arg extra_packages="graphviz plantuml" 

lua-filters/.build/lua-filters/filters:
	cd ./lua-filters && make collection
