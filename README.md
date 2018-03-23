# Limen Alpha

Limen Alpha is dual-core 16-bit RISC processor architecture with hardware synchronization support between the cores. This repository includes it's implementation as a softcore processor described in VHDL. Currently a lot of the code is in it's original form, written 3 years ago and then used as part of my high school final work.

Currently I am intensively working on this project transition to format I am using now, see the list below.

## TODO list:
* remaster the following source files (first iteration - everything except advanced optimization and commenting):
  * [`alu.vhd`](src/alu.vhd) + [`alu_tb.vhd`](src/alu_tb.vhd)
  * [`alu_interf.vhd`](src/alu_interf.vhd)
  * [`alu_public.vhd`](src/alu_public.vhd)
  * [`core.vhd`](src/core.vhd)
  * [`jmp_tester.vhd`](src/jmp_tester.vhd) + [`jmp_tester_tb.vhd`](src/jmp_tester_tb.vhd)
  * [`jmp_tester_interf.vhd`](src/jmp_tester_interf.vhd)
  * [`limen_alpha.vhd`](src/limen_alpha.vhd)
  * [`limen_alpha_basys2.vhd`](impl/basys2/src/limen_alpha_basys2.vhd)
* transfer more simulation files (core_tb.vhd, limen_alpha_tb.vhd)
* create documentation files (also transfer the old ones)
* transfer common software for the processor
* create testing software for the basys2 implementation
* create meaningful [`README.md`](README.md)

## License

This project is licensed under the MIT License, see the [`LICENSE.txt`](LICENSE.txt) file for details.
