### latex Makefile
# Author: Jerry Marek

# This is a simple makefile for compiling LaTeX documents utilizing python.sty
# Based on a Makefile by Jason Hiebel

PROJECT=test

default: obj/$(PROJECT).pdf

display: default
	(${PDFVIEWER} obj/$(PROJECT).pdf &)

### Compilation Flags
PDFLATEX_FLAGS = -halt-on-error -output-directory obj/ -shell-escape

TEXINPUTS = .:obj/
TEXMFOUTPUT = obj/


### File Types (for dependencies)
TEX_FILES = $(shell find . -name '*.tex' -or -name '*.sty' -or -name '*.cls')
BIB_FILES = $(shell find . -name '*.bib')
BST_FILES = $(shell find . -name '*.bst')
IMG_FILES = $(shell find . -path '*.jpg' -or -path '*.png' -or \( \! -path './obj/*.pdf' -path '*.pdf' \) )

UNAME := $(shell uname)

ifeq ($(UNAME), Linux)
	PDFVIEWER = xdg-open
endif

clean::
	rm -rf obj/

### LaTeX Generation
obj/:
	mkdir -p obj/

obj/$(PROJECT).aux: $(TEX_FILES) $(IMG_FILES) | obj/
	xelatex $(PDFLATEX_FLAGS) $(PROJECT)
	# Comment out if not using python.sty
	mv obj/$(PROJECT).py .

obj/$(PROJECT).bbl: $(BIB_FILES) | obj/$(PROJECT).aux
	bibtex obj/$(PROJECT)
	xelatex $(PDFLATEX_FLAGS) $(PROJECT)

obj/$(PROJECT).pdf: obj/$(PROJECT).aux $(if $(BIB_FILES), obj/$(PROJECT).bbl)
	xelatex $(PDFLATEX_FLAGS) $(PROJECT)
	mkdir obj/py
	mv $(PROJECT).py obj/py/
	mv $(PROJECT).py.err obj/py/
	mv $(PROJECT).py.out obj/py
