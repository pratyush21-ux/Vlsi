# STEP 9a : Parasitic (RC) extraction of the routed layout with OpenRCX
source $::env(TOP)/flow/or_common.tcl
read_db $RES/08_route.odb

# PDK extraction rules (calibrated R and C per layer / spacing)
set RULES $::env(PDKPATH)/libs.tech/librelane
foreach c {min nom max} {
    puts "\n### extracting $c RC corner"
    extract_parasitics -ext_model_file $RULES/rules.openrcx.sky130A.$c.calibre
    write_spef $RES/09_$DESIGN.$c.spef
}
