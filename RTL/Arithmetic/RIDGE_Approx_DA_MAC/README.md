# RIDGE: Parameterizable MAC with Runtime Precision and Approximate Reduction Tree

A parameterizable MAC decomposition IP that computes `X . W` over a length-N vector by greedily splitting N into MAC blocks of size 8, 4, 2 and 1. Strictly modular: no bare multiply or add in the datapath, all arithmetic goes through two swappable leaf modules (a multiplier unit and an adder unit). Extended with a **distributed-arithmetic block**, a **runtime-selectable precision** knob and a **compile-time approximate adder tree**.

## Two accuracy-versus-cost knobs

| Knob | When | Effect |
|---|---|---|
| `prec` (runtime) | Set by software, no re-synthesis | Early termination: cycles per frame scale linearly (20, 16, 12, 8 cycles at prec 16, 12, 8, 4) |
| `APPROX_BITS` K (compile time) | Elaboration | Lower-part-OR adder (LOA), LOA without carry prediction (LOAWA) or truncation in the reduction tree, graded per stage |

## Results (N = 24, 32-bit weights, 16-bit data)

**Runtime precision is provably correct:** at every prec level the scaled accumulator matches the golden MSB-truncated dot product exactly, and prec = 16 is bit-exact over 200 random vectors.

| prec | cycles/frame | mean relative error | SNR |
|---|---|---|---|
| 16 | 20 | 0 percent | bit-exact |
| 12 | 16 | 0.40 percent | 47.9 dB |
| 8 | 12 | 9.0 percent | 20.9 dB |
| 4 | 8 | 40.7 percent | 7.8 dB |

**Approximate adder tree (2000 random vectors per point):**

| APPROX_BITS | MAE | SNR |
|---|---|---|
| 0 (exact) | 0 | bit-exact |
| 4 | 6.68 | 163.3 dB |
| 8 | 103.9 | 139.8 dB |
| 12 | 1689 | 115.5 dB |
| 16 | 26065 | 91.8 dB |

At K = 8 the approximation (LOA 139.8 dB, LOAWA 132.3 dB, truncation 121.5 dB) stays well above the roughly 86 dB ceiling of a 14-bit ADC path, so it is invisible at system precision.

## Key findings

1. The two knobs are largely orthogonal. Once precision is lowered, the tree can be approximated aggressively at almost no extra error (47.9 dB to 48.7 dB at prec = 12).
2. Only one re-scaling barrel shifter is needed for the whole engine (after the reduction tree, using linearity), an 8x saving over one per block.
3. K = 0 reproduces the exact design bit for bit, so one parameter sweep spans the whole exact-to-approximate design space.

Next: Sky130 area, power and fmax for each K to build the accuracy-versus-cost Pareto surface.

**Tools:** Verilog, Icarus Verilog, Sky130, Yosys. This work is research in progress.

## Source code

The source code for this project is **not published** in this repository. It is available on request for academic, recruiting and collaboration purposes.

**Contact the author:** Pratyush Kumar Sahu, [sahukumarpratyush2004@gmail.com](mailto:sahukumarpratyush2004@gmail.com?subject=Code%20request%3A%20RIDGE approximate DA MAC) | [GitHub](https://github.com/pratyush21-ux)
