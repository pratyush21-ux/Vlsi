# Booth Multipliers: Classical, Radix-4, Radix-8 and Hybrid Approximate

A family of 16-bit Booth multiplier implementations built to study energy-efficient arithmetic for edge AI.

## Highlights

- **Hybrid Radix-4/8 Booth multiplier** with position-aware hard-multiple approximation: **58 percent lower power-delay product and 60 percent smaller area** than baselines, validated on a **Basys-3 FPGA** with **Vivado ILA**.
- Companion manuscript *"A Position-aware Hybrid Radix-4/8 Booth Multiplier with Hard-multiple Approximation for Energy-Efficient Edge Computing"* is **under review**.

## Variants

| Variant | Description |
|---|---|
| Classical Booth | Baseline Booth multiplier with decoder, shift and adder units |
| Radix-4 Booth | Modified Booth with 9-bit barrel shifter and two's-complement units |
| Radix-8 Booth | Fewer partial products, needs hard multiple (3X) |
| H2R MULT v1 | Hybrid: radix-4 (upper bits) and radix-8 (lower bits) segments |
| H2R MULT v2 | Adds a 32-bit approximate adder for the hard-multiple path |

## Image-processing evaluation

A MATLAB and Icarus Verilog co-simulation flow evaluates error tolerance on real images (grayscale and 512 x 512 RGB): MATLAB exports pixels, the hardware simulation multiplies them by a fixed coefficient, and MATLAB reconstructs the image and reports quality metrics.

```
MATLAB: extract pixels --> pixels.txt --> iverilog simulation --> results.txt --> MATLAB: analyze and display
```

**Tools:** Verilog, Icarus Verilog, Vivado, ILA, Basys-3, MATLAB.

## Source code

The source code for this project is **not published** in this repository. It is available on request for academic, recruiting and collaboration purposes.

**Contact the author:** Pratyush Kumar Sahu, [sahukumarpratyush2004@gmail.com](mailto:sahukumarpratyush2004@gmail.com?subject=Code%20request%3A%20Booth multipliers) | [GitHub](https://github.com/pratyush21-ux)
