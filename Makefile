SRC  := $(wildcard *.adoc)
HTML := $(patsubst %.adoc,%.html,$(SRC))
PDF  := $(patsubst %.adoc,%.pdf,$(SRC))

SHELL := /bin/bash
APDF_OPTS := asciidoctor-pdf -r asciidoctor-mathematical

all: $(HTML) $(PDF)

clean:
	rm -f $(HTML) $(PDF)

%.html: %.adoc
	bundle exec asciidoctor -b html5 $^ --trace > $@

%.pdf: %.adoc
	bundle exec ${APDF_OPTS} $^ --trace > $@

open:
	open *.html

