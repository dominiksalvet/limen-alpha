--------------------------------------------------------------------------------
-- Description:
--------------------------------------------------------------------------------
-- Notes:
--------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.limen_alpha_public.all; -- limen_alpha_public.vhd


entity core_tb is
end entity core_tb;


architecture behavior of core_tb is
    
    -- uut generics
    constant INT_ADDR   : std_logic_vector(15 downto 0) := CORE_0_INT_ADDR;
    constant IP_REG_RST : std_logic_vector(15 downto 0) := CORE_0_IP_REG_RST;
    constant PRNG_SEED  : std_logic_vector(15 downto 0) := CORE_0_PRNG_SEED;
    
    -- uut ports
    signal clk : std_logic := '0';
    signal rst : std_logic := '0';
    signal irq : std_logic := '0';
    
    signal mem_excl  : std_logic := '0';
    signal sync_ack  : std_logic := '0';
    signal mem_yield : std_logic;
    signal sync_req  : std_logic;
    
    signal mem_in   : std_logic_vector(15 downto 0) := (others => '0');
    signal mem_we   : std_logic;
    signal mem_addr : std_logic_vector(15 downto 0);
    signal mem_out  : std_logic_vector(15 downto 0); 
    
    
    constant MEM_ADDR_SIZE : integer range 0 to 16 := 12;
    
    type mem_array is array ((2 ** MEM_ADDR_SIZE) - 1 downto 0) of std_logic_vector(15 downto 0);
    signal rwm_array : mem_array := (
        
        -- == Unsigned software division ==
        -- perform division of unsigned values
        -- R1 = R2 / R3
        
        0 => "1000100000001010", -- LIS R2, 64
        1 => "1000001110100011", -- LI R3, 29
        2 => "1000000000100100", -- LI R4, 1
        3 => "1000000000000001", -- LI R1, 0
        
        4 => "0111000011010111", -- SLU R7, R2, R3
        5 => "1010000100111010", -- JNE R7, +4 (9)
        6 => "0101010001011011", -- SLL R3, R3, 1
        7 => "0101010001100100", -- SLL R4, R4, 1
        8 => "1101111111100000", -- JWL R0, -4 (4)
        
        9  => "1000000000100101", -- LI R5, 1
        10 => "0111000100101111", -- SLU R7, R5, R4
        11 => "1010001000111011", -- JE R7, +8 (18)
        12 => "0101100001011011", -- SRL R3, R3, 1
        13 => "0101100001100100", -- SRL R4, R4, 1
        
        14 => "0111000011010111", -- SLU R7, R2, R3
        15 => "1011111011111010", -- JNE R7, -5 (9)
        16 => "0111010011010010", -- SUB R2, R2, R3
        17 => "0111011100001001", -- ADD R1, R1, R4
        18 => "1101111111000000", -- JWL R0, -8 (9)
        
        19 => "1100000000000000", -- JWL R0, 0
        
        others => (others => '0')
        );
    
    -- clock period definition
    constant CLK_PERIOD : time := 10 ns;
    
begin
    
    uut : entity work.core(rtl)
        generic map(
            INT_ADDR   => INT_ADDR,
            IP_REG_RST => IP_REG_RST,
            PRNG_SEED  => PRNG_SEED
        )
        port map(
            clk => clk,
            rst => rst,
            irq => irq,
            
            mem_excl  => mem_excl,
            sync_ack  => sync_ack,
            mem_yield => mem_yield,
            sync_req  => sync_req,
            
            mem_in   => mem_in,
            mem_we   => mem_we,
            mem_addr => mem_addr,
            mem_out  => mem_out
        );
    
    
    clk_proc : process is
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        clk <= '1';
        wait for CLK_PERIOD/2;
    end process clk_proc;
    
    
    rst_proc : process is
    begin
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        wait for 100 ns;
        rst <= '1';
        wait for 20 ns;
        rst <= '0';
        wait;
    end process rst_proc;
    
    
    irq_proc : process is
    begin
        irq <= '0';
        wait for 390 ns;
        irq <= '1';
        wait for 600 ns;
        irq <= '0';
        wait;
    end process irq_proc;
    
    
    stim_proc : process is
    begin
        sync_ack <= '1';
        wait for 40 ns;
        mem_excl <= '1';
        wait for 200 ns;
        mem_excl <= '0';
        wait for 50 ns;
        mem_excl <= '1';
        wait for 20 ns;
        
        loop
            wait for 2 * CLK_PERIOD;
            mem_excl <= not mem_excl;
        end loop;
        
        wait;
    end process stim_proc;
    
    
    mem_proc : process (clk) is
    begin
        if(rising_edge(clk)) then
            
            if(mem_we = '1') then
                rwm_array(to_integer(unsigned(mem_addr))) <= mem_out;
            end if;
            
            if(to_integer(unsigned(mem_addr)) < 2 ** MEM_ADDR_SIZE) then
                mem_in <= rwm_array(to_integer(unsigned(mem_addr)));
            end if;
            
        end if;
    end process mem_proc;
    
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
