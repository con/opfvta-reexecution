# From  https://tex.stackexchange.com/questions/40738/how-to-properly-make-a-latex-project
# -----------------------------------------------------------------------------
# You want latexmk to *always* run, because make does not have all the info.
# Also, include non-file targets in .PHONY so they are run regardless of any
# file of the given name existing.
.PHONY: clean

# If executing in a container:
LATEX_IMAGE=docker.io/asmacdo/latex-biber:0.0.1-alpha

SHELL = /bin/bash


COMMON := $(wildcard common/*)
TEX := $(wildcard *.tex)
STYLE := $(wildcard sty/* rescience.cls)
DATA := $(wildcard data/*.dot)

# The first rule in a Makefile is the one executed by default ("make"). It
# should always be the "all" rule, so that "make" and "make all" are identical.

all: article


# CUSTOM BUILD RULES
# -----------------------------------------------------------------------------
metadata.tex: metadata.yaml
	./yaml-to-latex.py -i $< -o $@


# MAIN LATEXMK RULE
# -----------------------------------------------------------------------------
# -pdf tells latexmk to generate PDF directly (instead of DVI).
# -pdflatex="" tells latexmk to call a specific backend with specific options.
# -use-make tells latexmk to call make for generating missing files.
# -interaction=nonstopmode keeps the pdflatex backend from stopping at a
# missing file reference and interactively asking you for an alternative.

data/paperdiff.log:
	cd prepare; ./paperdiff.sh

data/paperdiff.csv: data/paperdiff.log
	cd prepare; python paperdiff_parse.py

figs/paperdiff_pages.pdf: data/paperdiff.csv
	cd scripts; python paperdiff_pages.py

data/topology.pdf: data/topology.dot
	cd data; dot -Tpdf topology.dot -o topology.pdf 2>| topology.log

container-article: $(COMMON) $(TEX) $(STYLE) $(DATA) live
	podman run --rm -i --net=none -v "$(PWD)":/data:Z --user="$(id -u):$(id -g)" "$(LATEX_IMAGE)" latexmk -pdf -pdflatex="xelatex -interaction=nonstopmode -shell-escape" -use-make /data/article.tex -f
	find . -type f -name 'article*' ! -name '*.py' ! -name '*.tex' -exec mv -f {} ../generated/ \;

article: $(COMMON) $(TEX_ALL) $(STYLE) $(DATA) live
	max_repeat=1 latexmk -pdf -pdflatex="xelatex -interaction=nonstopmode" -use-make article.tex -f

live:
	@rm -f data/*.pdf

clean: live
	@latexmk -CA
	@rm -f *.bbl
	@rm -f *.run.xml
