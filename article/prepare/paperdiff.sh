#!/usr/bin/env bash

cd "$(dirname "$0")"

# We can't have `set -eu` since `diff-pdf` returns a non-zero output code for differing PDFs
set -eu -o pipefail

OUTPUT_PATH="../../outputs"
DATA_PATH="../data"

PODMAN_LAST_REEXECUTIONS=($(ls ${OUTPUT_PATH}/podman_*/article.pdf | tail -4))
SINGULARITY_LAST_REEXECUTIONS=($(ls ${OUTPUT_PATH}/singularity_*/article.pdf | tail -4))

# Add execution selected for showcase figures
# Avoids https://github.com/con/opfvta-replication-2023/issues/41
SINGULARITY_LAST_REEXECUTIONS+=("${OUTPUT_PATH}/paperdiff_singularity_20230908122618.pdf")

# Deduplicate array
IFS=" " read -r -a SINGULARITY_LAST_REEXECUTIONS <<< "$(tr ' ' '\n' <<< "${SINGULARITY_LAST_REEXECUTIONS[@]}" | sort -u | tr '\n' ' ')"

for i in "${PODMAN_LAST_REEXECUTIONS[@]}"; do
	echo "GENERATING DIFF FOR EXECUTION in ${i}:"
	this_execution=$(echo ${i} | grep -Po '.*outputs/\K[^/]*')
	diff-pdf --output-diff="${DATA_PATH}/paperdiff_${this_execution}.pdf" -v ${OUTPUT_PATH}/original/article.pdf "${i}" > "${DATA_PATH}/paperdiff_${this_execution}.log" || { echo "Handling non-zero exit code (${?}) for differing documents."; }
done

for i in "${SINGULARITY_LAST_REEXECUTIONS[@]}"; do
	echo "GENERATING DIFF FOR EXECUTION in ${i}:"
	this_execution=$(echo ${i} | grep -Po '.*outputs/\K[^/]*')
	diff-pdf --output-diff="${DATA_PATH}/paperdiff_${this_execution}.pdf" -v ${OUTPUT_PATH}/original/article.pdf "${i}" > "${DATA_PATH}/paperdiff_${this_execution}.log" || { echo "Handling non-zero exit code (${?}) for differing documents."; }

done

