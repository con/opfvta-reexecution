# From  https://tex.stackexchange.com/questions/40738/how-to-properly-make-a-latex-project
# -----------------------------------------------------------------------------
# You want latexmk to *always* run, because make does not have all the info.
# Also, include non-file targets in .PHONY so they are run regardless of any
# file of the given name existing.
.PHONY: clean

# If executing in a container:
LATEX_IMAGE=docker.io/asmacdo/latex-biber:0.0.1-alpha

# Common options for podman invocations
PODMAN_ARGS = --rm  -v "$(PWD)":/data:Z --user="$(id -u):$(id -g)" "$(LATEX_IMAGE)"

SHELL = /bin/bash


COMMON := $(wildcard common/*)
TEX := $(wildcard *.tex) metadata.tex
STYLE := $(wildcard sty/* rescience.cls)
DATA := $(wildcard data/*.dot)

# The first rule in a Makefile is the one executed by default ("make"). It
# should always be the "all" rule, so that "make" and "make all" are identical.

.PHONY: all
.PHONY: article

all: article
article: article.pdf


# CUSTOM BUILD RULES
# -----------------------------------------------------------------------------
metadata.tex: metadata.yaml
	./yaml-to-latex.py -i $< -o $@


#
# FIGURES GENERATION RULES
# -----------------------------------------------------------------------------
data/paperdiff.log data/paperdiff.pdf:
	cd prepare; ./paperdiff.sh

data/paperdiff.csv: data/paperdiff.log
	cd prepare; python paperdiff_parse.py

figs/diff_date.pdf: data/paperdiff.pdf
	cd scripts; ./diff_date.sh

figs/diff_fig.pdf: data/paperdiff.pdf
	cd scripts; ./diff_fig.sh

figs/diff_text.pdf: data/paperdiff.pdf
	cd scripts; ./diff_text.sh

figs/diff_pages.pdf: data/paperdiff.csv
	cd scripts; python diff_pages.py

figs/topology.pdf: data/topology.dot
	cd data; dot -Tpdf topology.dot -o ../figs/topology.pdf 2>| topology.log

# MAIN LATEXMK RULE
# -----------------------------------------------------------------------------
# -pdf tells latexmk to generate PDF directly (instead of DVI).
# -pdflatex="" tells latexmk to call a specific backend with specific options.
# -use-make tells latexmk to call make for generating missing files.
# -interaction=nonstopmode keeps the pdflatex backend from stopping at a
# missing file reference and interactively asking you for an alternative.
container-article-interactive: $(COMMON) $(TEX) $(STYLE) $(DATA) live
	podman run -it $(PODMAN_ARGS)

.PHONY: container-article
container-article: $(COMMON) $(TEX) $(STYLE) $(DATA) live
	podman run --net=none $(PODMAN_ARGS) \
		$(MAKE) article

article.pdf: $(COMMON) $(TEX) $(STYLE) $(DATA)
	latexmk -pdf -pdflatex="xelatex -interaction=nonstopmode" -use-make article.tex
	# find . -type f -name 'article*' ! -name '*.py' ! -name '*.tex' -exec mv -f {} ../generated/ \;

live:
	rm -f article.pdf
	@rm -f data/*.pdf
	@rm -f figs/*.pdf

clean: live
	@latexmk -CA
	@rm -f *.bbl
	@rm -f *.run.xml
