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
    signal i_clk : std_logic := '0';
    
    signal i_z_we    : std_logic                     := '0';
    signal i_z_index : std_logic_vector(2 downto 0)  := (others => '0');
    signal i_z_data  : std_logic_vector(15 downto 0) := (others => '0');
    
    signal i_y_index : std_logic_vector(2 downto 0) := (others => '0');
    signal o_y_data  : std_logic_vector(15 downto 0);
    
    signal i_x_index : std_logic_vector(2 downto 0) := (others => '0');
    signal o_x_data  : std_logic_vector(15 downto 0);
    
    -- clock period definition
    constant c_CLK_PERIOD : time := 10 ns;
    
begin
    
    -- instantiate the unit under test (uut)
    uut : entity work.reg_file(rtl)
        port map (
            i_clk => i_clk,
            
            i_z_we    => i_z_we,
            i_z_index => i_z_index,
            i_z_data  => i_z_data,
            
            i_y_index => i_y_index,
            o_y_data  => o_y_data,
            
            i_x_index => i_x_index,
            o_x_data  => o_x_data
        );
    
    i_clk <= not i_clk after c_CLK_PERIOD / 2; -- setup i_clk as periodic signal
    
    stimulus : process is
    begin
        loop
            wait for c_CLK_PERIOD;
            
            i_z_index <= std_logic_vector(unsigned(i_z_index) + 1);
            i_z_data  <= std_logic_vector(unsigned(i_z_data) + 1);
            i_y_index <= std_logic_vector(unsigned(i_y_index) + 3);
            i_x_index <= std_logic_vector(unsigned(i_y_index) + 5);
            
            if (i_z_index = c_REG_R0) then
                z_wr_en <= not z_wr_en;
            end if;
        end loop;
    end process stimulus;
    
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
