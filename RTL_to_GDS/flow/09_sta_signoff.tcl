# STEP 9b : Sign-off static timing analysis with OpenSTA (real routed RC from SPEF)
set RES $::env(RES)
set D   $::env(DESIGN)

# 1. three corners: liberty (PVT) + matching extracted RC
define_corners ss tt ff
read_liberty -corner ss $::env(LIB_SS)
read_liberty -corner tt $::env(LIB_TT)
read_liberty -corner ff $::env(LIB_FF)

# 2. routed netlist + constraints
read_verilog $RES/08_route.v
link_design  $D
read_sdc     $::env(SDC)
set_propagated_clock [all_clocks]

# 3. parasitics: slow corner with max RC, fast corner with min RC
read_spef -corner ss $RES/09_$D.max.spef
read_spef -corner tt $RES/09_$D.nom.spef
read_spef -corner ff $RES/09_$D.min.spef

# 4. reports
puts "\n===== worst SETUP path (ss corner, max RC) ====="
report_checks -path_delay max -scenes ss -fields {slew cap fanout} -digits 3
puts "\n===== worst HOLD path (ff corner, min RC) ====="
report_checks -path_delay min -scenes ff -digits 3

puts "\n===== clock skew ====="
report_clock_skew -setup -scenes ss
report_clock_skew -hold  -scenes ff

puts "\n===== SIGN-OFF SUMMARY ====="
foreach c {ss tt ff} {
    set s [sta::find_scene $c]
    puts [format "  corner %-2s  setup WNS %8.3f ns   hold WNS %8.3f ns" $c \
          [expr 1e9*[sta::worst_slack_scene $s max]] [expr 1e9*[sta::worst_slack_scene $s min]]]
}
report_tns
report_tns -min
puts "\n===== design rule checks (all corners) ====="
report_check_types -max_slew -max_capacitance -max_fanout -violators
report_check_types -max_slew -max_capacitance -max_fanout
puts "\n===== power (tt corner, 50 MHz, default activity) ====="
report_power -scene tt
exit
