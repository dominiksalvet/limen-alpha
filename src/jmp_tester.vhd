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

use work.jmp_tester_interf.all; -- jmp_tester_interf.vhd


entity jmp_tester is
    port (
        jmp_type  : in  std_logic_vector(2 downto 0);
        test_data : in  std_logic_vector(15 downto 0);
        jmp_ack   : out std_logic
        );
end entity jmp_tester;


architecture rtl of jmp_tester is

    signal equal_zero : std_logic;
    signal less_zero  : std_logic;

begin

    equal_zero <= '1' when test_data = (15 downto 0 => '0')
                  else '0';

    less_zero <= test_data(15);

    with jmp_type select jmp_ack <=
        '0'                              when JMP_NEVER,
        '1'                              when JMP_ALWAYS,
        not equal_zero                   when JMP_NE,
        equal_zero                       when JMP_E,
        less_zero                        when JMP_L,
        less_zero or equal_zero          when JMP_LE,
        not less_zero and not equal_zero when JMP_G,
        not less_zero                    when JMP_GE,
        'X'                              when others;

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
