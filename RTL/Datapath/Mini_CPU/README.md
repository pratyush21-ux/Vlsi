# Mini CPU

A compact 8-bit CPU built from separate modules: a **control unit** decodes a 2-bit opcode into a mux select, register write enable and 2-bit ALU control; the **datapath** combines an input multiplexer, an **ALU** and a register that drives the 8-bit output.

```
opcode[1:0] --> Control Unit --> mux_sel, reg_we, alu_ctrl[1:0]
in_data[7:0] --> Datapath (Mux --> ALU --> Register) --> out_data[7:0]
```

A good first example of control path versus data path separation.

**Tools:** Verilog.

## Source code

The source code for this project is **not published** in this repository. It is available on request for academic, recruiting and collaboration purposes.

**Contact the author:** Pratyush Kumar Sahu, [sahukumarpratyush2004@gmail.com](mailto:sahukumarpratyush2004@gmail.com?subject=Code%20request%3A%20Mini CPU) | [GitHub](https://github.com/pratyush21-ux)
