#!/usr/bin/env bash

cd "$(dirname "$0")"

# gs will succeed even if pointed to an empty file.
set -eu

SHOWCASE_PDF=${1}

# Cropbox is:
#  - left boundary (from left)
#  - lower boundary (from bottom)
#  - right boundary (from left)
#  - top boundary (from bottom)

gs \
  -o ../figs/diff_fig.pdf \
  -dFirstPage=14 -dLastPage=14 \
  -sDEVICE=pdfwrite \
  -c "[/CropBox [45 621 560 825]" \
  -c " /PAGES pdfmark" \
  -f ../${SHOWCASE_PDF}

