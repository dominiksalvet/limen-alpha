--------------------------------------------------------------------------------
-- Standard: VHDL-1993
-- Platform: independent
--------------------------------------------------------------------------------
-- Description:
--     Converter from hexadecimal data to seven segment data.
--------------------------------------------------------------------------------
-- Notes:
--     1. If the output seg7_data signal is propaged to LEDs, it is required to
--        respects the LEDs on/off value and inverse the signal eventually.
--     2. This implementation assumes LED on state as '0' value and LED off
--        state as '1' value.
--------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;


entity hex_to_seg7 is
    port (
        hex_data  : in  std_logic_vector(3 downto 0); -- 4-bit data as encoded hexadecimal number
        seg7_data : out std_logic_vector(6 downto 0) -- 7-bit sigment data, bit per each segment
    );
end entity hex_to_seg7;


architecture rtl of hex_to_seg7 is
    
    -- images of all seven segment values representing a hexadecimal number: ABCDEFG
    constant SEG7_0 : std_logic_vector(6 downto 0) := "0000001";
    constant SEG7_1 : std_logic_vector(6 downto 0) := "1001111";
    constant SEG7_2 : std_logic_vector(6 downto 0) := "0010010";
    constant SEG7_3 : std_logic_vector(6 downto 0) := "0000110";
    constant SEG7_4 : std_logic_vector(6 downto 0) := "1001100";
    constant SEG7_5 : std_logic_vector(6 downto 0) := "0100100";
    constant SEG7_6 : std_logic_vector(6 downto 0) := "0100000";
    constant SEG7_7 : std_logic_vector(6 downto 0) := "0001111";
    constant SEG7_8 : std_logic_vector(6 downto 0) := "0000000";
    constant SEG7_9 : std_logic_vector(6 downto 0) := "0000100";
    constant SEG7_A : std_logic_vector(6 downto 0) := "0001000";
    constant SEG7_B : std_logic_vector(6 downto 0) := "1100000";
    constant SEG7_C : std_logic_vector(6 downto 0) := "0110001";
    constant SEG7_D : std_logic_vector(6 downto 0) := "1000010";
    constant SEG7_E : std_logic_vector(6 downto 0) := "0110000";
    constant SEG7_F : std_logic_vector(6 downto 0) := "0111000";
    
begin
    
    -- hexadecimal to seven segment conversion implementation
    with hex_data select seg7_data <= 
        SEG7_0          when "0000",
        SEG7_1          when "0001",
        SEG7_2          when "0010",
        SEG7_3          when "0011",
        SEG7_4          when "0100",
        SEG7_5          when "0101",
        SEG7_6          when "0110",
        SEG7_7          when "0111",
        SEG7_8          when "1000",
        SEG7_9          when "1001",
        SEG7_A          when "1010",
        SEG7_B          when "1011",
        SEG7_C          when "1100",
        SEG7_D          when "1101",
        SEG7_E          when "1110",
        SEG7_F          when "1111",
        (others => 'X') when others;
    
end architecture rtl;


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
