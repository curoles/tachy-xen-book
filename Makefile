SRC_DIR ?= .
OUT_DIR ?= ./build

MASTER_ADOC := $(SRC_DIR)/tachy-xen-book.adoc

SRCs := $(MASTER_ADOC) $(SRC_DIR)/intro/intro.adoc

ADIAGRAM := -r asciidoctor-diagram


.PHONY: outputs pdf_output html_output docbook_output

outputs: pdf_output html_output

pdf_output: $(SRCs)
	asciidoctor-pdf -a icons -a allow-uri-read -d book $(ADIAGRAM) -D $(OUT_DIR)/pdf $(MASTER_ADOC)

html_output: $(SRCs)
	asciidoctor -b html5 -a icons -d book $(ADIAGRAM) -D $(OUT_DIR)/html $(MASTER_ADOC)

docbook_output: $(SRCs)
	asciidoctor -b docbook5 -a icons -d book $(ADIAGRAM) -D $(OUT_DIR)/docbook $(MASTER_ADOC)
	cd $(OUT_DIR)/docbook && pandoc -f docbook tachy-xen-book.xml -o tachy-xen-docbook.pdf

.PHONY: clean
clean:
	rm -rf $(OUT_DIR)/*

define helpmsg
Suggested usage is to create directory named build one level up
and create Makefile there:
SRC_DIR := ../tachy-xen-book
OUT_DIR := .
include $(SRC_DIR)/Makefile
endef

.PHONY: help
help:
	@: $(info $(helpmsg))


ATRIL := $(shell command -v atril 2> /dev/null)
EVINCE := $(shell command -v evince 2> /dev/null)

.PHONY: view-pdf
view-pdf:
ifdef ATRIL
	@atril $(OUT_DIR)/pdf/tachy-xen-book.pdf &
else ifdef EVINCE
	@evince $(OUT_DIR)/pdf/tachy-xen-book.pdf &
else
	@gnome-open $(OUT_DIR)/pdf/tachy-xen-book.pdf &
endif
