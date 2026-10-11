#!/bin/bash
# run_or.sh <step> : run one OpenROAD step script, e.g.  bash flow/run_or.sh 04_floorplan
source "$(dirname "$0")/env.sh"
cd $TOP/flow
echo "### openroad $1.tcl   (log: reports/$1.log)"
openroad -no_init -exit $1.tcl 2>&1 | tee $REP/$1.log
