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

use work.limen_alpha_public.all; -- limen_alpha_public.vhd

use work.core; -- core.vhd


entity limen_alpha is
    port (
        clk   : in std_logic;
        rst   : in std_logic;
        irq_0 : in std_logic;
        irq_1 : in std_logic;

        mem_in   : in  std_logic_vector(15 downto 0);
        mem_we   : out std_logic;
        mem_addr : out std_logic_vector(15 downto 0);
        mem_out  : out std_logic_vector(15 downto 0)
        );
end entity limen_alpha;


architecture rtl of limen_alpha is

    signal core_sync_ack : std_logic;
    signal core_sync_req : std_logic;

    signal core_mem_we   : std_logic;
    signal core_mem_addr : std_logic_vector(15 downto 0);

    signal core_0_mem_excl  : std_logic;
    signal core_0_mem_yield : std_logic;
    signal core_0_sync_req  : std_logic;
    signal core_0_mem_we    : std_logic;
    signal core_0_mem_addr  : std_logic_vector(15 downto 0);
    signal core_0_mem_out   : std_logic_vector(15 downto 0);

    signal core_1_mem_excl  : std_logic;
    signal core_1_mem_yield : std_logic;
    signal core_1_sync_req  : std_logic;
    signal core_1_mem_we    : std_logic;
    signal core_1_mem_addr  : std_logic_vector(15 downto 0);
    signal core_1_mem_out   : std_logic_vector(15 downto 0);

    signal sync_wr_en   : std_logic;
    signal link_core_eq : std_logic;

    signal link_bit  : std_logic;
    signal link_core : std_logic := 'U';

begin

    core_mem_we <= core_1_mem_we when core_1_mem_excl = '1'
                   else core_0_mem_we;

    link_core_eq <= link_core xnor core_1_mem_excl;

    sync_wr_en <= link_bit and link_core_eq;

    core_sync_req <= core_1_sync_req when core_1_mem_excl = '1'
                     else core_0_sync_req;

    mem_we <= core_mem_we and (sync_wr_en or not core_sync_req);

    core_mem_addr <= core_1_mem_addr when core_1_mem_excl = '1'
                     else core_0_mem_addr;

    mem_addr <= core_mem_addr;

    mem_out <= core_1_mem_out when core_1_mem_excl = '1'
               else core_0_mem_out;

    core_0 : entity work.core(rtl)
        generic map (
            INT_ADDR   => CORE_0_INT_ADDR,
            IP_REG_RST => CORE_0_IP_REG_RST,
            PRNG_SEED  => CORE_0_PRNG_SEED
            )
        port map (
            clk => clk,
            rst => rst,
            irq => irq_0,

            mem_excl  => core_0_mem_excl,
            sync_ack  => core_sync_ack,
            mem_yield => core_0_mem_yield,
            sync_req  => core_0_sync_req,

            mem_in   => mem_in,
            mem_we   => core_0_mem_we,
            mem_addr => core_0_mem_addr,
            mem_out  => core_0_mem_out
            );

    core_0_mem_excl <= not core_1_mem_excl;

    core_1 : entity work.core(rtl)
        generic map (
            INT_ADDR   => CORE_1_INT_ADDR,
            IP_REG_RST => CORE_1_IP_REG_RST,
            PRNG_SEED  => CORE_1_PRNG_SEED
            )
        port map (
            clk => clk,
            rst => rst,
            irq => irq_1,

            mem_excl  => core_1_mem_excl,
            sync_ack  => core_sync_ack,
            mem_yield => core_1_mem_yield,
            sync_req  => core_1_sync_req,

            mem_in   => mem_in,
            mem_we   => core_1_mem_we,
            mem_addr => core_1_mem_addr,
            mem_out  => core_1_mem_out
            );

    cores_sync : process(clk)
    begin
        if (rising_edge(clk)) then
            if (rst = '1') then
                core_1_mem_excl <= '0';
                link_bit        <= '0';
            else

                if (core_1_mem_yield = '1') then
                    core_1_mem_excl <= '0';
                elsif (core_0_mem_yield = '1') then
                    core_1_mem_excl <= '1';
                end if;

                if (core_sync_req = '1') then
                    if (core_mem_we = '0') then
                        link_bit  <= '1';
                        link_core <= core_1_mem_excl;
                    else
                        core_sync_ack <= sync_wr_en;
                        if (sync_wr_en = '1') then
                            link_bit <= '0';
                        end if;
                    end if;
                end if;

            end if;
        end if;
    end process cores_sync;

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
