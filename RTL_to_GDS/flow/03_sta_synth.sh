#!/bin/bash
# STEP 3 : Pre-layout STA (OpenSTA)
source "$(dirname "$0")/env.sh"
cd $TOP/flow
sta -no_init -exit 03_sta_synth.tcl 2>&1 | tee $REP/03_sta_synth.rpt
