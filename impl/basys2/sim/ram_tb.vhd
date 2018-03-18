--------------------------------------------------------------------------------
-- Description:
--     First write the data to the memory with respect of the following pattern
--     address=data. Then the simulation will verify the correct memory data by
--     sequential reading the memory addresses.
--------------------------------------------------------------------------------
-- Notes:
--     1. To verify the module by its current implementation, it is required
--        2^(n+1) steps where n=g_ADDR_WIDTH.
--------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.ram; -- ram.vhd


entity ram_tb is
end entity ram_tb;


architecture behavior of ram_tb is
    
    -- uut generics
    constant g_ADDR_WIDTH : positive := 4;
    constant g_DATA_WIDTH : positive := 8;
    
    -- uut ports
    signal i_clk : std_logic := '0';
    
    signal i_we   : std_logic                                   := '0';
    signal i_re   : std_logic                                   := '0';
    signal i_addr : std_logic_vector(g_ADDR_WIDTH - 1 downto 0) := (others => '0');
    signal i_data : std_logic_vector(g_DATA_WIDTH - 1 downto 0) := (others => '0');
    signal o_data : std_logic_vector(g_DATA_WIDTH - 1 downto 0);
    
    -- clock period definition
    constant c_CLK_PERIOD : time := 10 ns;
    
begin
    
    -- instantiate the unit under test (uut)
    uut : entity work.ram(rtl)
        generic map (
            g_ADDR_WIDTH => g_ADDR_WIDTH,
            g_DATA_WIDTH => g_DATA_WIDTH
        )
        port map (
            i_clk => i_clk,
            
            i_we   => i_we,
            i_re   => i_re,
            i_addr => i_addr,
            i_data => i_data,
            o_data => o_data
        );
    
    i_clk <= not i_clk after c_CLK_PERIOD / 2; -- setup i_clk as periodic signal
    
    stimulus : process is
    begin
        
        -- write to every address it's value
        i_we <= '1';
        for i in 0 to (2 ** g_ADDR_WIDTH) - 1 loop
            i_addr <= std_logic_vector(to_unsigned(i, i_addr'length));
            i_data <= std_logic_vector(to_unsigned(i, i_data'length));
            wait for c_CLK_PERIOD;
        end loop;
        
        i_we <= '0';
        -- read each address and verify it's data correctness
        i_re <= '1';
        for i in 0 to (2 ** g_ADDR_WIDTH) - 1 loop
            i_addr <= std_logic_vector(to_unsigned(i, i_addr'length));
            wait for c_CLK_PERIOD; -- wait for i_clk rising edge to read the desired data
            
            -- asserting to verify the RAM module function
            assert (o_data = std_logic_vector(to_unsigned(i, o_data'length)))
                report "The read data does not match pattern address=data!" severity error;
        end loop;
        wait;
        
    end process stimulus;
    
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
