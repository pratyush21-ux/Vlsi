#!/bin/bash
# STEP 13 : GDS -> PNG pictures (KLayout batch)
source "$(dirname "$0")/env.sh"
cd $TOP/flow
QT_QPA_PLATFORM=offscreen klayout -b -r 13_render.py 2>&1 | tee $REP/13_render.log
ls -la $RES/13_images/
