# DAVIC: Distributed-Arithmetic engine for Variable-length vector Inner-product Computation

A **multiplier-free**, fully parameterized inner-product / MAC IP core that computes `P = sum(X_k * W_k)` for **variable x variable** vectors using **radix-4 Booth encoding and cross-element carry-save reduction**. No DSP blocks and no hardware multipliers. A **folded, time-multiplexed** datapath and a **pipelined** reduction tree keep it small and fast.

```
X_in --+
       +--> Booth PPG --> Carry-Save Reduction (pipelined) --> S,C --> final add --> P
W_in --+      (partial products only, no multipliers)
```

## Highlights

| Metric | Result | Platform |
|---|---|---|
| FPGA LUTs | **9x fewer** (about 206K to 22K) vs fully parallel baseline | Xilinx Artix-7, Vivado |
| On-chip power | **about 5.8x lower** (about 13.6 W to 2.3 W) | Xilinx Artix-7, Vivado |
| Timing | Met at target clock after pipelining the reduction tree | Vivado |
| Booth partial-product generator | **about 9 percent smaller** (XOR negation, collected +1 corrections) | RTL |
| ASIC area | **about 37K um2** standard-cell, flattened | SkyWater Sky130, Yosys |

## Architecture

1. **True distributed arithmetic:** radix-4 Booth encoding emits N/2 partial products per element as shifts and negations. Partial products from all elements are pooled and reduced as one column compression.
2. **Folded datapath:** the vector length N is split into sub-vectors of size 8, 4, 2 and 1 (from the binary of N). One physical compute block processes one sub-vector per cycle and the partial sums are accumulated in a small memory. One block does the work of many.
3. **Pipelined carry-save reduction:** a tree of 3:2 carry-save adders with pipeline registers between levels outputs the sum in carry-save form; a final carry-propagate adder collapses it.

| Module | Role |
|---|---|
| Top wrapper | Start/done handshake, packed X and W inputs |
| Folding controller | Splits N into 8/4/2/1 sub-vectors and sequences them |
| Compute block | Booth PPG, pooled reduction, accumulator |
| Booth radix-4 PPG | Partial-product generator |
| Pipelined CSR tree | 3:2 carry-save adders with automatic level count |
| Final adder and result memory | S + C collapse and partial-sum storage |

## Parameters

Any vector length N (verified 18 to 100), signed operands of 8, 16, 32 or 64 bits, accumulator sized as operand widths plus ceil(log2 N).

## Verification

Self-checking directed and random testbenches (signed, including extremes) across N = 18 to 100 and 8/16/32/64-bit operands, simulated with Icarus Verilog.

## Design notes

Radix-8 was evaluated and found larger rather than smaller, so the design stays radix-4. Next step: merge the efficient PPG into the folded and pipelined block for a combined Vivado and Sky130 run.

**Tools:** Verilog, Icarus Verilog, Vivado, Yosys, Sky130.

## Source code

The source code for this project is **not published** in this repository. It is available on request for academic, recruiting and collaboration purposes.

**Contact the author:** Pratyush Kumar Sahu, [sahukumarpratyush2004@gmail.com](mailto:sahukumarpratyush2004@gmail.com?subject=Code%20request%3A%20DAVIC) | [GitHub](https://github.com/pratyush21-ux)
