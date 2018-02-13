library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity ram is
    generic (
        ADDR_WIDTH : positive;
        DATA_WIDTH : positive
        );
    port (
        clk : in std_logic;

        we       : in  std_logic;
        re       : in  std_logic;
        addr     : in  std_logic_vector(ADDR_WIDTH - 1 downto 0);
        data_in  : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
        data_out : out std_logic_vector(DATA_WIDTH - 1 downto 0)
        );
end entity ram;


architecture rtl of ram is

    type rwm_array_t is array((2 ** ADDR_WIDTH) - 1 downto 0) of std_logic_vector(DATA_WIDTH - 1 downto 0);
    signal rwm_array : rwm_array_t;

begin

    rwm_array_read_write : process(clk)
    begin
        if (rising_edge(clk)) then

            if (re = '1') then
                data_out <= rwm_array(to_integer(unsigned(addr)));
            end if;

            if (we = '1') then
                rwm_array(to_integer(unsigned(addr))) <= data_in;
            end if;

        end if;
    end process rwm_array_read_write;

end architecture rtl;


---------------------------------------------------------------------------------
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
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.
---------------------------------------------------------------------------------
