library ieee;
use ieee.std_logic_1164.all;


package alu_interf is
    
    constant c_ALU_OR   : std_ulogic_vector(3 downto 0) := "0000";
    constant c_ALU_ORN  : std_ulogic_vector(3 downto 0) := "0001";
    constant c_ALU_AND  : std_ulogic_vector(3 downto 0) := "0010";
    constant c_ALU_ANDN : std_ulogic_vector(3 downto 0) := "0011";
    constant c_ALU_XOR  : std_ulogic_vector(3 downto 0) := "0100";
    constant c_ALU_SLL  : std_ulogic_vector(3 downto 0) := "0101";
    constant c_ALU_SRL  : std_ulogic_vector(3 downto 0) := "0110";
    constant c_ALU_SRA  : std_ulogic_vector(3 downto 0) := "0111";
    constant c_ALU_SLU  : std_ulogic_vector(3 downto 0) := "1000";
    constant c_ALU_SL   : std_ulogic_vector(3 downto 0) := "1001";
    constant c_ALU_SUB  : std_ulogic_vector(3 downto 0) := "1010";
    constant c_ALU_ADD  : std_ulogic_vector(3 downto 0) := "1011";
    constant c_ALU_L    : std_ulogic_vector(3 downto 0) := "1100";
    constant c_ALU_R    : std_ulogic_vector(3 downto 0) := "1101";
    constant c_ALU_LR   : std_ulogic_vector(3 downto 0) := "1110";
    constant c_ALU_RL   : std_ulogic_vector(3 downto 0) := "1111";
    
end package alu_interf;


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
