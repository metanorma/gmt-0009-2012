SHELL := /bin/bash

OUTDIR := docs
ADOC   := $(wildcard ./index*.adoc)
DOC    := $(patsubst ./%.adoc,docs/%.doc,$(ADOC))
XML    := $(patsubst ./%.adoc,docs/%.xml,$(ADOC))
HTML   := $(patsubst ./%.adoc,docs/%.html,$(ADOC))

.PHONY: all clean open

all: $(HTML) $(XML) #$(DOC)

clean:
	rm -f $(HTML) $(DOC) $(XML)

$(OUTDIR)/%.xml: %.adoc $(OUTDIR)
	bundle exec asciidoctor -b gb -r 'asciidoctor-gb' -D $(OUTDIR) --trace $<

# $(OUTDIR)/%.doc: %.xml $(OUTDIR)
# 	bundle exec ruby `bundle show asciidoctor-iso`/lib/asciidoctor/iso/word/wordconvert.rb $(PWD)/$^

$(OUTDIR)/%.html: %.adoc $(OUTDIR)
	bundle exec asciidoctor -b html5 -D $(OUTDIR) --trace $<

# $(OUTDIR)/%.pdf: %.adoc $(OUTDIR)
# 	bundle exec ${APDF_OPTS} $< -D $(OUTDIR) --trace

open:
	open $(OUTDIR)/*.html

$(OUTDIR): empty
	mkdir -p $(OUTDIR)

empty: ;
