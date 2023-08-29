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
  make data --always-make
  # This would build the original article, not our article
  make article.pdf
popd

mkdir -p "${OUTDIR}/data"
mv opfvta/data/* "${OUTDIR}/data"
mv opfvta/article.pdf "${OUTDIR}"
