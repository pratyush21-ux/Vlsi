# UVM Verification of the Zero-Riscy ALU

A coverage-driven UVM testbench for the ALU of the PULP **zero-riscy** core (combinational 32-bit ALU, 22 operations across arithmetic and logic, shifter, comparator and set-on-compare).

## Results

| Item | Result |
|---|---|
| Functional coverage | **100 percent** (352 / 352 bins) |
| DUT branch, condition, expression, statement | **100 percent** |
| DUT toggle | **100 percent** after one documented waiver |
| Transactions checked | 15,000 (5 sequences x 3,000) |
| Scoreboard mismatches | **0** |
| Assertions | Pass |

## Environment

```
tb top --> clock + interface (clocking blocks, SVA) --> DUT
uvm_test (random / corner / regression)
   env --> agent (sequencer, driver, monitor) --> scoreboard (reference model) + coverage
```

- **Clocking blocks and modports** remove driver and monitor races even though the DUT is combinational.
- **Reference-model scoreboard** predicts all four outputs; the check phase also fails if zero transactions were checked.
- **Embedded SVA:** no X on outputs for legal opcodes, equal flag matches the adder result, boolean comparison output.
- **Sequence library:** random, corner (operand extremes), equal (A equals B), shift (0, 1, 31), illegal opcodes.
- **Configuration object** and plusarg test selection.
- **Coverage waiver:** the single un-toggled node is a constant carry-in, documented and excluded.
- Signoff is scoped to the DUT instance, not the UVM library code.

**Tools:** SystemVerilog, UVM, QuestaSim 2024.1, vcover.

## Source code

The source code for this project is **not published** in this repository. It is available on request for academic, recruiting and collaboration purposes.

**Contact the author:** Pratyush Kumar Sahu, [sahukumarpratyush2004@gmail.com](mailto:sahukumarpratyush2004@gmail.com?subject=Code%20request%3A%20UVM zero-riscy ALU) | [GitHub](https://github.com/pratyush21-ux)
