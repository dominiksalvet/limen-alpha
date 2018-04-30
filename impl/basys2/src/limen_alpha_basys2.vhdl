--------------------------------------------------------------------------------
-- Standard: VHDL-1993
-- Platform: basys2
--------------------------------------------------------------------------------
-- Description:
--------------------------------------------------------------------------------
-- Notes:
--------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.clk_divider;

use work.limen_alpha;

use work.ram;


entity limen_alpha_basys2 is
    generic (
        RWM_ADDR_WIDTH : positive := 8
    );
    port (
        clk   : in std_ulogic;
        rst   : in std_ulogic;
        irq_0 : in std_ulogic;
        irq_1 : in std_ulogic
    );
end entity limen_alpha_basys2;


architecture structural of limen_alpha_basys2 is
    
    signal la_clk      : std_ulogic;
    signal la_mem_in   : std_ulogic_vector(15 downto 0);
    signal la_mem_we   : std_ulogic;
    signal la_mem_addr : std_ulogic_vector(15 downto 0);
    signal la_mem_out  : std_ulogic_vector(15 downto 0);
    
begin
    
    clk_divider_la : entity work.clk_divider(rtl)
        generic map (
            g_FREQ_DIV_MAX_VALUE => 200_000
        )
        port map (
            i_clk => clk,
            i_rst => rst,
            
            i_freq_div => 200_000,
            o_clk      => la_clk
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
            g_ADDR_WIDTH => RWM_ADDR_WIDTH,
            g_DATA_WIDTH => 16,
            
            g_MEM_IMG_FILENAME => ""
        )
        port map (
            i_clk => la_clk,
            
            i_we   => la_mem_we,
            i_re   => '1',
            i_addr => la_mem_addr(RWM_ADDR_WIDTH - 1 downto 0),
            i_data => la_mem_out,
            o_data => la_mem_in
        );
    
end architecture structural;


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
