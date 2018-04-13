--------------------------------------------------------------------------------
-- Standard: VHDL-1993
-- Platform: independent
--------------------------------------------------------------------------------
-- Description:
--     Generic implementation of multiple seven segment displays driver.
--------------------------------------------------------------------------------
-- Notes:
--     1. This implementation uses o_seg7_sel signal to select active digit/s
--        and so it is meant to perform fast switching between the digits. Then
--        the final refresh frequency of all the display is equal to i_clk
--        frequency divided by number of unique digits.
--     2. The least significant bit of o_seg7_sel output accordinates the least
--        significant four bits of i_data input.
--     3. The input i_data is not stored anywhere internally to quickly react to
--        the changes on this input.
--------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;

use work.hex_to_seg7; -- hex_to_seg7.vhd


entity seg7_driver is
    generic (
        g_LED_ON_VALUE    : std_ulogic := '1'; -- LED on state represents this value
        g_DIGIT_SEL_VALUE : std_ulogic := '1'; -- digit select represents this value
        g_DIGIT_COUNT     : positive  := 4 -- number of controlled digits
    );
    port (
        i_clk : in std_ulogic; -- clock signal
        i_rst : in std_ulogic; -- reset signal
        
        -- input data vector, will be treated as hexadecimal numbers (separated by 4 bits)
        i_data      : in  std_ulogic_vector((g_DIGIT_COUNT * 4) - 1 downto 0);
        o_seg7_sel  : out std_ulogic_vector(g_DIGIT_COUNT - 1 downto 0); -- seven segment select bits
        o_seg7_data : out std_ulogic_vector(6 downto 0) -- actual seven segment digit data
    );
end entity seg7_driver;


architecture rtl of seg7_driver is
    
    -- i0_hex_to_seg7 ports
    signal hts_i_hex_data  : std_ulogic_vector(3 downto 0);
    signal hts_o_seg7_data : std_ulogic_vector(6 downto 0);
    
    signal r_seg7_sel_index : natural range 0 to g_DIGIT_COUNT - 1; -- index of displayed digit
    
begin
    
    o_seg7_data <= hts_o_seg7_data xor (6 downto 0 => g_LED_ON_VALUE); -- LED on value switcher
    
    -- instantiation of hex_to_seg7 for conversion hexadecimal form to seven segment form
    i0_hex_to_seg7 : entity work.hex_to_seg7(rtl)
        port map (
            i_hex_data  => hts_i_hex_data,
            o_seg7_data => hts_o_seg7_data
        );
    
    -- window with the converted hexadecimal number
    hts_i_hex_data <= i_data((r_seg7_sel_index * 4) + 3 downto (r_seg7_sel_index * 4));
    
    -- Description:
    --     Compute next index of the seven segment digits.
    compute_next_index : process (i_clk) is
    begin
        if (rising_edge(i_clk)) then
            if (i_rst = '1') then
                r_seg7_sel_index <= 0;
            else
                
                if (r_seg7_sel_index = g_DIGIT_COUNT - 1) then
                    r_seg7_sel_index <= 0;
                else
                    r_seg7_sel_index <= r_seg7_sel_index + 1;
                end if;
                
            end if;
        end if;
    end process compute_next_index;
    
    -- Description:
    --     Propagate changes of digit index to the o_seg7_sel output.
    seg7_sel_switch : process (r_seg7_sel_index) is
    begin
        o_seg7_sel                   <= (others => not g_DIGIT_SEL_VALUE);
        o_seg7_sel(r_seg7_sel_index) <= g_DIGIT_SEL_VALUE;
    end process seg7_sel_switch;
    
end architecture rtl;


--------------------------------------------------------------------------------
-- MIT License
--
-- Copyright (c) 2016-2018 Dominik Salvet
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
