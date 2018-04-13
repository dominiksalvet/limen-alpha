--------------------------------------------------------------------------------
-- Description:
--     Method of testing the module uses increasing i_freq_div to produce output
--     clock with less frequency than original one. Then there is a jump to the
--     fastest frequency and it should be sheen a very slow react (at the end of
--     output clock period).
--------------------------------------------------------------------------------
-- Notes:
--     1. Transition between any two i_freq_div must produce only output clock
--        periods so they are directly defined by i_freq_div and input clock.
--------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;

use work.clk_divider; -- clk_divider.vhd


entity clk_divider_tb is
end entity clk_divider_tb;


architecture behavior of clk_divider_tb is
    
    -- uut generics
    constant g_FREQ_DIV_MAX_VALUE : positive := 7;
    
    -- uut ports
    signal i_clk : std_ulogic := '0';
    signal i_rst : std_ulogic := '0';
    
    signal i_freq_div : positive := 1;
    signal o_clk      : std_ulogic;
    
    -- clock period definition
    constant c_CLK_PERIOD : time := 10 ns;
    
begin
    
    -- instantiate the unit under test (uut)
    uut : entity work.clk_divider(rtl)
        generic map (
            g_FREQ_DIV_MAX_VALUE => g_FREQ_DIV_MAX_VALUE
        )
        port map (
            i_clk => i_clk,
            i_rst => i_rst,
            
            i_freq_div => i_freq_div,
            o_clk      => o_clk
        );
    
    i_clk <= not i_clk after c_CLK_PERIOD / 2; -- setup i_clk as periodic signal
    
    stimulus : process is
    begin
        
        i_rst <= '1'; -- initialize the module
        wait for 3 * c_CLK_PERIOD;
        
        i_rst <= '0';
        wait for 10 * c_CLK_PERIOD;
        
        i_freq_div <= 2;
        wait for 10 * c_CLK_PERIOD;
        
        i_freq_div <= 3;
        wait for 10 * c_CLK_PERIOD;
        
        i_freq_div <= 4;
        wait for 10 * c_CLK_PERIOD;
        
        i_freq_div <= 7;
        wait for 10 * c_CLK_PERIOD;
        
        -- make an instant transition to very high frequency (react should be delayed)
        i_freq_div <= 1;
        wait for 10 * c_CLK_PERIOD;
        
        i_freq_div <= 4;
        wait;
        
    end process stimulus;
    
    verification : process is
    begin
        
        -- asserting only at critical simulation times
        wait for 4.25 * c_CLK_PERIOD;
        
        assert (o_clk = i_clk)
            report "Expected inverse o_clk value!" severity error;
        wait for 0.5 * c_CLK_PERIOD;
        
        assert (o_clk = i_clk)
            report "Expected inverse o_clk value!" severity error;
        wait for 8.5 * c_CLK_PERIOD;
        
        assert (o_clk = '0')
            report "Expected inverse o_clk value!" severity error;
        wait for c_CLK_PERIOD;
        
        assert (o_clk = '1')
            report "Expected inverse o_clk value!" severity error;
        wait for c_CLK_PERIOD;
        
        assert (o_clk = '0')
            report "Expected inverse o_clk value!" severity error;
        wait for 11 * c_CLK_PERIOD;
        
        assert (o_clk = '0')
            report "Expected inverse o_clk value!" severity error;
        wait for c_CLK_PERIOD;
        
        assert (o_clk = '1')
            report "Expected inverse o_clk value!" severity error;
        wait for 26 * c_CLK_PERIOD;
        
        assert (o_clk = '1')
            report "Expected inverse o_clk value!" severity error;
        wait for 3.5 * c_CLK_PERIOD;
        
        assert (o_clk = '0')
            report "Expected inverse o_clk value!" severity error;
        wait;
        
    end process verification;
    
end architecture behavior;


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
