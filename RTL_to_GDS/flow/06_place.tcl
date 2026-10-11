# STEP 6 : Placement with OpenROAD (global placement -> IO pins -> repair -> detailed)
source $::env(TOP)/flow/or_common.tcl
load_step 05_pdn

# 1. first global placement without IO pins (gives cells a rough position)
global_placement -skip_io -density 0.55

# 2. place IO pins on the die edge close to the cells they connect to
#    horizontal pins on met3, vertical pins on met2
place_pins -hor_layers met3 -ver_layers met2 -corner_avoidance 10 -min_distance 2

# 3. real global placement (timing driven: critical nets kept short)
global_placement -density 0.55 -timing_driven

# 4. electrical repair: buffer IO ports, fix slew / cap / fanout
estimate_parasitics -placement
timing_summary "AFTER GLOBAL PLACEMENT (before repair)"
#    delay cells only for hold fixing later (step 7), not for slew/fanout repair
set_dont_use [get_lib_cells {*/sky130_fd_sc_hd__clkdlybuf* */sky130_fd_sc_hd__dlygate* */sky130_fd_sc_hd__dlymetal*}]
buffer_ports -buffer_cell sky130_fd_sc_hd__buf_4
repair_design -slew_margin 20 -cap_margin 20
repair_tie_fanout -separation 5 sky130_fd_sc_hd__conb_1/HI
repair_tie_fanout -separation 5 sky130_fd_sc_hd__conb_1/LO

# 5. detailed placement: snap every cell onto a legal site, no overlaps
detailed_placement
optimize_mirroring
check_placement -verbose

estimate_parasitics -placement
timing_summary "AFTER PLACEMENT + REPAIR"

write_db  $RES/06_place.odb
write_def $RES/06_place.def
