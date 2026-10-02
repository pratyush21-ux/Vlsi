# RTL Designs

Verilog RTL designs, grouped by category. Each folder has its own README with the design overview, module list and simulation steps.

| Category | Projects |
|---|---|
| [Processors](Processors) | [RISCV_Single_Cycle](Processors/RISCV_Single_Cycle), [RISCV_Pipelined](Processors/RISCV_Pipelined) |
| [Protocols](Protocols) | [UART](Protocols/UART) |
| [FSM](FSM) | [Door_Lock_FSM](FSM/Door_Lock_FSM), [Traffic_Light_Controller](FSM/Traffic_Light_Controller), [Washing_Machine](FSM/Washing_Machine) |
| [DSP](DSP) | [FIR_Filter](DSP/FIR_Filter) |
| [Internship](Internship) | Basic digital design blocks (gates, adders, ALUs, flip-flops, latches, counters, memories) with testbenches |

## Simulating

All designs are plain Verilog and can be simulated with [Icarus Verilog](https://steveicarus.github.io/iverilog/) and viewed in [GTKWave](https://gtkwave.sourceforge.net/):

```
iverilog -o sim <design files> <testbench file>
vvp sim
gtkwave <waveform>.vcd
```

The exact file list for each project is in that project's README. They can also be run in Vivado, ModelSim or QuestaSim.
