# STEP 4 : Floorplan with OpenROAD
source $::env(TOP)/flow/or_common.tcl

read_verilog $RES/02_synth/$DESIGN.v
link_design  $DESIGN
read_sdc     $::env(SDC)

# 1. die / core size: cells fill 40 % of the core, square, 15 um margin
#    (margin leaves room for the power ring of step 5)
initialize_floorplan -utilization 40 -aspect_ratio 1.0 -core_space 15 -site unithd

# 2. routing tracks for every metal layer (PDK tracks.info: offset / pitch in um)
make_tracks li1  -x_offset 0.23 -x_pitch 0.46 -y_offset 0.17 -y_pitch 0.34
make_tracks met1 -x_offset 0.17 -x_pitch 0.34 -y_offset 0.17 -y_pitch 0.34
make_tracks met2 -x_offset 0.23 -x_pitch 0.46 -y_offset 0.23 -y_pitch 0.46
make_tracks met3 -x_offset 0.34 -x_pitch 0.68 -y_offset 0.34 -y_pitch 0.68
make_tracks met4 -x_offset 0.46 -x_pitch 0.92 -y_offset 0.46 -y_pitch 0.92
make_tracks met5 -x_offset 1.70 -x_pitch 3.40 -y_offset 1.70 -y_pitch 3.40

# 3. well-tap cells every 13 um (latch-up rule) + endcaps at row ends
tapcell -distance 13 \
        -tapcell_master sky130_fd_sc_hd__tapvpwrvgnd_1 \
        -endcap_master  sky130_fd_sc_hd__decap_3

# 4. reports
puts "\n================ FLOORPLAN ================"
set block [ord::get_db_block]
set die  [$block getDieArea]
set core [$block getCoreArea]
set dbu  [$block getDbUnitsPerMicron]
puts [format "  die  : %.2f x %.2f um" [expr [$die dx]*1.0/$dbu]  [expr [$die dy]*1.0/$dbu]]
puts [format "  core : %.2f x %.2f um  (origin %.2f, %.2f)" [expr [$core dx]*1.0/$dbu] \
      [expr [$core dy]*1.0/$dbu] [expr [$core xMin]*1.0/$dbu] [expr [$core yMin]*1.0/$dbu]]
puts "  rows : [llength [$block getRows]]"
puts "  tap/endcap cells : [llength [get_cells -filter {ref_name =~ *tap* || ref_name =~ *decap_3}]]"
report_design_area

write_db  $RES/04_floorplan.odb
write_def $RES/04_floorplan.def
