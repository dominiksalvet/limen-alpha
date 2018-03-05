--------------------------------------------------------------------------------
-- Description:
--------------------------------------------------------------------------------
-- Notes:
--------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.sign_extend; -- sign_extend.vhd


entity sign_extend_tb is
end entity sign_extend_tb;


architecture behavior of sign_extend_tb is
    
    -- uut ports
    signal opcode   : std_logic_vector(2 downto 0) := (others => '0');
    signal data_in  : std_logic_vector(9 downto 0) := (others => '0');
    signal data_out : std_logic_vector(15 downto 0);
    
    -- clock period definition
    constant CLK_PERIOD : time := 10 ns;
    
begin
    
    -- instantiate the unit under test (uut)
    uut : entity work.sign_extend(rtl)
        port map (
            opcode   => opcode,
            data_in  => data_in,
            data_out => data_out
        );
    
    -- Purpose: Stimulus process.
    stim_proc : process
    begin
        
        data_in <= "1010101010";
        wait for CLK_PERIOD;
        
        loop
            inst_form <= std_logic_vector(unsigned(inst_form) + 1);
            wait for CLK_PERIOD;
        end loop;
        
    end process;
    
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
