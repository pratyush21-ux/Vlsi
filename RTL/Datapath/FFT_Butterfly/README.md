# Radix-2 FFT Butterfly Unit

Combinational radix-2 butterfly for complex FFT processing, using 16-bit signed real and imaginary inputs.

```
T    = B x W         (complex multiply, 4 real multipliers)
OUT0 = A + T
OUT1 = A - T
```

- Inputs: A, B and twiddle factor W, each with real and imaginary 16-bit parts.
- Outputs: four 32-bit results (two complex values) with full precision.
- Reused as the butterfly unit inside the [DSP core](../../Processors/DSP_Core).

**Tools:** Verilog.

## Source code

The source code for this project is **not published** in this repository. It is available on request for academic, recruiting and collaboration purposes.

**Contact the author:** Pratyush Kumar Sahu, [sahukumarpratyush2004@gmail.com](mailto:sahukumarpratyush2004@gmail.com?subject=Code%20request%3A%20FFT butterfly) | [GitHub](https://github.com/pratyush21-ux)
