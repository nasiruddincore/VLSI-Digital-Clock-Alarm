Modern Dot-Matrix Digital Clock & Dashboard (VLSI / FPGA)

📖 Overview

An industry-standard RTL digital clock modeling modern consumer electronics. This project transitions from legacy hardware switches to a User Interface Finite State Machine (UI-FSM), simulating button-driven time and alarm setups (Time, Wake up, +, -, Snooze). Visual output is driven via a custom SPI controller designed for external Dot Matrix LED modules, alongside a parallel multi-alarm controller for distinct physical hardware triggers.

🚀 Extended Project Description

This project bridges the gap between fundamental digital logic and modern consumer electronics by implementing a fully synthesizable digital dashboard in Verilog. Moving beyond legacy hardware DIP switches, the architecture utilizes a dedicated User Interface Finite State Machine (UI-FSM) to handle button-driven interactions, simulating a modern smart clock. The core timekeeping logic relies on synchronous clock-enables derived from a primary 50 MHz board clock and cascaded modulo counters, ensuring deterministic, hardware-level precision without relying on software microcontrollers.

To replicate modern aesthetics, the traditional 7-segment multiplexer was replaced with a custom SPI controller designed to drive external 8x8 dot-matrix LED displays serially. Furthermore, the system integrates a parallel multi-alarm controller that evaluates several time-trigger conditions concurrently, routing specific events to distinct physical hardware outputs such as relays, radios, or buzzers. The entire RTL architecture is rigorously verified for edge-case rollovers using an Icarus Verilog testbench and GTKWave, and is fully constrained for hardware deployment on Xilinx Artix-7 FPGAs.

🧠 VLSI Concepts Demonstrated

UI Finite State Machines (FSM): Handles complex user interactions (holding mode buttons while iterating data) strictly in hardware logic, eliminating metastability.

SPI Peripheral Control: Implements a hardware shift register to clock data out serially to external screens (e.g., MAX7219 Dot Matrix modules).

Parallel Comparator Logic: A multi-alarm controller evaluating several trigger conditions concurrently to route different dashboard events.

Synchronous Clock Domains: Uses a single 50 MHz clock with generated clock-enables (tick_1hz, tick_1k) to prevent routing skew and timing violations common with gated clocks.

📂 Folder Structure

VLSI-Digital-Clock-Alarm/
│
├── rtl/                            # Verilog source files (Synthesizable RTL)
│   ├── clk_divider.v               # Generates 1Hz (time) and 1kHz (SPI/Debounce) ticks
│   ├── ui_fsm.v                    # Manages button states (Set Time/Alarm) and internal counters
│   ├── multi_alarm_controller.v    # Handles parallel alarm checks for multiple physical outputs
│   ├── spi_dot_matrix.v            # Drives the external dot-matrix display via SPI protocol
│   └── top_digital_clock.v         # Top-level integration module
│
├── tb/                             # Verification / Testbench files
│   └── tb_digital_clock.v          # Self-checking TB to simulate button presses & fast-forward time
│
├── constraints/                    # Physical constraints for FPGA mapping
│   └── basys3_nexys4.xdc           # Maps buttons, SPI headers, and relay outputs (Artix-7)
│
├── waveforms/                      # Simulation proof outputs (Screenshots & VCDs)
├── reports/                        # Vivado synthesis utilization & timing reports
├── docs/                           # Block diagrams and FSM state diagrams
└── README.md                       # Project documentation


💻 Simulation Setup & Instructions

Prerequisites

You need an HDL simulator and waveform viewer. This project is configured for Icarus Verilog and GTKWave.

Windows: Install via Winget: winget install Icarus.Verilog

Linux: sudo apt install iverilog gtkwave

Running the Testbench

Open a terminal in the root directory VLSI-Digital-Clock-Alarm/.

Compile the design:

iverilog -o clock_sim rtl/*.v tb/tb_digital_clock.v


Execute the simulation:

vvp clock_sim


View the waveforms:

gtkwave clock_waves.vcd


Note: The testbench overrides the primary clock parameter to dynamically speed up simulation, successfully testing hours of real-time logic in milliseconds. It automates button presses to set the clock to 07:24, sets the alarm to 07:25, and verifies the trigger_radio hardware output fires exactly at rollover.

🛠️ FPGA Implementation (Xilinx Vivado)

This design is fully synthesizable. To map to hardware:

Create a new RTL project in Xilinx Vivado.

Add the .v files from the rtl/ directory as Design Sources.

Add the basys3_nexys4.xdc file from constraints/ as the Constraints Source.

Connect the SPI pins (spi_cs, spi_clk, spi_data) from the PMOD headers to your external display.

Run Synthesis, run Implementation, and Generate Bitstream.

🔮 Future Improvements

Add I2C sensor logic to display room temperature/humidity alongside the time.

Add a parameterized debounce module to filter out mechanical button bounce on real hardware.

Expand the SPI logic with a Character ROM to render letters (e.g., "MON", "TUE") on the dot matrix.
