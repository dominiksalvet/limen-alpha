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

use work.alu_port.all; -- alu_port.vhd
use work.alu_shared.all; -- alu_shared.vhd


entity alu is
    port (
        operation : in  std_logic_vector(3 downto 0);
        sub_add   : in  std_logic;
        operand_l : in  std_logic_vector(15 downto 0);
        operand_r : in  std_logic_vector(15 downto 0);
        result    : out std_logic_vector(15 downto 0)
        );
end entity alu;


architecture rtl of alu is

    signal adder_result : std_logic_vector(16 downto 0);

    signal unsigned_lr_less : std_logic;
    signal signed_lr_less   : std_logic;

begin

    adder_result <= std_logic_vector(
        unsigned('0' & operand_l) +
        unsigned('0' & (operand_r xor (15 downto 0 => sub_add))) +
        unsigned'(0 => sub_add)
        );

    unsigned_lr_less <= not adder_result(16);

    signed_lr_less <= not adder_result(16) when operand_l(15) = operand_r(15)
                      else operand_l(15) and not operand_r(15);

    with operation select result <=
        operand_l or operand_r                              when ALU_OR,
        operand_l or not operand_r                          when ALU_ORN,
        operand_l and operand_r                             when ALU_AND,
        operand_l and not operand_r                         when ALU_ANDN,
        operand_l xor operand_r                             when ALU_XOR,
        logic_shift_left(operand_l, operand_r(3 downto 0))  when ALU_SLL,
        logic_shift_right(operand_l, operand_r(3 downto 0)) when ALU_SRL,
        arith_shift_right(operand_l, operand_r(3 downto 0)) when ALU_SRA,
        (0 => unsigned_lr_less, others => '0')              when ALU_SLU,
        (0 => signed_lr_less, others => '0')                when ALU_SL,
        adder_result(15 downto 0)                           when ALU_SUB | ALU_ADD,
        operand_l                                           when ALU_L,
        operand_r                                           when ALU_R,
        operand_l(15 downto 8) & operand_r(7 downto 0)      when ALU_LR,
        operand_r(15 downto 8) & operand_l(7 downto 0)      when ALU_RL,
        (others => 'X')                                     when others;

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
