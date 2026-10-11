#!/bin/bash
# STEP 9 : RC extraction (OpenROAD/OpenRCX) + sign-off STA (OpenSTA)
source "$(dirname "$0")/env.sh"
cd $TOP/flow
echo "### 9a  openroad 09_rcx.tcl : extract parasitics -> SPEF"
openroad -no_init -exit 09_rcx.tcl 2>&1 | tee $REP/09_rcx.log | grep -E "###|RCX-0(0[0-9]|4[0-9])|Error|ERROR"
ls -la $RES/*.spef
echo "### 9b  sta 09_sta_signoff.tcl : sign-off timing with SPEF"
sta -no_init -no_splash -exit 09_sta_signoff.tcl 2>&1 | tee $REP/09_sta_signoff.rpt
