#!/bin/bash
# STEP 14 : stage-by-stage layout pictures (KLayout batch, DEF + LEF)
source "$(dirname "$0")/env.sh"
cd $TOP/flow
QT_QPA_PLATFORM=offscreen klayout -b -r 14_stage_images.py 2>&1 | tee $REP/14_stage_images.log
ls -la $RES/13_images/
