--------------------------------------------------------------------------------
-- Description:
--     Method of testing the module uses increasing freq_div to produce output
--     clock with less frequency than original one. Then there is a jump to the
--     fastest frequency and it should be sheen a very slow react (at the end of
--     output clock period).
--------------------------------------------------------------------------------
-- Notes:
--     1. Transition between any two freq_div must produce only output clock
--        periods so they are directly defined by freq_div and input clock.
--------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;

use work.clk_divider; -- clk_divider.vhd


entity clk_divider_tb is
end entity clk_divider_tb;


architecture behavior of clk_divider_tb is
    
    -- uut generics
    constant FREQ_DIV_MAX_VALUE : positive := 7;
    
    -- uut ports
    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
    
    signal freq_div : positive := 1;
    signal clk_out  : std_logic;
    
    -- clock period definition
    constant CLK_PERIOD : time := 10 ns;
    
begin
    
    -- instantiate the unit under test (uut)
    uut : entity work.clk_divider(rtl)
        generic map (
            FREQ_DIV_MAX_VALUE => FREQ_DIV_MAX_VALUE
        )
        port map (
            clk => clk,
            rst => rst,
            
            freq_div => freq_div,
            clk_out  => clk_out
        );
    
    -- Purpose: Clock process definition.
    clk_proc : process
    begin
        clk <= '0';
        wait for CLK_PERIOD / 2;
        clk <= '1';
        wait for CLK_PERIOD / 2;
    end process clk_proc;
    
    -- Purpose: Stimulus process.
    stim_proc : process
    begin
        
        rst <= '1'; -- initialize the module
        wait for 3 * CLK_PERIOD;
        
        rst <= '0';
        wait for 10 * CLK_PERIOD;
        
        freq_div <= 2;
        wait for 10 * CLK_PERIOD;
        
        freq_div <= 3;
        wait for 10 * CLK_PERIOD;
        
        freq_div <= 4;
        wait for 10 * CLK_PERIOD;
        
        freq_div <= 7;
        wait for 10 * CLK_PERIOD;
        
        -- make fast transition to very high frequency (react should be slow)
        freq_div <= 1;
        wait for 10 * CLK_PERIOD;
        
        freq_div <= 4;
        wait;
        
    end process stim_proc;
    
    -- Purpose: Control process.
    contr_proc : process
    begin
        
        -- asserting only at critical simulation times
        wait for 4.25 * CLK_PERIOD;
        
        assert (clk_out = clk)
            report "Expected inverse clk_out value!" severity error;
        wait for 0.5 * CLK_PERIOD;
        
        assert (clk_out = clk)
            report "Expected inverse clk_out value!" severity error;
        wait for 8.5 * CLK_PERIOD;
        
        assert (clk_out = '0')
            report "Expected inverse clk_out value!" severity error;
        wait for CLK_PERIOD;
        
        assert (clk_out = '1')
            report "Expected inverse clk_out value!" severity error;
        wait for CLK_PERIOD;
        
        assert (clk_out = '0')
            report "Expected inverse clk_out value!" severity error;
        wait for 11 * CLK_PERIOD;
        
        assert (clk_out = '0')
            report "Expected inverse clk_out value!" severity error;
        wait for CLK_PERIOD;
        
        assert (clk_out = '1')
            report "Expected inverse clk_out value!" severity error;
        wait for 26 * CLK_PERIOD;
        
        assert (clk_out = '1')
            report "Expected inverse clk_out value!" severity error;
        wait for 3.5 * CLK_PERIOD;
        
        assert (clk_out = '0')
            report "Expected inverse clk_out value!" severity error;
        wait;
        
    end process contr_proc;
    
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
