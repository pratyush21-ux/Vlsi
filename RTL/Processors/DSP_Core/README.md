# Custom 16-bit DSP Core with MAC

A small custom processor for DSP workloads: a multi-cycle FSM control unit (idle, fetch, decode, execute) driving a register file, ALU with shifter, a **multiply-accumulate unit**, **saturation logic**, a Q-format multiplier, a **radix-2 FFT butterfly** and a **dual-port data memory**. Program and data are loaded from memory files.

## Highlights

- 16-bit instruction word, 32-bit accumulator and datapath, 10-bit data address.
- **Hardware MAC:** signed 16 x 16 multiply with 32-bit accumulate and enable.
- **Saturating arithmetic** with programmable maximum and minimum.
- **Complex butterfly unit** for FFT stages, with complex multiply by twiddle factor.
- Dual-port data memory for two simultaneous accesses, instruction ROM, register file with 4-bit register indices.
- Outputs program counter, accumulator, ALU result and memory address for easy debug.
- Verified with a self-running testbench and a program memory file.

| Block | Role |
|---|---|
| Control unit | FSM sequencing and opcode decode |
| Register file | 16 registers |
| ALU and shifter | Arithmetic, logic, shift |
| MAC | Multiply-accumulate |
| Saturate and Q-format | Fixed-point support |
| Butterfly | Radix-2 FFT butterfly |
| Instruction ROM, dual-port data memory | Program and data storage |

**Tools:** Verilog, Icarus Verilog / Vivado, GTKWave.

## Source code

The source code for this project is **not published** in this repository. It is available on request for academic, recruiting and collaboration purposes.

**Contact the author:** Pratyush Kumar Sahu, [sahukumarpratyush2004@gmail.com](mailto:sahukumarpratyush2004@gmail.com?subject=Code%20request%3A%20DSP core) | [GitHub](https://github.com/pratyush21-ux)
