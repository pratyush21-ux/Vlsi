# STEP 8b : ECO fix - connect the supply pins of all cells inserted after the PDN step
# (same command now also at the end of 08_route.tcl; this applies it without re-routing)
source $::env(TOP)/flow/or_common.tcl
read_db $RES/08_route.odb

set block [ord::get_db_block]
proc count_unconnected {block} {
    set n 0
    foreach inst [$block getInsts] {
        foreach it [$inst getITerms] {
            set t [[$it getMTerm] getSigType]
            if {($t == "POWER" || $t == "GROUND") && [$it getNet] == "NULL"} { incr n }
        }
    }
    return $n
}
puts "### supply pins NOT connected before: [count_unconnected $block]"
global_connect
puts "### supply pins NOT connected after : [count_unconnected $block]"

write_db      $RES/08_route.odb
write_def     $RES/08_route.def
write_verilog $RES/08_route.v
write_verilog -include_pwr_gnd $RES/08_route_pwr.v
