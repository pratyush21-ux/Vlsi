# STEP 10 : GDSII stream-out with Magic  (DEF + std-cell GDS -> final GDS)
# run: magic -dnull -noconsole -rcfile sky130A.magicrc 10_gds.tcl
set D   $::env(DESIGN)
set RES $::env(RES)
drc off

# 1. load the real std-cell layouts (transistor level) from the PDK GDS,
#    read-only: they are copied unchanged into the final GDS
gds readonly true
gds rescale false
gds read $::env(CELL_GDS)

# 2. technology LEF: defines the fixed vias (L1M1_PR, M1M2_PR, ...) the router used
lef read $::env(TECH_LEF)

# 3. read the routed design: cell placements + wires + vias + pins
def read $RES/08_route.def
load $D
select top cell
puts "### top cell $D loaded, bounding box (lambda): [box values]"

# 4. write the full chip GDS
file mkdir $RES/10_gds
gds write $RES/10_gds/$D.gds
puts "### GDS written: results/10_gds/$D.gds"
quit -noprompt
