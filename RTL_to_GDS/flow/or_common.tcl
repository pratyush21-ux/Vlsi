# or_common.tcl - loaded at the start of every OpenROAD step
set DESIGN $::env(DESIGN)
set RES    $::env(RES)
set REP    $::env(REP)
set_thread_count [exec nproc]

# technology + cell abstracts (layers, sites, cell sizes and pins)
read_lef $::env(TECH_LEF)
read_lef $::env(CELL_LEF)

# timing libraries for 3 PVT corners (multi-corner analysis / repair)
define_corners ss tt ff
read_liberty -corner ss $::env(LIB_SS)     ;# slow : 100C 1.60V -> setup critical
read_liberty -corner tt $::env(LIB_TT)     ;# typ  :  25C 1.80V
read_liberty -corner ff $::env(LIB_FF)     ;# fast : -40C 1.95V -> hold critical

# cells the tools must never insert (PDK pnr_excluded.cells)
proc set_pnr_dont_use {} {
    set_dont_use [get_lib_cells {*/sky130_fd_sc_hd__lpflow_* */sky130_fd_sc_hd__probe*}]
}

# wire RC used before real extraction (values from the tech LEF)
proc set_rc {} {
    set_wire_rc -signal -layer met2
    set_wire_rc -clock  -layer met5
}

# load the database written by a previous step
proc load_step {name} {
    read_db $::env(RES)/$name.odb
    read_sdc $::env(SDC)
    set_pnr_dont_use
    set_rc
}

proc timing_summary {title} {
    puts "\n================ $title ================"
    foreach c {ss tt ff} {
        puts [format "  corner %-2s  setup WNS %8.3f ns   hold WNS %8.3f ns" $c \
              [expr 1e9*[sta::worst_slack_scene [sta::find_scene $c] max]] \
              [expr 1e9*[sta::worst_slack_scene [sta::find_scene $c] min]]]
    }
    report_tns
    report_check_types -max_slew -max_capacitance -max_fanout
    report_design_area
}
