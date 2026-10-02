# Synchronous FIFO Verification in SystemVerilog

A class-based, self-checking SystemVerilog testbench for an 8-bit, 32-entry synchronous FIFO. It includes constrained-random and directed tests, a scoreboard with a reference model, SystemVerilog Assertions (SVA), functional coverage, and a Python script that compiles and runs everything in QuestaSim with coverage enabled.

Author: **Pratyush Kumar Sahu** (Foundation of SystemVerilog course, Maven Silicon)

---

## Table of contents

1. [Overview](#overview)
2. [DUT specification](#dut-specification)
3. [Verification architecture](#verification-architecture)
4. [How the testbench works](#how-the-testbench-works)
5. [Checking strategy](#checking-strategy)
6. [Tests](#tests)
7. [Functional coverage](#functional-coverage)
8. [Repository structure](#repository-structure)
9. [How to run](#how-to-run)
10. [Reading the results](#reading-the-results)
11. [Design notes and limitations](#design-notes-and-limitations)
12. [Acknowledgements and references](#acknowledgements-and-references)

---

## Overview

This project verifies a synchronous FIFO from scratch. It contains:

- the **RTL** of the FIFO (`Fifo_rtl.v`)
- a **layered SystemVerilog testbench** (transaction, generator, driver, monitor, scoreboard, coverage, environment) built without the UVM library, but following a UVM-like structure
- **SVA assertions** bound into the DUT
- **7 tests** selectable from the command line
- a **Python runner** (`run.py`) that compiles with code coverage and opens the QuestaSim GUI
- a **verification plan** (Word document) describing features, checks, tests and coverage goals

## DUT specification

| Parameter | Value |
|---|---|
| Type | Synchronous FIFO, single clock |
| Data width | 8 bits |
| Depth | 32 entries |
| Pointer width | 6 bits (5 address bits + 1 wrap bit) |
| Reset | Active high, asynchronous |
| Inputs | `clk`, `rst`, `wr_en`, `rd_en`, `wdata[7:0]` |
| Outputs | `rdata[7:0]`, `full`, `empty` |

How it behaves:

- A write happens when `wr_en` is high and `full` is low.
- A read happens when `rd_en` is high and `empty` is low. `rdata` is registered, so read data appears on the clock edge after an accepted read.
- `empty` is high when the write and read pointers are equal.
- `full` is high when the lower 5 bits of the pointers match and the wrap bits differ.

## Verification architecture

```
FIFO_TOP
 |-- clk generator
 |-- FIFO_INTERFACE (fif)  <---- pins ---->  DUT: fifo
 |                                              |
 |                                      FIFO_ASSERTIONS (bound with `bind`)
 |
 '-- FIFO_ENVIRONMENT
       |-- FIFO_GENERATOR  --(gen2drv mailbox)-->  FIFO_DRIVER  --> interface --> DUT
       |
       |-- FIFO_MONITOR  <-- samples interface
       |       |--(mon2scb mailbox)--> FIFO_SCOREBOARD  (reference model + checks)
       |       '--(mon2cov mailbox)--> FIFO_COVERAGE    (covergroups)
```

| Component | File | Role |
|---|---|---|
| Interface | `FIFO_INTERFACE.sv` | Groups all DUT signals. Driver clocking block drives on `posedge clk` with a 1 ns output skew. Monitor clocking block samples on `negedge clk`. |
| Transaction | `FIFO_TRANSACTION.sv` | One bus cycle: random `wr_en`, `rd_en`, `wdata` plus observed `rdata`, `full`, `empty`. Constraints force at least one operation per cycle and bias writes to 70 percent. Simultaneous read and write is allowed. |
| Generator | `FIFO_GENERATOR.sv` | Produces stimulus for the selected test and sends it to the driver through a mailbox. |
| Driver | `FIFO_DRIVER.sv` | Applies reset (2 cycles), idles the bus, then drives one transaction per clock. |
| Monitor | `FIFO_MONITOR.sv` | After reset, samples inputs and outputs every cycle and forwards copies to scoreboard and coverage. |
| Scoreboard | `FIFO_SCOREBOARD.sv` | Reference FIFO (SystemVerilog queue). Checks read data, `empty` and `full` every cycle. Prints a PASS or FAIL summary. |
| Coverage | `FIFO_COVERAGE.sv` | Functional covergroups sampled each monitored cycle. |
| Assertions | `FIFO_ASSERTIONS.sv` | SVA properties, bound into the DUT. |
| Environment | `FIFO_ENVIRONMENT.sv` | Builds the components, runs reset, runs all components, drains, and prints the report. |
| Top | `FIFO_TOP.sv` | Clock, DUT, `bind`, command-line plusargs, simulation timeout. |

## How the testbench works

1. `FIFO_TOP` reads the plusargs `TESTNAME` and `NUMTXN` and creates the environment.
2. The environment builds all components and the driver applies reset (`rst` high for 2 clock cycles).
3. Generator, driver, monitor, scoreboard and coverage start together.
4. When the generator is finished and the driver has driven everything, the environment idles the bus and waits 10 cycles so the last read is captured.
5. The environment prints counts, the scoreboard summary and the coverage percentages, then `$finish` is called. A 1 ms timeout protects against a hung simulation.

**Timing and sampling.** The driver changes inputs 1 ns after each rising edge. The monitor samples at the falling edge, so it sees stable inputs and the flags that the DUT will use at the next rising edge. The scoreboard applies the sampled operation to its reference queue at that point, matching what the DUT does on the next edge. Because `rdata` is registered, read data from an accepted read is checked in the next sample.

## Checking strategy

### Scoreboard

| Check | Description |
|---|---|
| Read data | When a read is accepted, the oldest value is popped from the reference queue. In the next sample `rdata` must equal it. |
| `empty` flag | DUT `empty` must equal (reference queue size == 0) every sample. |
| `full` flag | DUT `full` must equal (reference queue size == 32) every sample. |
| Overflow protection | A write is added to the reference queue only if `full` was low. |
| Underflow protection | A read removes from the reference queue only if `empty` was low. |

### Assertions (SVA)

| Assertion | Meaning |
|---|---|
| `assert_empty_after_reset` | After `rst` falls, `empty` is 1 on the next clock |
| `assert_not_full_after_reset` | After `rst` falls, `full` is 0 on the next clock |
| `assert_full_empty_not_both` | `full` and `empty` are never high together (disabled during reset) |

## Tests

Select a test with `--test <name>` (passed to the simulator as `+TESTNAME`).

| Test | Stimulus | What it checks |
|---|---|---|
| `random` | N random transactions, at least one operation per cycle, 70 percent write bias, random data, simultaneous read and write allowed | General data integrity, flags, mixed traffic |
| `write` | N consecutive writes | Filling the FIFO, reaching full, rejecting extra writes |
| `read` | 10 writes, then 10 reads | Basic write then read, data order, return to empty |
| `order` | 20 writes, then 50 times (read, write), then 20 reads | FIFO order and pointer wraparound (pointers pass 64 operations) |
| `empty` | 32 reads on an empty FIFO | Underflow protection |
| `full` | 32 writes | `full` asserts at exactly 32 entries |
| `overflow` | 32 writes, then 5 more writes | Overflow protection, extra writes rejected |

`random` and `write` use the number of transactions set with `--num_txn` (default 200). The other tests have a fixed length.

## Functional coverage

Collected by `FIFO_COVERAGE`:

**`cg_txn`**

- `cp_empty`, `cp_full`: both flag values seen
- `cp_wdata`: bins for `00`, `01-3F`, `40-7F`, `80-FE`, `FF`
- `cp_op`: idle, write only, read only, simultaneous
- `cross_op_full`: operation x full
- `cross_op_empty`: operation x empty

**`cg_fifo_state`**

- full transitions: became full, no longer full
- empty transitions: became empty, no longer empty

Code coverage (statement, branch, condition, expression, FSM, toggle) is enabled at compile time with `+cover=bcefst`.

Goals: 100 percent functional coverage and 95 percent or better code coverage, measured after **merging** the results of all tests. Some bins need specific tests. For example, `idle` while full is only seen in the idle period after the `full` and `overflow` tests.

## Repository structure

```
.
|-- Fifo_rtl.v               # DUT
|-- FIFO_INTERFACE.sv        # Interface with clocking blocks
|-- FIFO_ASSERTIONS.sv       # SVA, bound into the DUT
|-- FIFO_TRANSACTION.sv      # Transaction class
|-- FIFO_GENERATOR.sv        # Stimulus generator (7 test modes)
|-- FIFO_DRIVER.sv           # Driver
|-- FIFO_MONITOR.sv          # Monitor
|-- FIFO_SCOREBOARD.sv       # Reference model and checks
|-- FIFO_COVERAGE.sv         # Functional coverage
|-- FIFO_ENVIRONMENT.sv      # Environment
|-- FIFO_TOP.sv              # Testbench top (includes all class files)
|-- run.py                   # Compile and run script for QuestaSim
|-- commands.txt             # Simple list of commands
|-- RUN_WALKTHROUGH.md       # Detailed walkthrough of run.py
`-- FIFO VERIFICATION PLAN.docx
```

## How to run

### Requirements

- QuestaSim (or ModelSim with SystemVerilog support) with `vlib`, `vlog`, `vsim` in your `PATH`
- Python 3.6 or newer

Check with:

```
vlog -version
```

### Using the script

```
python run.py                              # random test, 200 transactions
python run.py --test full                  # choose a test
python run.py --num_txn 1000               # set number of transactions (random, write)
python run.py --test random --num_txn 500
python run.py --clean                      # delete generated files
```

`run.py` creates the `work` library, compiles the RTL and testbench with coverage, then opens the QuestaSim GUI, adds all waves, runs the simulation and saves the coverage database to `fifo_cov.ucdb`.

### Manual commands

```
vlib work
vlog -work work +cover=bcefst Fifo_rtl.v
vlog -sv -work work +incdir+. +cover=bcefst FIFO_INTERFACE.sv FIFO_ASSERTIONS.sv FIFO_TOP.sv
vsim -coverage -voptargs=+acc -onfinish stop work.FIFO_TOP +TESTNAME=random +NUMTXN=200
```

Then in the QuestaSim transcript:

```
add wave -r /*
run -all
coverage save fifo_cov.ucdb
```

## Reading the results

At the end of each run the transcript shows:

```
Generator created : <n> transactions
Driver drove      : <n> transactions
Monitor observed  : <n> transactions
Total transactions checked : <n>
Read checks PASSED         : <n>
Checks FAILED              : <n>
OVERALL RESULT: ===== PASS =====
Transaction coverage = <x> %
FIFO state coverage  = <y> %
```

A test passes when `OVERALL RESULT: ===== PASS =====` is printed, the failed-check count is 0 and no assertion `$error` appears.

To merge coverage from several tests and create a report:

```
vcover merge all.ucdb a.ucdb b.ucdb
vcover report -details all.ucdb
vcover report -html -output covhtmlreport all.ucdb
```

(Run each test, rename `fifo_cov.ucdb` after every run, then merge.)

## Design notes and limitations

- **Memory indexing.** The memory has 32 entries but the pointers are 6 bits. The memory is indexed with the lower 5 bits (`wr_ptr[4:0]`, `rd_ptr[4:0]`). Indexing with all 6 bits would read outside the array after wraparound. The `order` test is meant to catch this kind of bug.
- **Pointer updates.** Pointers are updated with non-blocking assignments in the clocked blocks to avoid races with the memory write and read blocks.
- **Reset checking is indirect.** Reset is checked through the flags and reset assertions. The testbench does not read the internal memory array or pointers directly.
- **Single reset.** Reset is applied once at the start. Reset during active traffic is not tested yet.
- **Single clock domain.** No clock domain crossing is verified.
- **Fixed-length tests.** `read`, `order`, `empty`, `full` and `overflow` do not scale with `--num_txn`.

Ideas for extension: reset in the middle of traffic, a parameterized depth and width, a UVM version of the environment, and a back-to-back stress test.

## Acknowledgements and references

I referenced public GitHub projects, Reddit discussions and my mentor while building this framework. An AI assistant (Claude) was also used to help with debugging compile errors, the run script and the verification plan document.

Books and standards:

- IEEE Std 1800-2017, SystemVerilog Language Reference Manual
- C. Spear and G. Tumbush, *SystemVerilog for Verification*, 3rd ed., Springer, 2012
- J. Bergeron, *Writing Testbenches Using SystemVerilog*, Springer, 2006
- H. Foster, A. Krolnik and D. Lacey, *Assertion-Based Design*, 2nd ed., Kluwer, 2004
- B. Cohen et al., *SystemVerilog Assertions Handbook*, VhdlCohen Publishing
- Accellera, *UVM 1.2 User's Guide* (IEEE Std 1800.2)
- C. E. Cummings, *Simulation and Synthesis Techniques for Asynchronous FIFO Design*, SNUG San Jose, 2002

Related open-source FIFO verification projects (used for comparison, no code copied):

- [SnehaMummaneni/fifo-sv-verification](https://github.com/SnehaMummaneni/fifo-sv-verification)
- [gokulbalagopal/Verification-of-FIFO-using-SystemVerilog](https://github.com/gokulbalagopal/Verification-of-FIFO-using-SystemVerilog)
- [rachanaa5/sync-fifo-systemverilog](https://github.com/rachanaa5/sync-fifo-systemverilog)
- [guilhermelirar/fifo_verification](https://github.com/guilhermelirar/fifo_verification)
- [Dharshi0809/Synchronous_FIFO](https://github.com/Dharshi0809/Synchronous_FIFO)
- [Himanish-30/Sync-FIFO-UVM](https://github.com/Himanish-30/Sync-FIFO-UVM)

## Author

**Pratyush Kumar Sahu**
Foundation of SystemVerilog, Maven Silicon
