# RTL Designs

Verilog RTL designs, grouped by category. Each folder has its own README with the design overview, module list and simulation steps.

| Category | Projects |
|---|---|
| [Processors](Processors) | [RISCV_Single_Cycle](Processors/RISCV_Single_Cycle), [RISCV_Pipelined](Processors/RISCV_Pipelined), [DSP_Core](Processors/DSP_Core) (description only), [Zero_Riscy](Processors/Zero_Riscy) (description only) |
| [Arithmetic](Arithmetic) | [DAVIC](Arithmetic/DAVIC), [Fixed_Weight_DA_MAC](Arithmetic/Fixed_Weight_DA_MAC), [RIDGE_Approx_DA_MAC](Arithmetic/RIDGE_Approx_DA_MAC), [Booth_Multipliers](Arithmetic/Booth_Multipliers) (description only, code on request) |
| [Datapath](Datapath) | [Mini_CPU](Datapath/Mini_CPU), [FFT_Butterfly](Datapath/FFT_Butterfly), [Tri_State_Bus](Datapath/Tri_State_Bus) (description only) |
| [Protocols](Protocols) | [UART](Protocols/UART) |
| [FSM](FSM) | [Door_Lock_FSM](FSM/Door_Lock_FSM), [Traffic_Light_Controller](FSM/Traffic_Light_Controller), [Washing_Machine](FSM/Washing_Machine) |
| [DSP](DSP) | [FIR_Filter](DSP/FIR_Filter) |
| [Internship](Internship) | Basic digital design blocks (gates, adders, ALUs, flip-flops, latches, counters, memories) with testbenches |

## Simulating

Projects marked description only contain a README with architecture and results; source code is available on request from sahukumarpratyush2004@gmail.com.

All other designs are plain Verilog and can be simulated with [Icarus Verilog](https://steveicarus.github.io/iverilog/) and viewed in [GTKWave](https://gtkwave.sourceforge.net/):

```
iverilog -o sim <design files> <testbench file>
vvp sim
gtkwave <waveform>.vcd
```

The exact file list for each project is in that project's README. They can also be run in Vivado, ModelSim or QuestaSim.
