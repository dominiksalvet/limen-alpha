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


package alu_shared is

    function logic_shift_left (
        operand_a : std_logic_vector;
        operand_b : std_logic_vector
        )
        return std_logic_vector;

    function logic_shift_right (
        operand_a : std_logic_vector;
        operand_b : std_logic_vector
        )
        return std_logic_vector;

    function arith_shift_right (
        operand_a : std_logic_vector;
        operand_b : std_logic_vector
        )
        return std_logic_vector;

end package alu_shared;


package body alu_shared is

    function logic_shift_left (
        operand_a : std_logic_vector;
        operand_b : std_logic_vector
        )
        return std_logic_vector is
    begin
        return std_logic_vector(
            shift_left(
                unsigned(operand_a),
                to_integer(unsigned(operand_b))
                )
            );
    end function logic_shift_left;

    function logic_shift_right (
        operand_a : std_logic_vector;
        operand_b : std_logic_vector
        )
        return std_logic_vector is
    begin
        return std_logic_vector(
            shift_right(
                unsigned(operand_a),
                to_integer(unsigned(operand_b))
                )
            );
    end function logic_shift_right;

    function arith_shift_right (
        operand_a : std_logic_vector;
        operand_b : std_logic_vector
        )
        return std_logic_vector is
    begin
        return std_logic_vector(
            shift_right(
                signed(operand_a),
                to_integer(unsigned(operand_b))
                )
            );
    end function arith_shift_right;

end package body alu_shared;


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
