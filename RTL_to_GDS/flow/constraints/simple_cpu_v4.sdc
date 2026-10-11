# simple_cpu_v4.sdc - timing constraints
# 50 MHz clock
create_clock -name clk -period 20.0 [get_ports clk]
set_clock_uncertainty 0.25 [get_clocks clk]
set_clock_transition  0.15 [get_clocks clk]

# external memory / IO: assume 20 % of the period is used outside the chip
set non_clk_inputs [lsearch -inline -all -not -exact [all_inputs] [get_ports clk]]
set_input_delay  4.0 -clock clk $non_clk_inputs
set_output_delay 4.0 -clock clk [all_outputs]

# drive / load of the chip pins
set_driving_cell -lib_cell sky130_fd_sc_hd__inv_2 -pin Y $non_clk_inputs
set_load 0.033 [all_outputs]

# design rules (same as LibreLane defaults)
set_max_transition 0.75 [current_design]
set_max_fanout     10   [current_design]
