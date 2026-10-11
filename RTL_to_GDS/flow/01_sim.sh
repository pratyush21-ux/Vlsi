#!/bin/bash
# STEP 1 : RTL simulation with Icarus Verilog
source "$(dirname "$0")/env.sh"
set -e
mkdir -p $TOP/sim && cd $TOP/sim
echo "### iverilog: compiling RTL + testbench"
iverilog -g2012 -Wall -o cpu_tb.vvp $RTL $TOP/tb/simple_cpu_v4_tb.v
echo "### vvp: running simulation"
vvp cpu_tb.vvp | tee $REP/01_sim.log
