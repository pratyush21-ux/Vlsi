#!/bin/bash
# STEP 12 : LVS = Magic extraction + Netgen compare
source "$(dirname "$0")/env.sh"
cd $TOP/flow
echo "### 12a magic: extract layout netlist from GDS"
magic -dnull -noconsole -rcfile $PDKPATH/libs.tech/magic/sky130A.magicrc 12_extract.tcl 2>&1 | tee $REP/12_extract.log | grep -E "###|rror"
echo "### 12b netgen: compare layout vs netlist"
netgen -batch source 12_lvs_netgen.tcl 2>&1 | tee $REP/12_lvs.log | tail -25
echo "### final result:"
grep -E "Circuits match|Netlists do not match|Final result" $REP/12_lvs.rpt | tail -3
