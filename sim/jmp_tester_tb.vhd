--------------------------------------------------------------------------------
-- Description:
--------------------------------------------------------------------------------
-- Notes:
--------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.jmp_tester; -- jmp_tester.vhd
use work.jmp_tester_interf.all; -- jmp_tester_interf.vhd


entity jmp_tester_tb is
end entity jmp_tester_tb;


architecture behavior of jmp_tester_tb is
    
    -- uut ports
    signal jmp_type  : std_logic_vector(2 downto 0)  := (others => '0');
    signal test_data : std_logic_vector(15 downto 0) := (others => '0');
    signal jmp_ack   : std_logic;
    
    -- clock period definition
    constant CLK_PERIOD : time := 10 ns;
    
begin
    
    -- instantiate the unit under test (uut)
    uut : entity work.jmp_tester(rtl)
        port map (
            jmp_type  => jmp_type,
            test_data => test_data,
            jmp_ack   => jmp_ack
        );
    
    -- Purpose: Stimulus process.
    stim_proc : process
    begin
        
        jmp_type  <= JMP_NEVER;
        test_data <= std_logic_vector(to_signed(5, test_data'length));
        wait for CLK_PERIOD;
        
        jmp_type <= JMP_GE;
        wait for CLK_PERIOD;
        
        test_data <= std_logic_vector(to_signed(0, test_data'length));
        wait for CLK_PERIOD;
        
        jmp_type <= JMP_G;
        wait for CLK_PERIOD;
        
        test_data <= std_logic_vector(to_signed(-20, test_data'length));
        jmp_type  <= JMP_L;
        wait for CLK_PERIOD;
        
        test_data <= (others => '0');
        wait;
        
    end process stim_proc;
    
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
