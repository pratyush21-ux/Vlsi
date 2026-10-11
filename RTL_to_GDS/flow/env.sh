# env.sh - common paths for the manual RTL-to-GDS flow (sourced by every step)
export DESIGN=simple_cpu_v4
export TOP=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)   # project root = folder above flow/
export PDK=sky130A
export PDKPATH=/foss/pdks/sky130A
export SCL=$PDKPATH/libs.ref/sky130_fd_sc_hd

export LIB_TT=$SCL/lib/sky130_fd_sc_hd__tt_025C_1v80.lib
export LIB_SS=$SCL/lib/sky130_fd_sc_hd__ss_100C_1v60.lib
export LIB_FF=$SCL/lib/sky130_fd_sc_hd__ff_n40C_1v95.lib
export TECH_LEF=$SCL/techlef/sky130_fd_sc_hd__nom.tlef
export CELL_LEF=$SCL/lef/sky130_fd_sc_hd.lef
export CELL_GDS=$SCL/gds/sky130_fd_sc_hd.gds
export CELL_SPICE=$SCL/spice/sky130_fd_sc_hd.spice

export RTL=$TOP/RTL/Simplecpu.v
export SDC=$TOP/flow/constraints/$DESIGN.sdc
export RES=$TOP/results          # design databases per step
export REP=$TOP/reports          # reports / logs per step
mkdir -p $RES $REP
