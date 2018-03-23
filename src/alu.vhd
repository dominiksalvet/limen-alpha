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

use work.alu_interf.all; -- alu_interf.vhd
use work.alu_public.all; -- alu_public.vhd


entity alu is
    port (
        i_operation : in  std_logic_vector(3 downto 0);
        i_sub_add   : in  std_logic;
        i_operand_l : in  std_logic_vector(15 downto 0);
        i_operand_r : in  std_logic_vector(15 downto 0);
        o_result    : out std_logic_vector(15 downto 0)
    );
end entity alu;


architecture rtl of alu is
    
    signal w_adder_result : std_logic_vector(16 downto 0);
    
    signal w_unsigned_less_lr : std_logic;
    signal w_signed_less_lr   : std_logic;
    
begin
    
    w_adder_result <= std_logic_vector(
            unsigned('0' & i_operand_l) +
            unsigned('0' & (i_operand_r xor (15 downto 0 => i_sub_add))) +
            unsigned'(0 => i_sub_add)
    );
    
    w_unsigned_less_lr <= not w_adder_result(16);
    
    w_signed_less_lr <= 
        not w_adder_result(16) when i_operand_l(15) = i_operand_r(15) else
        i_operand_l(15) and not i_operand_r(15);
    
    with i_operation select o_result <= 
        i_operand_l or i_operand_r                              when c_ALU_OR,
        i_operand_l or not i_operand_r                          when c_ALU_ORN,
        i_operand_l and i_operand_r                             when c_ALU_AND,
        i_operand_l and not i_operand_r                         when c_ALU_ANDN,
        i_operand_l xor i_operand_r                             when c_ALU_XOR,
        logic_shift_left(i_operand_l, i_operand_r(3 downto 0))  when c_ALU_SLL,
        logic_shift_right(i_operand_l, i_operand_r(3 downto 0)) when c_ALU_SRL,
        arith_shift_right(i_operand_l, i_operand_r(3 downto 0)) when c_ALU_SRA,
        (0 => w_unsigned_less_lr, others => '0')                when c_ALU_SLU,
        (0 => w_signed_less_lr, others => '0')                  when c_ALU_SL,
        w_adder_result(15 downto 0)                             when c_ALU_SUB | c_ALU_ADD,
        i_operand_l                                             when c_ALU_L,
        i_operand_r                                             when c_ALU_R,
        i_operand_l(15 downto 8) & i_operand_r(7 downto 0)      when c_ALU_LR,
        i_operand_r(15 downto 8) & i_operand_l(7 downto 0)      when c_ALU_RL,
        (others => 'X')                                         when others;
    
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
