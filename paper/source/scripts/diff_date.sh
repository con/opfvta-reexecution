# Cropbox is:
#  - left boundary (from left)
#  - vertical boundary (from bottom)
#  - right boundary (from left)
#  - top boundary (from bottom)

gs \
  -o ../figs/diff_date.pdf \
  -dFirstPage=1 -dLastPage=1 \
  -sDEVICE=pdfwrite \
  -c "[/CropBox [180 20 415 120]" \
  -c " /PAGES pdfmark" \
  -f ../data/paperdiff.pdf

