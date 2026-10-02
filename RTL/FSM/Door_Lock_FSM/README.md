# Door Lock System (FSM)

A keypad door lock written in Verilog. The user enters a 4-digit code on a 4-bit keypad bus; a state machine and a password checker decide whether to unlock the door or raise an alarm.

## Structure

```
Top_module
 |-- Fsm_con            (state machine, indicator and alarm outputs)
 |     `-- Password_checker
 `-- Password_checker   (compares entered digits with the stored password, counts attempts)
```

## Ports of `Top_module`

| Port | Dir | Description |
|---|---|---|
| `clk`, `rst` | in | Clock and active-high reset |
| `key_in[3:0]` | in | Keypad digit |
| `enter` | in | Enters the current digit |
| `locked` | out | High while the door is locked |
| `red_light` | out | Locked indicator |
| `green_light` | out | Unlocked indicator |
| `alarm` | out | Alarm (buzzer) output |

## State machine (`Fsm_con.v`)

| State | Meaning |
|---|---|
| `IDLE` | Waiting for the first `enter`, door locked, red light on |
| `INPUT_WAIT` | Collecting digits. A digit counter increments on each `enter`; after the 4th digit and `enter` released it moves to `CHECKING` |
| `CHECKING` | Pulses `check` to the password checker for one cycle |
| `WAIT_RESULT` | Reads the checker result: correct goes to `UNLOCKED`, third wrong attempt goes to `ALARM`, otherwise back to `INPUT_WAIT` so the user can retry |
| `UNLOCKED` | Password correct: green light on, red light off, `locked` low, then back to `IDLE` |
| `ALARM` | Three wrong attempts in a row: buzzer on, red light on, then back to `IDLE` |

`Top_module` also has a relock timer: after the door unlocks, `locked` stays low for `UNLOCK_TIME` clock cycles (parameter, default 100) and then goes high again.

## Files

| File | Description |
|---|---|
| `Fsm_con.v` | Control FSM |
| `Password_checker.v` | Password storage, entered-digit capture, attempt counter, `door_unlocked` and `incorrect_flag` outputs |
| `Top_module.v` | Top level with the relock timer |
| `Top_module_tb.v` | Testbench, dumps `Top_module_tb.vcd` |
| `Doc.docx` | Design document |

The correct password is set in the reset branch of `Password_checker.v`.

## Simulate

```
iverilog -o sim Password_checker.v Fsm_con.v Top_module.v Top_module_tb.v
vvp sim
gtkwave Top_module_tb.vcd
```
