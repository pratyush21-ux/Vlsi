# STEP 7 : Clock tree synthesis (OpenROAD TritonCTS) + timing repair
source $::env(TOP)/flow/or_common.tcl
load_step 06_place

# 1. build the clock tree: H-tree of clock buffers from the clk pin to all 322 FFs
#    max 10 FFs per leaf buffer, leaves at most 50 um wide
clock_tree_synthesis -root_buf sky130_fd_sc_hd__clkbuf_16 \
    -buf_list {sky130_fd_sc_hd__clkbuf_2 sky130_fd_sc_hd__clkbuf_4 sky130_fd_sc_hd__clkbuf_8} \
    -sink_clustering_enable -sink_clustering_size 10 -sink_clustering_max_diameter 50

# 2. from now on use the REAL clock arrival times (not ideal)
set_propagated_clock [all_clocks]
estimate_parasitics -placement
repair_clock_nets
detailed_placement                    ;# legalise the new clock buffers

puts "\n================ CLOCK TREE ================"
report_cts
report_clock_skew
estimate_parasitics -placement
timing_summary "AFTER CTS (before timing repair)"

# 3. timing repair with the real clock: setup first, then hold
#    hold margin 0.1 ns gives safety for later routing
repair_timing -setup -setup_margin 0.2
repair_timing -hold  -hold_margin 0.1
detailed_placement
check_placement -verbose

estimate_parasitics -placement
timing_summary "AFTER CTS + TIMING REPAIR"
report_checks -path_delay min -scenes ff -digits 3

write_db  $RES/07_cts.odb
write_def $RES/07_cts.def
