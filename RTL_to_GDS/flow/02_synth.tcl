# STEP 2 : Logic synthesis with Yosys   (run: yosys -c 02_synth.tcl)
yosys -import
set LIB $::env(LIB_TT)

# 1. read cell library (as black boxes, so Yosys knows the pin directions)
read_liberty -lib $LIB
# 2. read RTL and set the top module
read_verilog -sv $::env(RTL)
hierarchy -check -top $::env(DESIGN)
# 3. generic synthesis: RTL -> gates + flip-flops, flatten hierarchy
synth -top $::env(DESIGN) -flatten
# cells kept for physical design only (PDK list libs.tech/librelane/.../synth_excluded.cells):
# clock buffers, delay cells, tap/decap/fill, diode, power-gating, probe, scan FFs
set DONT_USE {}
foreach c {clkbuf* clkinv* clkdlybuf* dlygate* dlymetal* tap* decap* fill* diode*
           lpflow_* macro_sparecell probe* s*} {
    lappend DONT_USE -dont_use sky130_fd_sc_hd__$c
}
# 4. map flip-flops to sky130 FF cells
dfflibmap -liberty $LIB {*}$DONT_USE
# 5. map logic to sky130 cells with ABC, 20 ns target
abc -D 20000 -liberty $LIB {*}$DONT_USE
# 6. clean-up for physical design
setundef -zero
splitnets
opt_clean -purge
hilomap -singleton -hicell sky130_fd_sc_hd__conb_1 HI -locell sky130_fd_sc_hd__conb_1 LO
insbuf -buf sky130_fd_sc_hd__buf_2 A X   ;# replace "assign a = b" by real buffers
# 7. checks, reports, netlist
check
tee -o $::env(REP)/02_synth_stat.rpt stat -liberty $LIB
file mkdir $::env(RES)/02_synth
write_verilog -noattr -noexpr -nohex -nodec $::env(RES)/02_synth/$::env(DESIGN).v
