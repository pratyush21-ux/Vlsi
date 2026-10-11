# STEP 8 : Routing with OpenROAD (FastRoute global + TritonRoute detailed)
source $::env(TOP)/flow/or_common.tcl
load_step 07_cts
set_propagated_clock [all_clocks]

# 1. routing layers: signals and clock on met1..met5 (li1 only inside cells)
set_routing_layers -signal met1-met5 -clock met1-met5

# 2. GLOBAL ROUTING: plan which routing tiles (GCells) every net passes
global_route -guide_file $RES/08_route.guide -congestion_iterations 50 -verbose

# 3. repair AFTER global routing (real wire lengths/layers known now).
#    This is the step LibreLane skips by default -> slew violations in run 1.
estimate_parasitics -global_routing
timing_summary "AFTER GLOBAL ROUTE (before repair)"
global_route -start_incremental
#    slew margin 40 %: first sign-off (step 9) showed the global-route RC
#    estimate is ~40 % optimistic vs. real extraction (0.67 ns -> 0.96 ns)
repair_design -slew_margin 40 -cap_margin 20
repair_timing -setup -setup_margin 0.1
repair_timing -hold  -hold_margin 0.05
detailed_placement
global_route -end_incremental -guide_file $RES/08_route.guide

# 4. antenna check / repair (long wires charge gates during fabrication)
repair_antennas sky130_fd_sc_hd__diode_2 -iterations 3
check_placement

estimate_parasitics -global_routing
timing_summary "AFTER GLOBAL ROUTE + REPAIR"

# 5. DETAILED ROUTING: real metal shapes + vias, must end with 0 DRC
#    (layers come from set_routing_layers above)
detailed_route -output_drc $REP/08_route_drc.rpt -droute_end_iter 64 -verbose 1

# 6. fill empty sites: decap cells (supply decoupling) and fill cells
#    (keep n-well / implant layers continuous)
filler_placement {sky130_fd_sc_hd__decap_12 sky130_fd_sc_hd__decap_8 sky130_fd_sc_hd__decap_6
                  sky130_fd_sc_hd__decap_4  sky130_fd_sc_hd__decap_3 sky130_fd_sc_hd__fill_2
                  sky130_fd_sc_hd__fill_1}
check_placement

# 7. connect VPWR/VGND/VPB/VNB of every cell added after step 5
#    (buffers, clock buffers, hold cells, fillers) - needed for LVS
global_connect

puts "\n================ ROUTING CHECKS ================"
check_antennas -report_file $REP/08_route_antenna.rpt
puts "  routing DRC report: reports/08_route_drc.rpt"

write_db      $RES/08_route.odb
write_def     $RES/08_route.def
write_verilog $RES/08_route.v                         ;# for STA
write_verilog -include_pwr_gnd $RES/08_route_pwr.v    ;# for LVS
