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
diff-pdf -v ${HISTORICAL} ${REEXECUTION1} 2> ../data/paperdiff.log
