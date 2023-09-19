#!/usr/bin/env bash

# We can't have `set -eu` since `diff-pdf` returns a non-zero output code for differing PDFs
set -eu -o pipefail

PODMAN_LAST_REEXECUTIONS=($(ls ../../../outputs/podman_*/article.pdf | tail -2))
SINGULARITY_LAST_REEXECUTIONS=($(ls ../../../outputs/singularity_*/article.pdf | tail -2))


for i in "${PODMAN_LAST_REEXECUTIONS[@]}"; do
	echo "GENERATING DIFF FOR EXECUTION in ${i}:"
	this_execution=$(echo ${i} | grep -Po '.*outputs/\K[^/]*')
	diff-pdf --output-diff="../data/paperdiff_${this_execution}.pdf" -v ../../../outputs/original/article.pdf "${i}" > "../data/paperdiff_${this_execution}.log" || { echo "Handling non-zero exit code (${?}) for differing documents."; }
done

for i in "${SINGULARITY_LAST_REEXECUTIONS[@]}"; do
	echo "GENERATING DIFF FOR EXECUTION in ${i}:"
	this_execution=$(echo ${i} | grep -Po '.*outputs/\K[^/]*')
	diff-pdf --output-diff="../data/paperdiff_${this_execution}.pdf" -v ../../../outputs/original/article.pdf "${i}" > "../data/paperdiff_${this_execution}.log" || { echo "Handling non-zero exit code (${?}) for differing documents."; }

done

