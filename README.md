# Limen Alpha Processor

Limen Alpha is a dual-core 16-bit RISC processor architecture with a hardware synchronization support between the cores. The original code was written 3 years ago and then succesfully used as part of my high school final work. However, it has changed since then a lot. The processor has been redesigned to make possible being a dual-core processor. Also a hardware interrupt driving has been added for both cores.

The work on processor itself is now finished. However, I am currently intensively working on this project transition to format I am using now, see the list below for details.

## To do list
* get the [VHDL Collection](https://github.com/dominiksalvet/vhdl_collection) repository to a consistent and stable state
* apply new conventions from previous point to this repository
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

This project is licensed under an Open Source Initiative approved license, the MIT License. See the [*LICENSE.txt*](LICENSE.txt) file for details. Individual files contain the SPDX license identifier instead of the full license text.

<p align="center">
  <a href="http://opensource.org/">
    <img src="https://opensource.org/files/osi_logo_bold_300X400_90ppi.png" width="100">
  </a>
</p>
