MAIN_SRC := $(wildcard gmt-*.adoc)
DOC      := $(patsubst %.adoc,%.doc,$(MAIN_SRC))
XML      := $(patsubst %.adoc,%.xml,$(MAIN_SRC))
HTML     := $(patsubst %.adoc,%.html,$(MAIN_SRC))
DOCTYPE  := gb

ALL_ADOC_SRC := *.adoc **/*.adoc
SRC_doc      := $(ALL_ADOC_SRC)
SRC_xml      := $(ALL_ADOC_SRC)
SRC_html     := $(ALL_ADOC_SRC)

MAIN_UML_SRC := model.uml
XMI          := $(patsubst %.uml,%.xmi,$(MAIN_UML_SRC))
PNG          := $(patsubst %.uml,%.png,$(MAIN_UML_SRC))
SVG          := $(patsubst %.uml,%.svg,$(MAIN_UML_SRC))

ALL_UML_SRC := *.uml
SRC_xmi     := $(ALL_UML_SRC)
SRC_png     := $(ALL_UML_SRC)
SRC_svg     := $(ALL_UML_SRC)

ALL_SRC := $(ALL_ADOC_SRC) $(ALL_UML_SRC)

FORMATS := html doc xml xmi png svg

_OUT_FILES := $(foreach FORMAT,$(FORMATS),$(shell echo $(FORMAT) | tr '[:lower:]' '[:upper:]'))
OUT_FILES  := $(foreach F,$(_OUT_FILES),$($F))

SHELL := /bin/bash

all: $(OUT_FILES)

%.png: %.uml
	plantuml $^

%.xmi: %.uml
	plantuml -xmi:star $^

%.xml %.html %.doc:	%.adoc | bundle
	bundle exec metanorma -t $(DOCTYPE) -x html -r 'asciidoctor-gb' $^

define FORMAT_TASKS
OUT_FILES-$(FORMAT) := $($(shell echo $(FORMAT) | tr '[:lower:]' '[:upper:]'))

open-$(FORMAT):
	open $$(OUT_FILES-$(FORMAT))

clean-$(FORMAT):
	rm -f $$(OUT_FILES-$(FORMAT))

$(FORMAT): clean-$(FORMAT) $$(OUT_FILES-$(FORMAT))

.PHONY: clean-$(FORMAT)

endef

$(foreach FORMAT,$(FORMATS),$(eval $(FORMAT_TASKS)))

# open: $(foreach FORMAT,$(FORMATS),open-$(FORMAT))

open: open-html

clean:
	rm -f $(OUT_FILES)

bundle:
	bundle

.PHONY: bundle all open clean

#
# Watch-related jobs
#

.PHONY: watch serve watch-serve

NODE_BINS          := onchange live-serve run-p
NODE_BIN_DIR       := node_modules/.bin
NODE_PACKAGE_PATHS := $(foreach PACKAGE_NAME,$(NODE_BINS),$(NODE_BIN_DIR)/$(PACKAGE_NAME))

$(NODE_PACKAGE_PATHS): package.json
	npm i

watch: $(NODE_BIN_DIR)/onchange
	make all
	$< $(ALL_SRC) -- make all

define WATCH_TASKS
watch-$(FORMAT): $(NODE_BIN_DIR)/onchange
	make $(FORMAT)
	$$< $$(SRC_$(FORMAT)) -- make $(FORMAT)

.PHONY: watch-$(FORMAT)
endef

$(foreach FORMAT,$(FORMATS),$(eval $(WATCH_TASKS)))

serve: $(NODE_BIN_DIR)/live-server revealjs-css reveal.js images
	export PORT=$${PORT:-8123} ; \
	port=$${PORT} ; \
	for html in $(HTML); do \
		$< --entry-file=$$html --port=$${port} --ignore="*.html,*.xml,Makefile,Gemfile.*,package.*.json" --wait=1000 & \
		port=$$(( port++ )) ;\
	done

watch-serve: $(NODE_BIN_DIR)/run-p
	$< watch serve
