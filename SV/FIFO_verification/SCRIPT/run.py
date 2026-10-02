#!/usr/bin/env python3
"""Compile FIFO framework and open QuestaSim GUI with coverage.

Usage:
    python run.py                  # random test
    python run.py --test full      # random|write|read|order|empty|full|overflow
    python run.py --num_txn 500    # set number of transactions (random, write tests)
    python run.py --clean          # delete generated files
"""
import argparse
import shutil
import subprocess
import sys
from pathlib import Path

SCRIPT_DIR = Path(__file__).resolve().parent
WORK_LIB = "work"
TOP_MODULE = "FIFO_TOP"
UCDB = "fifo_cov.ucdb"

RTL_FILES = ["Fifo_rtl.v"]
SV_FILES = [
    "FIFO_INTERFACE.sv",
    "FIFO_ASSERTIONS.sv",
    "FIFO_TOP.sv",  # includes all class files
]

TESTS = ["random", "write", "read", "order", "empty", "full", "overflow"]


def run(cmd):
    print("\n>>", " ".join(cmd))
    try:
        r = subprocess.run(cmd, cwd=SCRIPT_DIR)
    except FileNotFoundError:
        sys.exit(f"ERROR: '{cmd[0]}' not found. Add QuestaSim bin dir to PATH.")
    return r.returncode


def clean():
    for name in [WORK_LIB, "transcript", "vsim.wlf", "modelsim.ini", UCDB, "covhtmlreport"]:
        p = SCRIPT_DIR / name
        if p.is_dir():
            shutil.rmtree(p)
        elif p.exists():
            p.unlink()
    print("Clean done.")


def compile_all():
    work = SCRIPT_DIR / WORK_LIB
    if work.exists():
        shutil.rmtree(work)
    if run(["vlib", WORK_LIB]) != 0:
        sys.exit("vlib failed")
    if run(["vlog", "-work", WORK_LIB, "+cover=bcefst"] + RTL_FILES) != 0:
        sys.exit("RTL compile failed")
    if run(["vlog", "-sv", "-work", WORK_LIB, "+incdir+.", "+cover=bcefst"] + SV_FILES) != 0:
        sys.exit("SV compile failed")


def open_questa(test, num_txn):
    do_cmds = (
        "add wave -r /*; "
        "run -all; "
        f"coverage save {UCDB}; "
        "wave zoom full"
    )
    cmd = [
        "vsim",
        "-coverage",
        "-voptargs=+acc",
        "-onfinish", "stop",   # keep GUI open after $finish
        f"{WORK_LIB}.{TOP_MODULE}",
        f"+TESTNAME={test}",
        f"+NUMTXN={num_txn}",
        "-do", do_cmds,
    ]
    sys.exit(run(cmd))


def main():
    ap = argparse.ArgumentParser()
    ap.add_argument("--test", default="random", choices=TESTS)
    ap.add_argument("--num_txn", type=int, default=200,
                    help="number of transactions (default 200)")
    ap.add_argument("--clean", action="store_true")
    args = ap.parse_args()

    if args.clean:
        clean()
        return
    compile_all()
    open_questa(args.test, args.num_txn)


if __name__ == "__main__":
    main()