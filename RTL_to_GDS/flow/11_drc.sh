#!/bin/bash
# STEP 11 : DRC (Magic)
source "$(dirname "$0")/env.sh"
cd $TOP/flow
magic -dnull -noconsole -rcfile $PDKPATH/libs.tech/magic/sky130A.magicrc 11_drc.tcl 2>&1 | tee $REP/11_drc.log | grep -E "###|rror"
cat $REP/11_drc.rpt | head -40
