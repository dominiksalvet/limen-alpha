--------------------------------------------------------------------------------
-- Description:
--     Simulation represents an example where the message "cafe" will be
--     displayed. The seven segment display, which shows "E", has the lowest
--     index and so it is selected by "0001" value on seg7_sel output signal
--     (eventually "1110"). After 8*CLK_PERIOD, the message will be changed to
--     the "face".
--------------------------------------------------------------------------------
-- Notes:
--     1. Do not change DIGIT_COUNT unless you know the impact on the
--        simulation.
--------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;

use work.seg7_driver; -- seg7_driver.vhd


entity seg7_driver_tb is
end entity seg7_driver_tb;


architecture behavior of seg7_driver_tb is
    
    -- uut generics
    constant LED_ON_VALUE    : std_logic := '1';
    constant DIGIT_SEL_VALUE : std_logic := '1';
    constant DIGIT_COUNT     : positive  := 4;
    
    -- uut ports
    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
    
    signal data_in   : std_logic_vector((DIGIT_COUNT * 4) - 1 downto 0) := (others => '0');
    signal seg7_sel  : std_logic_vector(DIGIT_COUNT - 1 downto 0);
    signal seg7_data : std_logic_vector(6 downto 0);
    
    -- constants definitions for the "cafe" and "face" messages
    constant C_SEG7_FORM : std_logic_vector(6 downto 0) := "1001110";
    constant A_SEG7_FORM : std_logic_vector(6 downto 0) := "1110111";
    constant F_SEG7_FORM : std_logic_vector(6 downto 0) := "1000111";
    constant E_SEG7_FORM : std_logic_vector(6 downto 0) := "1001111";
    
    -- clock period definition
    constant CLK_PERIOD : time := 10 ns;
    
begin
    
    -- instantiate the unit under test (uut)
    uut : entity work.seg7_driver(rtl)
        generic map (
            LED_ON_VALUE    => LED_ON_VALUE,
            DIGIT_SEL_VALUE => DIGIT_SEL_VALUE,
            DIGIT_COUNT     => DIGIT_COUNT
        )
        port map (
            clk => clk,
            rst => rst,
            
            data_in   => data_in,
            seg7_sel  => seg7_sel,
            seg7_data => seg7_data
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
        
        rst     <= '1'; -- initialize the module
        data_in <= x"cafe";
        wait for CLK_PERIOD;
        
        rst <= '0';
        wait for 7 * CLK_PERIOD;
        
        data_in <= x"face";
        wait;
        
    end process stim_proc;
    
    -- Purpose: Control process.
    contr_proc : process
    begin
        
        wait for CLK_PERIOD;
        
        -- "cafe" message
        assert (seg7_data = (E_SEG7_FORM xor (6 downto 0 => not LED_ON_VALUE)))
            report "Invalid data sent to the seg7_data output!" severity error;
        wait for CLK_PERIOD;
        
        assert (seg7_data = (F_SEG7_FORM xor (6 downto 0 => not LED_ON_VALUE)))
            report "Invalid data sent to the seg7_data output!" severity error;
        wait for CLK_PERIOD;
        
        assert (seg7_data = (A_SEG7_FORM xor (6 downto 0 => not LED_ON_VALUE)))
            report "Invalid data sent to the seg7_data output!" severity error;
        wait for CLK_PERIOD;
        
        assert (seg7_data = (C_SEG7_FORM xor (6 downto 0 => not LED_ON_VALUE)))
            report "Invalid data sent to the seg7_data output!" severity error;
        wait for 5 * CLK_PERIOD; -- need to wait 9*CLK_PERIOD until the "face" message starts
        
        -- "face" message
        assert (seg7_data = (E_SEG7_FORM xor (6 downto 0 => not LED_ON_VALUE)))
            report "Invalid data sent to the seg7_data output!" severity error;
        wait for CLK_PERIOD;
        
        assert (seg7_data = (C_SEG7_FORM xor (6 downto 0 => not LED_ON_VALUE)))
            report "Invalid data sent to the seg7_data output!" severity error;
        wait for CLK_PERIOD;
        
        assert (seg7_data = (A_SEG7_FORM xor (6 downto 0 => not LED_ON_VALUE)))
            report "Invalid data sent to the seg7_data output!" severity error;
        wait for CLK_PERIOD;
        
        assert (seg7_data = (F_SEG7_FORM xor (6 downto 0 => not LED_ON_VALUE)))
            report "Invalid data sent to the seg7_data output!" severity error;
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
