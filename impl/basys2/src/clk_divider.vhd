--------------------------------------------------------------------------------
-- Standard:    VHDL-1993
-- Platform:    independent
-- Dependecies: none
--------------------------------------------------------------------------------
-- Description:
--------------------------------------------------------------------------------
-- Notes:
--------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity clk_divider is
    generic (
        ONE_CLK_MODE  : boolean;
        COUNTER_WIDTH : positive
        );
    port (
        clk : in std_logic;
        rst : in std_logic;

        clk_div : in  std_logic_vector(COUNTER_WIDTH - 1 downto 0);
        clk_out : out std_logic
        );
end entity clk_divider;


architecture rtl of clk_divider is

    signal counter : std_logic_vector(COUNTER_WIDTH - 1 downto 0);

    signal clk_reg : std_logic;

begin

    clk_out <= clk_reg;

    count_clk : process(clk)
    begin
        if (rising_edge(clk)) then
            if (rst = '1') then
                counter <= clk_div;
                clk_reg <= '0';
            else

                if (counter = (COUNTER_WIDTH - 1 downto 0 => '0')) then
                    counter <= clk_div;
                    if (ONE_CLK_MODE) then
                        clk_reg <= '1';
                    else
                        clk_reg <= not clk_reg;
                    end if;
                else
                    counter <= std_logic_vector(unsigned(counter) - 1);
                    if (ONE_CLK_MODE) then
                        clk_reg <= '0';
                    end if;
                end if;

            end if;
        end if;
    end process count_clk;

end architecture rtl;


--------------------------------------------------------------------------------
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
