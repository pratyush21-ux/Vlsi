# UVM Verification of a Synchronous FIFO

A complete **UVM** environment for a parameterized synchronous FIFO (8-bit data, 8 entries, single clock, active-low reset, full and empty flags, simultaneous read and write).

## Results

| Metric | Result |
|---|---|
| Functional coverage | **100 percent** |
| RTL code coverage | **100 percent** |
| Assertions | **100 percent** |
| Scoreboard failures | **0** |

## Environment

Test, sequence, sequencer, driver, monitor, agent, environment, scoreboard with a **queue-based reference model**, functional coverage and SVA assertions. Constrained-random, coverage-driven.

```
Test --> Sequence --> Sequencer --> Driver --> FIFO interface --> DUT --> Monitor --+--> Scoreboard
                                                                                   +--> Functional coverage
```

Planned: overflow and underflow tests, more directed tests, regression automation. A plain SystemVerilog version of this verification is in [SV/FIFO_verification](../../SV/FIFO_verification).

**Tools:** SystemVerilog, UVM 1.1d, QuestaSim 2024.1.

## Source code

The source code for this project is **not published** in this repository. It is available on request for academic, recruiting and collaboration purposes.

**Contact the author:** Pratyush Kumar Sahu, [sahukumarpratyush2004@gmail.com](mailto:sahukumarpratyush2004@gmail.com?subject=Code%20request%3A%20UVM FIFO) | [GitHub](https://github.com/pratyush21-ux)
