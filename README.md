# Limen Alpha

Limen Alpha is dual-core 16-bit RISC processor architecture with hardware synchronization support between the cores. This repository includes it's implementation as a softcore processor described in VHDL. Currently a lot of the code is in it's original form, written 3 years ago and then used as part of my high school final work.

Currently I am intensively working on this project transition to format I am using now, see the list below.

## TODO list:
* remaster the following source files:
  * [`alu.vhd`](src/alu.vhd) + [`alu_tb.vhd`](src/alu_tb.vhd)
  * [`alu_interf.vhd`](src/alu_interf.vhd)
  * [`alu_public.vhd`](src/alu_public.vhd)
  * [`core.vhd`](src/core.vhd)
  * [`core_public.vhd`](src/core_public.vhd)
  * [`jmp_tester.vhd`](src/jmp_tester.vhd) + [`jmp_tester_tb.vhd`](src/jmp_tester_tb.vhd)
  * [`jmp_tester_interf.vhd`](src/jmp_tester_interf.vhd)
  * [`limen_alpha.vhd`](src/limen_alpha.vhd)
  * [`reg_file.vhd`](src/reg_file.vhd) + [`reg_file_tb.vhd`](src/reg_file_tb.vhd)
  * [`reg_file_interf.vhd`](src/reg_file_interf.vhd)
  * [`sign_extend.vhd`](src/sign_extend.vhd) + [`sign_extend_tb.vhd`](src/sign_extend_tb.vhd)
  * [`limen_alpha_basys2.vhd`](impl/basys2/src/limen_alpha_basys2.vhd)
* create documentation files (also transfer the old ones)
* transfer common software for the processor
* create testing software for the basys2 implementation
* create meaningful [`README.md`](README.md)

## License

This project is licensed under the MIT License, see the [`LICENSE.txt`](LICENSE.txt) file for details.
