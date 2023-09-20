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
  -f ../data/paperdiff_podman_20230906053037.pdf

