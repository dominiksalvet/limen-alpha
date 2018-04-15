--------------------------------------------------------------------------------
-- Standard: VHDL-1993
-- Platform: independent
--------------------------------------------------------------------------------
-- Description:
--------------------------------------------------------------------------------
-- Notes:
--------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.reg_file_interf.all;


entity reg_file is
    port (
        i_clk : in std_ulogic;
        
        i_z_we    : in std_ulogic;
        i_z_index : in std_ulogic_vector(2 downto 0);
        i_z_data  : in std_ulogic_vector(15 downto 0);
        
        i_y_index : in  std_ulogic_vector(2 downto 0);
        o_y_data  : out std_ulogic_vector(15 downto 0);
        
        i_x_index : in  std_ulogic_vector(2 downto 0);
        o_x_data  : out std_ulogic_vector(15 downto 0)
    );
end entity reg_file;


architecture rtl of reg_file is
    
    constant c_REG_R0_VALUE : std_ulogic_vector(15 downto 0) := x"0000";
    
    type t_REGISTERS is array(0 to 7) of std_ulogic_vector(15 downto 0);
    signal r_registers : t_REGISTERS := (
        0      => c_REG_R0_VALUE,
        others => (others => 'U')
        );
    
begin
    
    o_y_data <= r_registers(to_integer(unsigned(i_y_index)));
    o_x_data <= r_registers(to_integer(unsigned(i_x_index)));
    
    registers_write : process (i_clk) is
    begin
        if (rising_edge(i_clk)) then
            if (i_z_we = '1' and i_z_index /= c_REG_R0) then
                r_registers(to_integer(unsigned(i_z_index))) <= i_z_data;
            end if;
        end if;
    end process registers_write;
    
end architecture rtl;


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
