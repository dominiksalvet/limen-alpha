--------------------------------------------------------------------------------
-- Standard: VHDL-1993
-- Platform: independent
--------------------------------------------------------------------------------
-- Description:
--     This source file represents a generic implementation of a clock divider.
--     It supports to dynamically change frequency divisor, including 1 value.
--     While changing i_freq_div value, there does not exist an interval, where
--     output clock period is not defined one of the assigned i_freq_div values.
--------------------------------------------------------------------------------
-- Notes:
--     1. For static clock divide, use static_clk_divider as it has lower
--        requirements of hardware resources.
--     2. Period of output o_clk starts with '1' value, followed by '0'.
--     3. When it is not possible to perform clock frequency division without
--        a remainder, the o_clk will have '1' value one i_clk period shorter
--        than '0' value per o_clk period.
--     4. To get the most effective optimization, choose g_FREQ_DIV_MAX_VALUE
--        equal to (2^n)-1.
--------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity clk_divider is
    generic (
        g_FREQ_DIV_MAX_VALUE : positive := 7 -- maximum available frequency divisor value
    );
    port (
        i_clk : in std_ulogic; -- input clock signal
        i_rst : in std_ulogic; -- reset signal
        
        -- i_clk frequency is divided by value of this number, <o_clk_freq>=<i_clk_freq>/i_freq_div
        i_freq_div : in  positive range 1 to g_FREQ_DIV_MAX_VALUE;
        o_clk      : out std_ulogic -- final output clock
    );
end entity clk_divider;


architecture rtl of clk_divider is
    
    signal r_use_direct_i_clk : std_ulogic; -- force to use direct i_clk input as output clock
    signal r_divided_i_clk    : std_ulogic; -- value of i_clk based on counter method
    
begin
    
    -- switch between direct i_clk and r_divided_i_clk
    o_clk <= i_clk when r_use_direct_i_clk = '1' else r_divided_i_clk;
    
    -- Description:
    --     Performs i_clk frequency division, outputs need to be composed to get the final clock.
    divide_i_clk_freq : process (i_clk) is
        -- register to store internally i_freq_div value in a time
        variable r_freq_div : positive range 1 to g_FREQ_DIV_MAX_VALUE;
        -- internal i_clk counter
        variable r_i_clk_counter : positive range 1 to g_FREQ_DIV_MAX_VALUE;
    begin
        if (rising_edge(i_clk)) then
            -- need to reset the r_i_clk_counter and begin the new o_clk period
            if (i_rst = '1' or r_i_clk_counter = r_freq_div) then
                
                -- when i_freq_div is 1, then it needs to be used direct i_clk
                if (i_freq_div = 1) then
                    r_use_direct_i_clk <= not i_rst;
                else
                    r_use_direct_i_clk <= '0';
                end if;
                
                r_divided_i_clk <= '1'; -- when i_rst is '1', then final clock should be '0'
                r_freq_div      := i_freq_div; -- internal register to store a reference value
                r_i_clk_counter := 1; -- reset the i_clk signal counter
                
            else
                
                if (r_i_clk_counter = (r_freq_div / 2)) then -- half of the o_clk period
                    r_divided_i_clk <= '0';
                end if;
                
                r_i_clk_counter := r_i_clk_counter + 1; -- counting i_clk rising edges
                
            end if;
        end if;
    end process divide_i_clk_freq;
    
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
