# Internship: Basic Digital Design Blocks

A collection of basic Verilog digital design blocks, each with a testbench (files ending in `_test.v`). Waveforms saved from some simulations are included as `.vcd` files.

## Contents

### Combinational logic

| Design | Files |
|---|---|
| 2-to-1 multiplexer | `2x1_mux.v`, `2x1_mux_test.v` |
| Half adder and full adder (behavioral) | `Ha_bh.v`, `Fa_bh.v`, `Ha_bh_test.v`, `Fa_bh_test.v` |
| 4-bit full adder (behavioral) | `Fa__4bit_bh.v`, `Fa__4bit_bh_test.v` |
| 4-bit adder / subtractor | `Bit4_add_sub.v`, `Bit4_add_sub_test.v` |
| 4-bit magnitude comparator | `Bit4_mag_comp.v`, `Bit4_mag_comp_test.v` |
| 2-to-4 decoder | `decoder_2x4.v`, `decoder_2x4_test.v` |
| 4-to-2 encoder | `encoder_4x2.v`, `encoder_4x2_test.v` |
| 4-bit ALU | `Bit4_alu.v`, `Bit4_alu_test.v` |
| 32-bit ALU | `Bit32_alu.v`, `Bit32_alu_test.v` |
| Small datapath (input mux, ALU operation select, registered output) | `Path.v`, `Path_test.v` |

### Sequential logic

| Design | Files |
|---|---|
| D flip-flop, T flip-flop | `D_FF.v`, `T_FF.v` |
| Positive-edge and negative-edge D flip-flops with asynchronous reset | `dff_pe_Ar.v`, `dff_Ne_Ar.v` and their `_test.v` files |
| Positive and negative level-sensitive latches | `Pos_latch.v`, `Neg_latch.v` and their `_test.v` files |
| Ripple carry counter | `ripple_carry_counter.v`, `ripple_carry_counter_stimulus.v` |
| Clock divider | `clk_divider.v` |
| Seconds counter | `Clock_count.v`, `Clock_counter.v`, `Clock_count1.v`, `Clock_count1_test.v`, `Clock_count2_test.v` |
| 4-bit up/down counter and system | `top_counter_system.v`, `counter_4bit_updown_test.v`, `conter_4bit_updown_test.v` |
| Digital clock with seven-segment display control | `top_clock.v`, `top_clock_clone.v` |

### Memories

| Design | Files |
|---|---|
| 64 x 32 data memory | `data_memory.v`, `Data_mem_64x32.v`, `data_memory_test.v` |
| 4 x 4 ROM, asynchronous and synchronous read | `rom_4x4_async.v`, `rom_4x4_sync.v`, `rom_4x4_async_test.v` |

### State machines

| Design | Files |
|---|---|
| Moore FSM | `moore_101.v`, `moore_101_test.v` |
| Mealy FSM test | `melay_101_test.v` (see known issues) |

### Waveforms

`Fawave.vcd`, `Fawave1.vcd`, `Hawave.vcd`, `Magcomwave.vcd`, `Negwave.vcd`, `Poswave.vcd`, `ripple_carry_counter.vcd`

## Simulate one design

Compile one design with its own testbench at a time (some files define the same module name, see below). Example for the 2-to-4 decoder:

```
iverilog -o sim decoder_2x4.v decoder_2x4_test.v
vvp sim
```

## Known issues

- `mealy_101.v` currently contains a module named `traffic_light_fsm` (a traffic light FSM), not a Mealy sequence detector. The Mealy design file needs to be replaced; the testbench is `melay_101_test.v`.
- Several files define the same module name and cannot be compiled together: `Ha_bh` is in both `Ha_bh.v` and `Fa_bh.v`; `data_memory` is in both `data_memory.v` and `Data_mem_64x32.v`; `clk_divider`, `Clock_count1` and `seg7_control` are repeated inside `top_clock.v` and `top_clock_clone.v`.
- File names `Clock_count.v` and `Clock_counter.v` both define a module named `counter_sec`.
