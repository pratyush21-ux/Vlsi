# Pratyush Kumar Sahu - VLSI / RTL Design and Verification

Hi, I'm **Pratyush Kumar Sahu**, an Electronics and Communication Engineering undergraduate at Silicon University, Bhubaneswar, working on **VLSI and RTL design** and **functional verification**. This repository is my portfolio of Verilog and SystemVerilog work: digital building blocks, FSM controllers, a UART, RISC-V processor cores, and verification environments.

I am looking for a **VLSI Design / Verification Engineer** role (internships and entry level) in RTL design, verification and the RTL-to-GDSII flow.

**Contact:** sahukumarpratyush2004@gmail.com | [GitHub](https://github.com/pratyush21-ux)

---

## Repository layout

```
.
|-- RTL/
|   |-- Processors/     RISCV_Single_Cycle, RISCV_Pipelined
|   |-- Protocols/      UART
|   |-- FSM/            Door_Lock_FSM, Traffic_Light_Controller, Washing_Machine
|   |-- DSP/            FIR_Filter
|   `-- Internship/     basic digital design blocks and testbenches
|-- UVM/                UVM verification projects (FW_ALU, FW_decoder)
`-- SV/                 SystemVerilog verification projects (FIFO_verification)
```

## What is in this repository

| Folder | What it contains | Language / tools |
|---|---|---|
| [`RTL/Internship/`](RTL/Internship) | About 55 Verilog designs with testbenches from my digital design internship: adders, ALUs, multiplexer, decoder, encoder, magnitude comparator, latches, flip-flops, counters, clock divider, ROM and data memory, Mealy and Moore sequence detectors | Verilog, Icarus Verilog, GTKWave |
| [`RTL/Processors/RISCV_Single_Cycle/`](RTL/Processors/RISCV_Single_Cycle) | Single-cycle RISC-V core: ALU, ALU decoder, main decoder, control unit, datapath, register file, instruction and data memory, sign extend, PC logic, seven-segment output wrapper and a testbench | Verilog |
| [`RTL/Processors/RISCV_Pipelined/`](RTL/Processors/RISCV_Pipelined) | 5-stage pipelined RISC-V core with separate fetch, decode, execute, memory and write-back stages and a hazard unit | Verilog |
| [`RTL/Protocols/UART/`](RTL/Protocols/UART) | UART transmitter, receiver, baud-rate generator, top module and testbench | Verilog |
| [`RTL/DSP/FIR_Filter/`](RTL/DSP/FIR_Filter) | FIR filter design with testbench and waveform dump | Verilog |
| [`RTL/FSM/Door_Lock_FSM/`](RTL/FSM/Door_Lock_FSM) | Door lock system: FSM controller, password checker, top module, testbench and design document | Verilog |
| [`RTL/FSM/Traffic_Light_Controller/`](RTL/FSM/Traffic_Light_Controller) | FSM-based traffic light controller with clock divider and testbench | Verilog |
| [`RTL/FSM/Washing_Machine/`](RTL/FSM/Washing_Machine) | FSM-based washing machine controller with testbench | Verilog |
| [`SV/FIFO_verification/`](SV/FIFO_verification) | Class-based SystemVerilog testbench for a 32 x 8 synchronous FIFO: generator, driver, monitor, scoreboard, SVA assertions, functional coverage, 7 tests, run in QuestaSim | SystemVerilog, SVA, QuestaSim |
| [`UVM/`](UVM) | UVM verification environment for a 32-bit RISC-V style ALU: sequence, driver, monitor, agent, scoreboard, coverage. Results and architecture are documented in the folder README (source code kept private) | SystemVerilog, UVM, QuestaSim |

## Highlights

- **UVM ALU verification:** complete UVM testbench with a golden-reference scoreboard, 70,000+ constrained-random transactions, 100 percent functional coverage and zero failures. See [`UVM/FW_ALU`](UVM/FW_ALU).
- **SystemVerilog FIFO verification:** layered testbench with assertions, functional coverage and 7 directed and random tests. See [`SV/FIFO_verification`](SV/FIFO_verification).
- **RISC-V cores:** single-cycle and 5-stage pipelined implementations written in Verilog.
- **Protocol and control designs:** UART, FIR filter and several FSM-based controllers.

## Other work (not in this repository)

- **Distributed-Arithmetic MAC accelerator on Xilinx Zynq-7010:** multiplier-free 100-tap signed MAC using distributed arithmetic, interfaced to an ARM processor through a memory-mapped register bus and a 125 MHz ADC; closed timing at 125 MHz with no DSP blocks used.
- **DAVIC, a distributed-arithmetic vector inner-product engine:** folded, pipelined architecture that reduced FPGA LUTs by 9x and on-chip power by 5.8x versus a parallel baseline.
- **Hybrid Radix-4/8 Booth multiplier for energy-efficient edge AI:** 58 percent lower power-delay product and 60 percent smaller area than baselines, validated on a Basys-3 FPGA with Vivado ILA.
- **Zero-Riscy (PULP) core integration:** simulation of instruction and data interfaces.
- **1-TOPS RISC-V SoC program:** selected among the top 37 teams nationwide out of 550+ proposals for a silicon tape-out initiative.

## Experience

| Period | Role |
|---|---|
| Jun 2026 - Aug 2026 | Research Intern, Centre for Advanced Studies in Electronics Science and Technology, University of Hyderabad (SystemVerilog, UVM, constrained-random and coverage-driven verification, FPGA accelerator on Zynq-7010) |
| May 2026 - Jun 2026 | Summer Intern, RTL-to-CHIP: Practical Digital System Design, Silicon University, Odisha (RV32I single-cycle core, RTL coding, synthesis, simulation, debugging) |
| May 2025 - Jun 2025 | Digital VLSI and RTL Design Intern, Silicon Institute of Technology (8+ Verilog RTL designs, single-cycle RISC-V processor, custom testbenches) |

## Skills

- **HDL and design:** Verilog HDL, SystemVerilog, RTL design, FSM design, RISC-V ISA architecture, UVM, pipelined CPU architecture, ALU and Booth multiplier design, approximate computing
- **Verification:** testbench development, functional verification, constrained-random and coverage-driven verification, SVA, simulation and debugging
- **EDA tools:** Xilinx Vivado, ModelSim, QuestaSim, GTKWave, Yosys, MATLAB, Simulink
- **Embedded and programming:** C, Embedded C, Python (scripting), RISC-V assembly, Arduino, ESP32
- **Protocols:** UART, SPI

## Education

- **B.Tech, Electronics and Communication Engineering**, Silicon University, Bhubaneswar (2023 - 2027), CGPA 7.81

## Research (under review)

- P. K. Sahu et al., "A Position-aware Hybrid Radix-4/8 Booth Multiplier with Hard-multiple Approximation for Energy-Efficient Edge Computing," 2026. *(under review)*
- A. Khanda, K. Mahapatra, J. Chowdhury, J. K. Das, P. K. Sahu and A. Sarkar, "A Digital Twin-Based RTL Framework for Hardware Aging Prognostics and Self-Correction in Combinational Circuits," IEEE EDKON, 2026. *(under review)*

## Achievements and certifications

- 1st Place, Idea Build-Up Competition, SPARKUP Summit 2026, E-Cell, Silicon University
- Selected in the top 37 of 550+ teams nationally for the 1-TOPS RISC-V SoC silicon tape-out program
- HackNation, NIRMAN 4.0 Smart EV Charging Station innovation (2025)
- Digital Design, Maven Silicon (Centre of Excellence in Semiconductors), 2026
- IEEE ANRF Workshop on the FPGA-to-ASIC design flow, NIT Rourkela, 2026
- VLSI Design Workshop, NIELIT Calicut

## How to simulate a design

Most designs are plain Verilog and run with the free [Icarus Verilog](https://steveicarus.github.io/iverilog/) simulator and [GTKWave](https://gtkwave.sourceforge.net/). Example, from inside a design folder (replace the file names with the design and its testbench):

```
iverilog -o sim design.v design_tb.v
vvp sim
gtkwave waveform.vcd
```

Designs can also be simulated in Vivado, ModelSim or QuestaSim. The SystemVerilog verification projects need QuestaSim (see the README in each folder).

## Feedback and collaboration

If this repository helped you, a star is appreciated. Suggestions, issues and collaboration ideas are welcome. Reach me at sahukumarpratyush2004@gmail.com.
