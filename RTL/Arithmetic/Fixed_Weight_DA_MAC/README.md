# Fixed-Weight Distributed-Arithmetic MAC on Zynq-7010

A multiplier-free MAC engine computing an N-length inner product `P = sum(A_k * x_k)` with **fixed-weight distributed arithmetic**. Built as the **readout layer of an opto-electronic photonic reservoir computer** on a **Red Pitaya STEMlab 125-14 (Xilinx Zynq-7010)**.

## Highlights

- **No multiplier, no DSP blocks:** multiplication becomes an 8-entry LUT plus a shift-accumulator.
- **100-tap signed MAC**, closing timing at **125 MHz** and interfaced to the ARM processor through a memory-mapped register bus and a 125 MHz ADC.
- **Trained weights loaded once through AXI DMA** over AXI4-Stream; data from the ADC.
- **Packaged as a Vivado IP** with block design: Zynq PS, AXI DMA and the DA engine.
- Verified against a reference dot product (directed and random, including negatives and extremes) for N = 1, 7, 16, 33, 99, 100, 128.

## How it works

For fixed weights, each input is written bit by bit and the sums are swapped, so the result depends only on the K input bits at each bit position. That leaves only 2^K values, which are precomputed into a LUT.

- **Block:** 3 taps, so a 3-bit address into an 8-entry LUT, MSB-first shift-accumulate in two's complement.
- **Design:** ceil(N/3) blocks in parallel (34 blocks for N = 100, auto-padded to 102 taps).
- **Reduction:** pipelined adder tree that uses fast carry chains on the FPGA. A Dadda carry-save alternative was built for a possible ASIC flow, since it was slower on FPGA.
- **Weight path:** AXI4-Stream slave captures weight words from the DMA and signals when the last weight lands.

## Vivado flow

Part-based project (xc7z010clg400-1, Red Pitaya is not in the board list), IP packaging with AXI4-Stream slave auto-detection, active-high reset, block design with PS, AXI DMA (MM2S only, scatter-gather off) and the DA IP.

## Status

Weight path and compute core verified. The ADC data path is being finalized.

**Tools:** Verilog, Vivado, Icarus Verilog, AXI4-Stream, AXI DMA, Red Pitaya.

## Source code

The source code for this project is **not published** in this repository. It is available on request for academic, recruiting and collaboration purposes.

**Contact the author:** Pratyush Kumar Sahu, [sahukumarpratyush2004@gmail.com](mailto:sahukumarpratyush2004@gmail.com?subject=Code%20request%3A%20Fixed-Weight DA MAC) | [GitHub](https://github.com/pratyush21-ux)
