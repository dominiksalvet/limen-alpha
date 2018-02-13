library ieee;
use ieee.std_logic_1164.all;


package core_shared is

    constant OPCODE_ASIMM  : std_logic_vector(2 downto 0) := "000";
    constant OPCODE_TSIMM  : std_logic_vector(2 downto 0) := "001";
    constant OPCODE_LIMM   : std_logic_vector(2 downto 0) := "010";
    constant OPCODE_ALREG  : std_logic_vector(2 downto 0) := "011";
    constant OPCODE_LDIMM  : std_logic_vector(2 downto 0) := "100";
    constant OPCODE_CJSIMM : std_logic_vector(2 downto 0) := "101";
    constant OPCODE_JSIMM  : std_logic_vector(2 downto 0) := "110";
    constant OPCODE_JREG   : std_logic_vector(2 downto 0) := "111";

    constant INST_NOP : std_logic_vector(15 downto 0) := x"6000";

end package core_shared;


---------------------------------------------------------------------------------
-- MIT License
--
-- Copyright (c) 2015-2018 Dominik Salvet
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.
---------------------------------------------------------------------------------
