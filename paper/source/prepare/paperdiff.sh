#!/usr/bin/env bash

HISTORICAL="neurohost_opfvta.pdf"

if [[ ! -f  ${HISTORICAL} ]]; then
	wget https://articles.chymera.eu/${HISTORICAL}
fi

REEXECUTION1="typhon_opfvta.pdf"
if [[ ! -f  ${REEXECUTION1} ]]; then
	wget https://articles.chymera.eu/${REEXECUTION1}
fi

echo "diff-pdf --output-diff=comparison.pdf ${HISTORICAL} ${REEXECUTION1}"

# Command returns error code 1 if the pages are different, which makes sense, except it's the opposite of what we're looking for here.
diff-pdf -v ${HISTORICAL} ${REEXECUTION1} > ../data/paperdiff.log || exit 0
