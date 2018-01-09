SHELL := /bin/bash

OUTDIR := docs
ADOC = ./index.adoc
HTML := $(patsubst ./%.adoc, docs/%.html, $(ADOC))
#PDF := $(patsubst ./%.adoc, docs/%.pdf, $(ADOC))

APDF_OPTS := asciidoctor-pdf -r asciidoctor-mathematical

all: $(HTML) #$(PDF)

clean:
	rm -f $(HTML) #$(PDF)

$(OUTDIR)/%.html: %.adoc $(OUTDIR)
	bundle exec asciidoctor -b html5 $< -D $(OUTDIR) --trace 

$(OUTDIR)/%.pdf: %.adoc $(OUTDIR)
	bundle exec ${APDF_OPTS} $< -D $(OUTDIR) --trace

open:
	open $(OUTDIR)/index.html

$(OUTDIR): empty
	mkdir -p $(OUTDIR)

empty: ;

.PHONY: all clean open
