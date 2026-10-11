# STEP 11 : Design Rule Check of the final GDS with Magic (full sky130 rule deck)
set D   $::env(DESIGN)
set RES $::env(RES)
set REP $::env(REP)

gds read $RES/10_gds/$D.gds
load $D
select top cell
drc euclidean on
drc style drc(full)
puts "### running full DRC on $D ..."
drc check
drc catchup

# collect every violation: rule text -> list of boxes
set why [drc listall why]
set total 0
set fp [open $REP/11_drc.rpt w]
puts $fp "Magic DRC report for $D  (style drc(full))"
foreach {rule boxes} $why {
    set n [llength $boxes]
    incr total $n
    puts $fp "\n$rule  : $n"
    foreach b $boxes { puts $fp "    $b" }
}
puts $fp "\nTOTAL DRC VIOLATIONS: $total"
close $fp
puts "### TOTAL DRC VIOLATIONS: $total   (report: reports/11_drc.rpt)"
quit -noprompt
