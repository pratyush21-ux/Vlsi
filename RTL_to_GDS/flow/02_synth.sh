#!/bin/bash
# STEP 2 : Logic synthesis (Yosys)
source "$(dirname "$0")/env.sh"
set -e
cd $TOP/flow
yosys -c 02_synth.tcl -l $REP/02_synth.log | grep -E "Executing|problems|Chip area|cells$" || true
echo "### netlist : results/02_synth/$DESIGN.v"
tail -n 55 $REP/02_synth_stat.rpt
