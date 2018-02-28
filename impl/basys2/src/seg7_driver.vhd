--------------------------------------------------------------------------------
-- Standard: VHDL-1993
-- Platform: independent
--------------------------------------------------------------------------------
-- Description:
--     Generic implementation of multiple seven segment displays driver.
--------------------------------------------------------------------------------
-- Notes:
--     1. This implementation uses seg7_sel signal to select active digit/s and
--        so it is meant to perform fast switching between the digits. Then the
--        final refresh frequency of all the display is equal to clk frequency
--        divided by number of unique digits.
--     2. The least significant bit of seg7_sel output accordinates the least
--        significant four bits of data_in input.
--     3. The input data_in is not stored anywhere internally to quickly react
--        to the changes on this input.
--------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;

use work.hex_to_seg7; -- hex_to_seg7.vhd


entity seg7_driver is
    generic (
        LED_ON_VALUE    : std_logic; -- LED on state represents this value
        DIGIT_SEL_VALUE : std_logic; -- digit select represents this value
        DIGIT_COUNT     : positive -- number of controlled digits
    );
    port (
        clk : in std_logic; -- clock signal
        rst : in std_logic; -- reset signal
        
        -- input data vector, will be treated as hexadecimal numbers (separated by 4 bits)
        data_in   : in  std_logic_vector((DIGIT_COUNT * 4) - 1 downto 0);
        seg7_sel  : out std_logic_vector(DIGIT_COUNT - 1 downto 0); -- seven segment selector bits
        seg7_data : out std_logic_vector(6 downto 0) -- actual seven segment digit data
    );
end entity seg7_driver;


architecture rtl of seg7_driver is
    
    -- hex_to_seg7_0 ports
    signal hts_hex_data  : std_logic_vector(3 downto 0);
    signal hts_seg7_data : std_logic_vector(6 downto 0);
    
    signal seg7_sel_index : natural range 0 to DIGIT_COUNT - 1; -- index of displayed digit
    
begin
    
    seg7_data <= hts_seg7_data xor (6 downto 0 => LED_ON_VALUE); -- LED on value switcher
    
    -- instantiation of hex_to_seg7 for conversion hexadecimal form to seven segment form
    hex_to_seg7_0 : entity work.hex_to_seg7(rtl)
        port map (
            hex_data  => hts_hex_data,
            seg7_data => hts_seg7_data
        );
    
    -- window with the converted hexadecimal number
    hts_hex_data <= data_in((seg7_sel_index * 4) + 3 downto (seg7_sel_index * 4));
    
    -- Inputs:  clk, seg7_sel_index, rst
    -- Outputs: seg7_sel_index
    -- Purpose: Compute next index of the seven segment digits.
    seg7_display_digit : process (clk)
    begin
        if (rising_edge(clk)) then
            
            if (rst = '1') then
                seg7_sel_index <= 0;
            else
                if (seg7_sel_index = DIGIT_COUNT - 1) then
                    seg7_sel_index <= 0;
                else
                    seg7_sel_index <= seg7_sel_index + 1;
                end if;
            end if;
            
        end if;
    end process seg7_display_digit;
    
    -- Outputs: seg7_sel
    -- Purpose: Propage changes of digit index to the seg7_sel output.
    seg7_sel_switch : process (seg7_sel_index)
    begin
        seg7_sel                 <= (others => not DIGIT_SEL_VALUE);
        seg7_sel(seg7_sel_index) <= DIGIT_SEL_VALUE;
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
