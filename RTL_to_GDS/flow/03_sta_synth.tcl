# STEP 3 : Pre-layout static timing analysis with OpenSTA  (run: sta 03_sta_synth.tcl)
# Wires are ideal (no layout yet) -> checks the logic depth against the clock.
read_liberty $::env(LIB_TT)
read_verilog $::env(RES)/02_synth/$::env(DESIGN).v
link_design  $::env(DESIGN)
read_sdc     $::env(SDC)

puts "\n===== clock ====="
report_clock_properties
puts "\n===== worst setup path (max delay) ====="
report_checks -path_delay max -fields {slew cap input_pins fanout} -digits 3
puts "\n===== worst hold path (min delay) ====="
report_checks -path_delay min -digits 3
puts "\n===== summary ====="
report_wns
report_tns
report_worst_slack -max
report_worst_slack -min
puts "\n===== design rule checks (slew / cap / fanout) ====="
report_check_types -max_slew -max_capacitance -max_fanout -violators
puts "\n===== power (typical, ideal wires) ====="
report_power
exit
