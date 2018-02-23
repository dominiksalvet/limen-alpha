--------------------------------------------------------------------------------
-- Standard:    VHDL-1993
-- Platform:    independent
-- Dependecies: none
--------------------------------------------------------------------------------
-- Description:
--------------------------------------------------------------------------------
-- Notes:
--------------------------------------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;


package alu_port is

    constant ALU_OR   : std_logic_vector(3 downto 0) := "0000";
    constant ALU_ORN  : std_logic_vector(3 downto 0) := "0001";
    constant ALU_AND  : std_logic_vector(3 downto 0) := "0010";
    constant ALU_ANDN : std_logic_vector(3 downto 0) := "0011";
    constant ALU_XOR  : std_logic_vector(3 downto 0) := "0100";
    constant ALU_SLL  : std_logic_vector(3 downto 0) := "0101";
    constant ALU_SRL  : std_logic_vector(3 downto 0) := "0110";
    constant ALU_SRA  : std_logic_vector(3 downto 0) := "0111";
    constant ALU_SLU  : std_logic_vector(3 downto 0) := "1000";
    constant ALU_SL   : std_logic_vector(3 downto 0) := "1001";
    constant ALU_SUB  : std_logic_vector(3 downto 0) := "1010";
    constant ALU_ADD  : std_logic_vector(3 downto 0) := "1011";
    constant ALU_L    : std_logic_vector(3 downto 0) := "1100";
    constant ALU_R    : std_logic_vector(3 downto 0) := "1101";
    constant ALU_LR   : std_logic_vector(3 downto 0) := "1110";
    constant ALU_RL   : std_logic_vector(3 downto 0) := "1111";

end package alu_port;


--------------------------------------------------------------------------------
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
-- The above copyright notice and this permission notice shall be included in
-- all copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.
--------------------------------------------------------------------------------
