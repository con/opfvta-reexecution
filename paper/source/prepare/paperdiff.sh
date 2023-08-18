#!/usr/bin/env bash

LAST_REEXECUTION=$(ls ../../outputs/ | head -n+2 | tail -1)

# Command returns error code 1 if the pages are different, which makes sense, except it's the opposite of what we're looking for here.
diff-pdf --output-diff="../data/paperdiff.pdf" -v ../../outputs/original/article.pdf "../../outputs/${LAST_REEXECUTION}/article.pdf" > ../data/paperdiff.log || exit 0
