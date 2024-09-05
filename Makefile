CONTAINER_REPOSITORY := docker.io/blackdesk/pandocx

.PHONY: all
all: lua-filters/.build/lua-filters/filters
	podman build . -t $(CONTAINER_REPOSITORY):latest

.PHONY: diagram
diagram: lua-filters/.build/lua-filters/filters
	podman build . -t $(CONTAINER_REPOSITORY):diagram \
		--build-arg extra_packages="graphviz plantuml" 

lua-filters/.build/lua-filters/filters: apply-patch
	cd ./lua-filters && make collection

.PHONY: apply-patch
apply-patch:
	cd ./lua-filters && patch -p1 < ../0001-include-files-add-pandoc_markdown-support.patch
