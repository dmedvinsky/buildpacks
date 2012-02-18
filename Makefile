OUTDIR = ./out
PUBDIR = ./static

NODE = $(shell which node)
NPM = $(shell which npm)
NPMBIN = $(shell $(NPM) bin)
COFFEE = $(shell test -x "$(NPMBIN)/coffee" && echo $(NPMBIN)/coffee || which coffee)
SASS = $(shell which sass)
SUPERVISOR = $(shell test -x "$(NPMBIN)/supervisor" && echo $(NPMBIN)/supervisor || which supervisor)

SRC_COFFEE = $(wildcard src/*.coffee)
SRC_SASS = $(wildcard src/sass/*.sass)


build: build_coffee build_sass

build_coffee: $(SRC_COFFEE)
	"$(COFFEE)" --compile --output $(OUTDIR) $^

build_sass: $(SRC_SASS)
	for f in $^; do \
	"$(SASS)" --unix-newlines --update --force --style compressed $$f:$(PUBDIR)/css/$$(basename $$f | sed -e 's/sass/css/'); \
	done

clean:
	rm -rf $(OUTDIR)
	rm -rf $(PUBDIR)/css

.PHONY: serve-dev
serve-dev:
	"$(SUPERVISOR)" --watch src --extensions coffee --exec "$(COFFEE)" ./src/app.coffee

.PHONY: run
run: build
	"$(NODE)" $(OUTDIR)/app.js

