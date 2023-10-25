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
  -o ../figs/diff_date.pdf \
  -dFirstPage=1 -dLastPage=1 \
  -sDEVICE=pdfwrite \
  -c "[/CropBox [180 20 415 120]" \
  -c " /PAGES pdfmark" \
  -f ../${SHOWCASE_PDF}

