--------------------------------------------------------------------------------
-- Standard: VHDL-1993
-- Platform: independent
--------------------------------------------------------------------------------
-- Description:
--     Converter from hexadecimal data to seven segment data.
--------------------------------------------------------------------------------
-- Notes:
--     1. If the output o_seg7_data signal is wired to LEDs, it is required to
--        respect the LEDs on/off value and inverse the signal eventually.
--     2. This implementation assumes LED on state as '0' value and LED off
--        state as '1' value.
--------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;

use work.hex_to_seg7_public.all;


entity hex_to_seg7 is
    port (
        i_hex_data  : in  std_ulogic_vector(3 downto 0); -- 4-bit data as encoded hexadecimal number
        o_seg7_data : out std_ulogic_vector(6 downto 0) -- 7-bit segment data, bit per each segment
    );
end entity hex_to_seg7;


architecture rtl of hex_to_seg7 is
begin
    
    -- hexadecimal to seven segment conversion implementation
    with i_hex_data select o_seg7_data <= 
        c_SEG7_0        when "0000",
        c_SEG7_1        when "0001",
        c_SEG7_2        when "0010",
        c_SEG7_3        when "0011",
        c_SEG7_4        when "0100",
        c_SEG7_5        when "0101",
        c_SEG7_6        when "0110",
        c_SEG7_7        when "0111",
        c_SEG7_8        when "1000",
        c_SEG7_9        when "1001",
        c_SEG7_A        when "1010",
        c_SEG7_B        when "1011",
        c_SEG7_C        when "1100",
        c_SEG7_D        when "1101",
        c_SEG7_E        when "1110",
        c_SEG7_F        when "1111",
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
