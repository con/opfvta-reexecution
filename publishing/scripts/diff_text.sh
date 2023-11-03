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
  -o ../figs/diff_text.pdf \
  -dFirstPage=4 -dLastPage=4 \
  -sDEVICE=pdfwrite \
  -c "[/CropBox [290 540 560 860]" \
  -c " /PAGES pdfmark" \
  -f ../${SHOWCASE_PDF}

