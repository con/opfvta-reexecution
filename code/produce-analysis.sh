#!/bin/bash

set -eu

# Optionally accept the first argument as an execution descriptor
INFRASTRUCTURE=${1}
[[ ! -z "$INFRASTRUCTURE" ]] && INFRASTRUCTURE+="_"

MYDATE=$(date +%Y%m%d%H%M%S)
OUTDIR="../outputs/${INFRASTRUCTURE}${MYDATE}"

# To ensure that we have all environment variables from neuroscience packages loaded.
# For some reason entering the image we have doesn't load them automagically.
source /etc/profile

cd "$(dirname "$0")"
pushd opfvta
	# We need to clean the code, because we mount the local copy of the repository.
	# Thus, re-execution will be blocked by a pre-existing rubber cache from the previous execution.
	make clean
	make data --always-make
	# This would build the original article, not our article
	make article.pdf
popd

mkdir -p "${OUTDIR}/data"
mv opfvta/data/* "${OUTDIR}/data"
mv opfvta/article.pdf "${OUTDIR}"
