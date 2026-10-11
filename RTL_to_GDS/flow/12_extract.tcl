# STEP 12a : extract a SPICE netlist from the final GDS with Magic (for LVS)
set D   $::env(DESIGN)
set RES $::env(RES)
file mkdir $RES/12_lvs

gds read $RES/10_gds/$D.gds
load $D
select top cell
extract path $RES/12_lvs
extract do local
extract all
ext2spice lvs
ext2spice -o $RES/12_lvs/$D.spice $D
puts "### layout netlist: results/12_lvs/$D.spice"
quit -noprompt
