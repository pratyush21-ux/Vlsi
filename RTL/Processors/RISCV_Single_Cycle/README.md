# Single-Cycle RISC-V Core

A single-cycle RISC-V processor written in Verilog. Every instruction completes in one clock cycle: fetch, decode, execute, memory access and register write-back all happen between two clock edges.

## Block diagram (module hierarchy)

```
single_cycle_top
 |-- Single_Cycle_Core
 |     |-- Control_unit  (Main_Decoder + ALUDecoder)
 |     `-- Core_Datapath (PC, PC_Mux, Pc_Plus_4, Pc_Target, REG_MEM_BLOCK, Extend, ALU_Mux, ALU, Result_Mux)
 |-- Instruction_Memory
 `-- Data_mem
```

## Modules

| File | Role |
|---|---|
| `single_cycle_top.v` | Top level: connects the core, instruction memory and data memory. Outputs `WriteData`, `ALU_OUTPUT`, `MemWrite` |
| `Single_Cycle_Core.v` | Core: control unit plus datapath |
| `Control_unit.v` | Generates control signals (`RegWrite`, `MemWrite`, `ALUSrc`, `ResultSrc`, `ImmSrc`, `Jump`, `PcSrc`, `ALUControl`) from the opcode, `funct3`, `funct7` bit and the ALU `zero` flag |
| `Main_Decoder.v` | Decodes the 7-bit opcode into main control signals |
| `ALUDecoder.v` | Decodes `ALUop`, `funct3`, `funct7` into the 4-bit `ALUControl` |
| `Core_Datapath.v` | Datapath wiring for PC, register file, immediate extension, ALU and result selection |
| `ALU.v`, `ALU_Mux.v` | Arithmetic and logic unit and its second-operand mux |
| `REG_MEM_BLOCK.v` | Register file |
| `Extend.v` | Immediate generation |
| `PC.v`, `PC_Mux.v`, `Pc_Plus_4.v`, `Pc_Target.v` | Program counter, next-PC select, PC + 4 and branch / jump target |
| `Result_Mux.v` | Selects the write-back value |
| `Instruction_Memory.v` | Instruction ROM, preloaded with a test program |
| `Data_mem.v` | Data memory |
| `seven_seg.v` | Seven-segment display driver module for FPGA board output (not connected in `single_cycle_top`) |
| `single_cycle_top_tb.v` | Testbench |

## Instruction support

The main decoder handles these instruction classes: load, store, register-register ALU, register-immediate ALU, branch (uses the ALU `zero` flag) and jump (`jal`).

## Test program

`Instruction_Memory.v` is preloaded with a short program that builds Fibonacci numbers in registers and stores each result to data memory with `sw`. The testbench runs the core and you can check the values in the waveform or in the data memory.

## Simulate

Requires Icarus Verilog and GTKWave.

```
iverilog -s single_cycle_top_tb -o sim *.v
vvp sim
gtkwave Risc.vcd
```

The testbench uses a 10 time-unit clock period, runs for about 1000 time units and writes `Risc.vcd`.
