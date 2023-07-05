#!/bin/bash
source /etc/profile

pushd /opt/src
  make data --always-make
  make all
popd

MYDATE=$(date +%Y%m%d%H%M%S)

OUTDIR="/outputs/${MYDATE}"
mkdir -p "${OUTDIR}/data"

mv /opt/src/opfvta/data/* "${OUTDIR}/data"
mv /opt/src/opfvta/article.pdf "${OUTDIR}"
