# Limen Alpha Processor

Limen Alpha is a dual-core 16-bit RISC processor architecture with a hardware synchronization support between the cores. This repository includes it's implementation as a softcore processor described in VHDL. Currently a lot of the code is in it's original form, written 3 years ago and then used as part of my high school final work.

Currently I am intensively working on this project transition to format I am using now, see the list below.

## TODO list:
* remaster the following source files (the first iteration - code formatting):
  * [*core.vhd*](src/core.vhd) + [*core_tb.vhd*](sim/core_tb.vhd)
  * [*limen_alpha.vhd*](src/limen_alpha.vhd) + [*limen_alpha_tb.vhd*](sim/limen_alpha_tb.vhd)
  * [*limen_alpha_basys2.vhd*](impl/basys2/src/limen_alpha_basys2.vhd)
* remaster all VHDL module's files (the second iteration - light optimization, commenting)
* remaster all test bench files (create meaningful simulations, commenting)
* transfer documentation files
* transfer common software for the processor
* create a testing software for the basys2 implementation
* create a meaningful [*README.md*](README.md) file

## License

This project is licensed under the MIT License, see the [*LICENSE.txt*](LICENSE.txt) file for details.
