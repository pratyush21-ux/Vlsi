# Zero-Riscy (PULP) Core Integration

Integration and simulation of the open-source **zero-riscy** RISC-V core from the PULP platform (RV32IMC, two-stage pipeline). The work focused on understanding the full core, compiling it standalone in Verilog and exercising the **instruction and data memory interfaces** in simulation. It also fed the UVM verification of its ALU, see [UVM/FW_Zeroriscy_ALU](../../../UVM/FW_Zeroriscy_ALU).

## What was covered

| Block | Role |
|---|---|
| IF stage and prefetch buffer, fetch FIFO | Instruction fetch with buffering |
| Compressed decoder | RV32C expansion |
| ID stage, decoder, immediate generator | Decode and operand preparation |
| Register file | 32 x 32 general-purpose registers |
| EX block: ALU, fast multiplier/divider | Execute |
| Load-store unit | Data memory interface |
| Controller, interrupt controller, debug unit | Pipeline control, exceptions, debug |
| Clock gating cell | Low-power support |

**Note:** the core itself is the work of the PULP platform authors. This entry documents the author's integration and simulation of it.

**Tools:** Verilog, Icarus Verilog / QuestaSim.

## Source code

The source code for this project is **not published** in this repository. It is available on request for academic, recruiting and collaboration purposes.

**Contact the author:** Pratyush Kumar Sahu, [sahukumarpratyush2004@gmail.com](mailto:sahukumarpratyush2004@gmail.com?subject=Code%20request%3A%20Zero-riscy integration) | [GitHub](https://github.com/pratyush21-ux)
