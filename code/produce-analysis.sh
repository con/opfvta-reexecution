#!/bin/bash
source /etc/profile

pushd /opt/src/opfvta
  make data --always-make
  make all
popd
# mv /opfvta/data/* /outputs
