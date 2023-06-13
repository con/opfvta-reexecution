#!/usr/bin/env bash

wget https://articles.chymera.eu/neurohost_opfvta.pdf
wget https://articles.chymera.eu/typhon_opfvta.pdf
diff-pdf --output-diff=comparison.pdf neurohost_opfvta.pdf typhon_opfvta.pdf
