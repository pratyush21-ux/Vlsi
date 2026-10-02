# 5-Stage Pipelined RISC-V Core

A pipelined RISC-V processor written in Verilog. The datapath is split into five stages with pipeline registers between them, so up to five instructions are in flight at once.

## Pipeline stages

| Stage | File | Job |
|---|---|---|
| Fetch (IF) | `fetch_cycle.v` | Reads the instruction memory, updates the PC |
| Decode (ID) | `Decode_Cycle.v` | Decodes the instruction, reads the register file, extends the immediate, generates control signals |
| Execute (EX) | `Execute_Cycle.v` | ALU operation, branch / jump target and branch decision |
| Memory (MEM) | `Memory_Cycle.v` | Data memory read and write |
| Write-back (WB) | `Writeback_cycle.v` | Selects the result and writes the register file |

## Other modules

| File | Role |
|---|---|
| `Pipeline_top.v` | Top level connecting the five stages and the hazard unit |
| `hazard_unit.v` | Data forwarding unit. Produces `ForwardAE` and `ForwardBE` so that an operand can be taken from the MEM or WB stage when the destination register matches a source register in EX (register x0 is excluded) |
| `Control_unit.v`, `Main_Decoder.v`, `ALUDecoder.v` | Control logic |
| `ALU.v`, `ALU_Mux.v` | ALU and operand mux |
| `Core_Datapath.v`, `REG_MEM_BLOCK.v`, `Extend.v` | Datapath pieces, register file, immediate extend |
| `PC.v`, `PC_Mux.v`, `Pc_Plus_4.v`, `Pc_Adder.v`, `Pc_Target.v` | PC logic |
| `Instruction_Memory.v`, `Data_mem.v`, `Result_Mux.v` | Memories and result select |
| `seven_seg.v` | Seven-segment display driver for FPGA board output |

## Notes

- `Pipeline_top.v` contains an earlier version of `Pipeline_top` inside a block comment. The active top module is **`Pipeline_top_with_outputs`**, which adds outputs for the seven-segment display.
- A testbench is not included in this folder yet. To simulate, write a small testbench that drives `clk` and `rst` of `Pipeline_top_with_outputs`.

## Compile check

```
iverilog -s Pipeline_top_with_outputs -o sim *.v
```
