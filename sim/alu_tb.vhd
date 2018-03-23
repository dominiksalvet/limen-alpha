--------------------------------------------------------------------------------
-- Description:
--------------------------------------------------------------------------------
-- Notes:
--------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.alu_interf.all; -- alu_interf.vhd


entity alu_tb is
end entity alu_tb;


architecture behavior of alu_tb is
    
    -- uut ports
    signal i_operation : std_logic_vector(3 downto 0)  := (others => '0');
    signal i_sub_add   : std_logic                     := '0';
    signal i_operand_l : std_logic_vector(15 downto 0) := (others => '0');
    signal i_operand_r : std_logic_vector(15 downto 0) := (others => '0');
    signal o_result    : std_logic_vector(15 downto 0);
    
    -- clock period definition
    constant c_CLK_PERIOD : time := 10 ns;
    
begin
    
    -- instantiate the unit under test (uut)
    uut : entity work.alu(rtl)
        port map (
            i_operation => i_operation,
            i_sub_add   => i_sub_add,
            i_operand_l => i_operand_l,
            i_operand_r => i_operand_r,
            o_result    => o_result
        );
    
    stimulus : process is
    begin
        
        i_operation <= c_ALU_OR;
        i_operand_l <= "1100110011001100";
        i_operand_r <= "0011001100110011";
        wait for c_CLK_PERIOD;
        
        i_operation <= c_ALU_ADD;
        i_operand_l <= std_logic_vector(to_signed(52, i_operand_l'length));
        i_operand_r <= std_logic_vector(to_signed(76, i_operand_r'length));
        wait for c_CLK_PERIOD;
        
        i_operand_r <= std_logic_vector(to_signed(-51, i_operand_r'length));
        wait for c_CLK_PERIOD;
        
        i_operand_l <= (others => '1');
        i_operand_r <= (others => '0');
        i_operation <= c_ALU_RL;
        wait;
        
    end process stimulus;
    
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
