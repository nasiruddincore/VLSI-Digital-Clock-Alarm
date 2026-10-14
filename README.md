# Modern Dot-Matrix Digital Clock & Dashboard

## Overview
An industry-standard RTL digital clock modeling modern consumer electronics. It replaces legacy hardware switches with a User Interface Finite State Machine (UI-FSM), simulating button-driven time/alarm setups (`Time`, `Wake up`, `+`, `-`). Output is driven via an SPI controller designed for external Dot Matrix LED modules.

## VLSI Concepts Demonstrated
* **UI Finite State Machines (FSM):** Handles complex user interactions (holding mode buttons while iterating data) strictly in hardware logic.
* **SPI Peripheral Control:** Implements a hardware shift register to clock data out serially to external screens.
* **Parallel Comparator Logic:** A multi-alarm controller evaluating several trigger conditions concurrently to route different dashboard events (e.g., Radio vs. Buzzer).

## How to Simulate
1. Compile: `iverilog -o clock_sim rtl/*.v tb/tb_digital_clock.v`
2. Run: `vvp clock_sim`
3. View: `gtkwave clock_waves.vcd`

*The testbench automatically simulates pressing the `Time` and `+`/`-` buttons to configure 07:24, sets the alarm to 07:25, and lets the simulation run to prove the Radio output triggers correctly.*