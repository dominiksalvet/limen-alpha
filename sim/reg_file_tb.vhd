--------------------------------------------------------------------------------
-- Description:
--------------------------------------------------------------------------------
-- Notes:
--------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.reg_file; -- reg_file.vhd
use work.reg_file_interf.all; -- reg_file_interf.vhd


entity reg_file_tb is
end entity reg_file_tb;


architecture behavior of reg_file_tb is
    
    -- uut ports
    signal clk : std_logic := '0';
    
    signal z_we    : std_logic                     := '0';
    signal z_index : std_logic_vector(2 downto 0)  := (others => '0');
    signal z_data  : std_logic_vector(15 downto 0) := (others => '0');
    
    signal y_index : std_logic_vector(2 downto 0) := (others => '0');
    signal y_data  : std_logic_vector(15 downto 0);
    
    signal x_index : std_logic_vector(2 downto 0) := (others => '0');
    signal x_data  : std_logic_vector(15 downto 0);
    
    -- clock period definition
    constant CLK_PERIOD : time := 10 ns;
    
begin
    
    -- instantiate the unit under test (uut)
    uut : entity work.reg_file(rtl)
        port map (
            clk => clk,
            
            z_we    => z_we,
            z_index => z_index,
            z_data  => z_data,
            
            y_index => y_index,
            y_data  => y_data,
            
            x_index => x_index,
            x_data  => x_data
        );
    
    -- Purpose: Clock process definition.
    clk_proc : process
    begin
        clk <= '0';
        wait for CLK_PERIOD / 2;
        clk <= '1';
        wait for CLK_PERIOD / 2;
    end process;
    
    -- Purpose: Stimulus process.
    stim_proc : process
    begin
        
        loop
            
            wait for 10 ns;
            
            z_index <= std_logic_vector(unsigned(z_index) + 1);
            z_data  <= std_logic_vector(unsigned(z_data) + 1);
            y_index <= std_logic_vector(unsigned(y_index) + 3);
            x_index <= std_logic_vector(unsigned(y_index) + 5);
            
            if (z_index = REG_R0) then
                z_wr_en <= not z_wr_en;
            end if;
            
        end loop;
        
    end process;
    
end architecture behavior;


--------------------------------------------------------------------------------
-- MIT License
--
-- Copyright (c) 2015-2018 Dominik Salvet
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
