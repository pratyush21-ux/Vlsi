# STEP 12b : LVS with Netgen  (layout netlist  vs.  routed gate netlist)
set D   $::env(DESIGN)
set RES $::env(RES)

# circuit 1 = what is really drawn in the GDS (extracted by Magic)
set layout [readnet spice $RES/12_lvs/$D.spice]
# circuit 2 = the netlist we intended: std-cell SPICE models + routed Verilog with VPWR/VGND
set source [readnet spice $::env(CELL_SPICE)]
readnet verilog $RES/08_route_pwr.v $source

lvs "$layout $D" "$source $D" $::env(PDKPATH)/libs.tech/netgen/sky130A_setup.tcl \
    $::env(REP)/12_lvs.rpt -json
