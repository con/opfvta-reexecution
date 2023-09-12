#!/usr/bin/env bash

set -eu -o pipefail

cd "$(dirname "$0")"

OUTPUT_PATH=../../../outputs
DATA_PATH=../data

LAST_REEXECUTION=$(ls ${OUTPUT_PATH}/ | head -n -1 | tail -1)

# Command returns error code 1 if the pages are different, which makes sense, except it's the opposite of what we're looking for here.
diff-pdf --output-diff="${DATA_PATH}/paperdiff.pdf" -v ${OUTPUT_PATH}/original/article.pdf "${OUTPUT_PATH}/${LAST_REEXECUTION}/article.pdf" > ${DATA_PATH}/paperdiff.log || exit 0
