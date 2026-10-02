# UART (Transmitter, Receiver and Baud Generator)

A UART written in Verilog with a loopback top module. The transmitter output is wired to the receiver input, so one top module and one testbench exercise both directions.

## Structure

```
Top_UART_Loopback
 |-- Baud_generator   (generates the tick)
 |-- uart_tx          (parallel to serial)
 `-- uart_rx          (serial to parallel, rx = tx)
```

## Modules

| File | Module | Description |
|---|---|---|
| `Baud_generator.v` | `Baud_generator` | Divides the system clock to produce a `tick` pulse. Parameters: `clk_feq` (default 50 MHz) and `baud_rate` (default 9600). The tick is placed in the middle of each bit period |
| `uart_tx.v` | `uart_tx` | Loads a 10-bit frame (start bit, 8 data bits, stop bit) and shifts it out on `tick`, least significant bit first. Outputs `tx` and `tx_busy` |
| `uart_rx.v` | `uart_rx` | Receiver state machine with four states: idle, start, data, stop. Outputs `rx_data[7:0]` and a one-cycle `rx_done` pulse |
| `Top_module.v` | `Top_UART_Loopback` | Connects the three modules and runs a small state machine that sends a fixed data byte (`8'b11000001`) when the transmitter is not busy. Outputs `tx`, `rx_data`, `rx_done` |
| `Top_module_tb.v` | `Top_UART_Loopback_tb` | Testbench: 50 MHz clock, short reset, runs for about 2 ms (many frames at 9600 baud), dumps `uart_loopback.vcd` |

## Frame format

```
idle (1) | start (0) | D0 D1 D2 D3 D4 D5 D6 D7 | stop (1)
```

8 data bits, no parity, 1 stop bit, LSB first.

## Simulate

Requires Icarus Verilog and GTKWave.

```
iverilog -o sim Baud_generator.v uart_tx.v uart_rx.v Top_module.v Top_module_tb.v
vvp sim
gtkwave uart_loopback.vcd
```

In the waveform, watch `tx`, `rx_data` and `rx_done`. The received byte should match the transmitted byte.

## Change the baud rate or clock

Edit the `clk_feq` and `baud_rate` parameters in the `Baud_generator` instance inside `Top_module.v`.
