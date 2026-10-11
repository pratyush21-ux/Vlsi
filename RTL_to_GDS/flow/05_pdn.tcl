# STEP 5 : Power distribution network (PDN) with OpenROAD pdngen
source $::env(TOP)/flow/or_common.tcl
load_step 04_floorplan

# 1. create the power / ground nets (the gate netlist has none)
set block [ord::get_db_block]
foreach {name type} {VPWR POWER VGND GROUND} {
    if {[$block findNet $name] == "NULL"} {
        set net [odb::dbNet_create $block $name]
        $net setSpecial
        $net setSigType $type
    }
}

# 2. connect every cell's supply pins to them
#    VPWR/VGND = cell supply, VPB/VNB = n-well / p-substrate bias
add_global_connection -net VPWR -pin_pattern {^VPWR$} -power
add_global_connection -net VPWR -pin_pattern {^VPB$}  -power
add_global_connection -net VGND -pin_pattern {^VGND$} -ground
add_global_connection -net VGND -pin_pattern {^VNB$}  -ground
global_connect

# 3. grid definition (PDK values from libs.tech/librelane/config.tcl)
set_voltage_domain -name CORE -power VPWR -ground VGND
define_pdn_grid -name core -voltage_domains CORE -pins {met4 met5}

#   ring around the core on met4 (vertical) / met5 (horizontal)
add_pdn_ring -grid core -layers {met4 met5} -widths 1.6 -spacings 1.7 -core_offsets 6
#   met1 rails on top of every std-cell row (follow the cell VPWR/VGND pins)
add_pdn_stripe -grid core -layer met1 -width 0.48 -followpins
#   vertical met4 straps and horizontal met5 straps every 50 um
add_pdn_stripe -grid core -layer met4 -width 1.6 -spacing 1.7 -pitch 50 -offset 16.32 -extend_to_core_ring
add_pdn_stripe -grid core -layer met5 -width 1.6 -spacing 1.7 -pitch 50 -offset 16.65 -extend_to_core_ring
#   vias between the layers
add_pdn_connect -grid core -layers {met1 met4}
add_pdn_connect -grid core -layers {met4 met5}

pdngen

# 4. checks: every cell supply pin must be connected to the grid
puts "\n================ PDN CHECK ================"
check_power_grid -net VPWR
check_power_grid -net VGND
puts "  VPWR / VGND grid connected (no unconnected-node errors above = PASS)"

write_db  $RES/05_pdn.odb
write_def $RES/05_pdn.def
