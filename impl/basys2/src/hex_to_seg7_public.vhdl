library ieee;
use ieee.std_logic_1164.all;


package hex_to_seg7_public is
    
    -- images of all seven segment values representing a hexadecimal number: ABCDEFG
    -- expecting '0' for turned on LED, '1' for turned off LED
    constant c_SEG7_0 : std_ulogic_vector(6 downto 0) := "0000001";
    constant c_SEG7_1 : std_ulogic_vector(6 downto 0) := "1001111";
    constant c_SEG7_2 : std_ulogic_vector(6 downto 0) := "0010010";
    constant c_SEG7_3 : std_ulogic_vector(6 downto 0) := "0000110";
    constant c_SEG7_4 : std_ulogic_vector(6 downto 0) := "1001100";
    constant c_SEG7_5 : std_ulogic_vector(6 downto 0) := "0100100";
    constant c_SEG7_6 : std_ulogic_vector(6 downto 0) := "0100000";
    constant c_SEG7_7 : std_ulogic_vector(6 downto 0) := "0001111";
    constant c_SEG7_8 : std_ulogic_vector(6 downto 0) := "0000000";
    constant c_SEG7_9 : std_ulogic_vector(6 downto 0) := "0000100";
    constant c_SEG7_A : std_ulogic_vector(6 downto 0) := "0001000";
    constant c_SEG7_B : std_ulogic_vector(6 downto 0) := "1100000";
    constant c_SEG7_C : std_ulogic_vector(6 downto 0) := "0110001";
    constant c_SEG7_D : std_ulogic_vector(6 downto 0) := "1000010";
    constant c_SEG7_E : std_ulogic_vector(6 downto 0) := "0110000";
    constant c_SEG7_F : std_ulogic_vector(6 downto 0) := "0111000";
    
end package hex_to_seg7_public;


--------------------------------------------------------------------------------
-- MIT License
--
-- Copyright (c) 2018 Dominik Salvet
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
