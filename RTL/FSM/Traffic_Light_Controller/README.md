# Traffic Light Controller (FSM)

A traffic light controller for a two-road crossing (north-south and east-west) written in Verilog. A clock divider produces a slow clock and a timer-based state machine sequences the lights.

## Structure

```
Top_traffic_controller
 |-- Clock_divider        (100 MHz clock to a slow 1 Hz-style clock)
 `-- Traffic_light_con    (FSM and timer)
```

## State machine

| State | Meaning | Duration |
|---|---|---|
| `s0` | North-south green, east-west red | 10 ticks |
| `s1` | North-south yellow | 3 ticks |
| `s4` | All red | 10 ticks |
| `s2` | East-west green, north-south red | 10 ticks |
| `s3` | East-west yellow | 3 ticks |

Order: `s0 -> s1 -> s4 -> s2 -> s3 -> s4 -> s0 ...`. The all-red state remembers which direction just finished so the next green goes to the other road.

Each light output is a 3-bit value `{Red, Yellow, Green}`.

## Ports of `Top_traffic_controller`

| Port | Dir | Description |
|---|---|---|
| `clk` | in | 100 MHz input clock |
| `reset_n` | in | Active-low reset |
| `NS_R`, `NS_Y`, `NS_G` | out | North-south red, yellow, green |
| `EW_R`, `EW_Y`, `EW_G` | out | East-west red, yellow, green |

## Files

| File | Description |
|---|---|
| `Clock_divider.v` | Clock divider |
| `Traffic_light_con.v` | FSM and timer |
| `Top_traffic_controller.v` | Top level |
| `tb_Top_traffic_controller.v` | Testbench |

## Note on the clock divider

The divider is set to a small count (`cnt == 50 - 1`, 16-bit counter) so the simulation shows state changes quickly. For a real 1 Hz clock from 100 MHz on an FPGA board, increase the counter width and the terminal count (about 50,000,000 - 1 for a toggle every half second).

## Simulate

```
iverilog -o sim Clock_divider.v Traffic_light_con.v Top_traffic_controller.v tb_Top_traffic_controller.v
vvp sim
```
