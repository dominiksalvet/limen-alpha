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

use work.reg_file_port.all; -- reg_file_port.vhd


entity reg_file is
    port (
        clk : in std_logic;

        z_we    : in std_logic;
        z_index : in std_logic_vector(2 downto 0);
        z_data  : in std_logic_vector(15 downto 0);

        y_index : in  std_logic_vector(2 downto 0);
        y_data  : out std_logic_vector(15 downto 0);

        x_index : in  std_logic_vector(2 downto 0);
        x_data  : out std_logic_vector(15 downto 0)
        );
end entity reg_file;


architecture rtl of reg_file is

    constant REG_R0_RST : std_logic_vector(15 downto 0) := x"0000";

    type reg_array_t is array(7 downto 0) of std_logic_vector(15 downto 0);
    signal reg_array : reg_array_t := (
        0      => REG_R0_RST,
        others => (others => 'U')
        );

begin

    y_data <= reg_array(to_integer(unsigned(y_index)));
    x_data <= reg_array(to_integer(unsigned(x_index)));

    reg_array_write : process(clk)
    begin
        if (rising_edge(clk)) then
            if (z_we = '1' and z_index /= REG_R0) then
                reg_array(to_integer(unsigned(z_index))) <= z_data;
            end if;
        end if;
    end process reg_array_write;

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
