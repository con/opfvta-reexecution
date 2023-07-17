# Cropbox is:
#  - left boundary (from left)
#  - lower boundary (from bottom)
#  - right boundary (from left)
#  - top boundary (from bottom)

gs \
  -o ../figs/diff_text.pdf \
  -dFirstPage=4 -dLastPage=4 \
  -sDEVICE=pdfwrite \
  -c "[/CropBox [290 500 560 880]" \
  -c " /PAGES pdfmark" \
  -f ../data/paperdiff.pdf

