# Washing Machine Controller (FSM)

A washing machine cycle controller written in Verilog. A start input moves the machine through the cycle stages and a timer decides how long each stage lasts.

## State machine

```
Idle -> Fill -> Wash -> Rinse -> Spin -> Done
```

| State | Output asserted |
|---|---|
| `Idle` | none, waits for `srt` |
| `Fill` | `fill` (and `red`) |
| `Wash` | `wash` |
| `Rinse` | `rinse` |
| `Spin` | `spin` |
| `Done` | `done` |

Each of the Fill, Wash, Rinse and Spin stages lasts `TIME_FILL`, `TIME_WASH`, `TIME_RINSE` and `TIME_SPIN` clock cycles (4 each by default). These are parameters in `Washing_machine.v`.

## Ports

| Port | Dir | Description |
|---|---|---|
| `clk`, `rst` | in | Clock and active-high reset |
| `srt` | in | Start |
| `fill`, `wash`, `rinse`, `spin`, `done` | out | Stage outputs |
| `red`, `green`, `buzzer` | out | Indicator and buzzer outputs |

## Files

| File | Description |
|---|---|
| `Washing_machine.v` | FSM and timer |
| `Washing_machine_tb.v` | Testbench: reset, one start pulse, runs 2000 time units, dumps `washing_machine.vcd` |
| `washing_machine.vcd` | Saved waveform |

## Simulate

```
iverilog -o sim Washing_machine.v Washing_machine_tb.v
vvp sim
gtkwave washing_machine.vcd
```
