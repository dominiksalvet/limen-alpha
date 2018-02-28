--------------------------------------------------------------------------------
-- Description:
--     First write the data to the memory with respect of the following pattern
--     address=data. Then the simulation will verify the correct memory data by
--     sequential reading the memory addresses.
--------------------------------------------------------------------------------
-- Notes:
--     1. To verify the module by its current implemetantion, it is required
--        2^(n+1) steps where n=ADDR_WIDTH.
--------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ram; -- ram.vhd


entity ram_tb is
end entity ram_tb;


architecture behavior of ram_tb is
    
    -- uut generics
    constant ADDR_WIDTH : positive := 4;
    constant DATA_WIDTH : positive := 8;
    
    -- uut ports
    signal clk : std_logic := '0';
    
    signal we       : std_logic                                 := '0';
    signal re       : std_logic                                 := '0';
    signal addr     : std_logic_vector(ADDR_WIDTH - 1 downto 0) := (others => '0');
    signal data_in  : std_logic_vector(DATA_WIDTH - 1 downto 0) := (others => '0');
    signal data_out : std_logic_vector(DATA_WIDTH - 1 downto 0);
    
    -- clock period definition
    constant CLK_PERIOD : time := 10 ns;
    
begin
    
    -- instantiate the unit under test (uut)
    uut : entity work.ram(rtl)
        generic map (
            ADDR_WIDTH => ADDR_WIDTH,
            DATA_WIDTH => DATA_WIDTH
        )
        port map (
            clk => clk,
            
            we       => we,
            re       => re,
            addr     => addr,
            data_in  => data_in,
            data_out => data_out
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
        
        -- write to every address it's value
        we <= '1';
        for i in 0 to (2 ** ADDR_WIDTH) - 1 loop
            addr    <= std_logic_vector(to_unsigned(i, ADDR_WIDTH));
            data_in <= std_logic_vector(to_unsigned(i, DATA_WIDTH));
            wait for CLK_PERIOD;
        end loop;
        
        we <= '0';
        -- read each address and verify it's data correctness
        re <= '1';
        for i in 0 to (2 ** ADDR_WIDTH) - 1 loop
            addr <= std_logic_vector(to_unsigned(i, ADDR_WIDTH));
            wait for CLK_PERIOD; -- wait for clk rising edge to read the desired data

            -- asserting to verify the ram module function
            assert (data_out = std_logic_vector(to_unsigned(i, DATA_WIDTH)))
                report "The read data does not match pattern address=data!" severity error;
        end loop;
        
        wait;
        
    end process stim_proc;
    
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
