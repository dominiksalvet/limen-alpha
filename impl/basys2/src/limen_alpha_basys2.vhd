library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity limen_alpha_basys2 is
    generic (
        RWM_ADDR_WIDTH       : positive := 8;
        LA_CLK_COUNTER_WIDTH : positive := 18
        );
    port (
        clk   : in std_logic;
        rst   : in std_logic;
        irq_0 : in std_logic;
        irq_1 : in std_logic
        );
end entity limen_alpha_basys2;


architecture rtl of limen_alpha_basys2 is

    signal la_clk      : std_logic;
    signal la_mem_in   : std_logic_vector(15 downto 0);
    signal la_mem_we   : std_logic;
    signal la_mem_addr : std_logic_vector(15 downto 0);
    signal la_mem_out  : std_logic_vector(15 downto 0);

begin

    clk_divider_la : entity work.clk_divider(rtl)
        generic map (
            ONE_CLK_MODE  => false,
            COUNTER_WIDTH => LA_CLK_COUNTER_WIDTH
            )
        port map (
            clk => clk,
            rst => rst,

            clk_div => std_logic_vector(to_unsigned(200_000, LA_CLK_COUNTER_WIDTH)),
            clk_out => la_clk
            );

    limen_alpha_0 : entity work.limen_alpha(rtl)
        port map (
            clk   => la_clk,
            rst   => rst,
            irq_0 => irq_0,
            irq_1 => irq_1,

            mem_in   => la_mem_in,
            mem_we   => la_mem_we,
            mem_addr => la_mem_addr,
            mem_out  => la_mem_out
            );

    ram_0 : entity work.ram(rtl)
        generic map (
            ADDR_WIDTH => RWM_ADDR_WIDTH,
            DATA_WIDTH => 16
            )
        port map (
            clk => la_clk,

            we       => la_mem_we,
            re       => '1',
            addr     => la_mem_addr(RWM_ADDR_WIDTH - 1 downto 0),
            data_in  => la_mem_out,
            data_out => la_mem_in
            );

end architecture rtl;


---------------------------------------------------------------------------------
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
