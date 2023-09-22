#!/usr/bin/env bash

cd "$(dirname "$0")"

set -eu

# Cropbox is:
#  - left boundary (from left)
#  - lower boundary (from bottom)
#  - right boundary (from left)
#  - top boundary (from bottom)

gs \
  -o ../figs/diff_text.pdf \
  -dFirstPage=4 -dLastPage=4 \
  -sDEVICE=pdfwrite \
  -c "[/CropBox [290 540 560 870]" \
  -c " /PAGES pdfmark" \
  -f ../data/paperdiff_podman_20230906053037.pdf

