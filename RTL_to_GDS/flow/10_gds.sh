#!/bin/bash
# STEP 10 : GDS stream-out (Magic)
source "$(dirname "$0")/env.sh"
cd $TOP/flow
magic -dnull -noconsole -rcfile $PDKPATH/libs.tech/magic/sky130A.magicrc 10_gds.tcl 2>&1 | tee $REP/10_gds.log
ls -la $RES/10_gds/
