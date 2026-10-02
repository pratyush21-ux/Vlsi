# FIR Filter

A 4-tap finite impulse response (FIR) filter written in Verilog.

## How it works

Input samples shift through a 4-stage delay line (`x_reg`). Each tap is multiplied by a fixed coefficient and the products are summed into a registered output:

```
y[n] = c0*x[n-1] + c1*x[n-2] + c2*x[n-3] + c3*x[n-4]
```

with coefficients `c0..c3 = 1, 2, 3, 4`. Because the output is computed from the delay-line registers and then registered, the output appears after a short latency.

| Item | Value |
|---|---|
| Taps (`N`) | 4 (parameter) |
| Input `x_in` | 8 bits |
| Output `y_out` | 16 bits |
| Coefficients | 1, 2, 3, 4 (8-bit constants) |
| Reset | Active high, asynchronous, clears the delay line and the output |

## Files

| File | Description |
|---|---|
| `Fir_filter.v` | Filter module `Fir_filter` |
| `tb_fir_filter.v` | Testbench: applies inputs 1 to 6 then 0, prints values and dumps `tb_fir_filter.vcd` |
| `tb_fir_filter.vcd` | Saved waveform |

## Simulate

```
iverilog -o sim Fir_filter.v tb_fir_filter.v
vvp sim
gtkwave tb_fir_filter.vcd
```

## Change the filter

Edit the `coeff` assignments in `Fir_filter.v`. To use more taps, change `N` and add the matching coefficients and product terms.
