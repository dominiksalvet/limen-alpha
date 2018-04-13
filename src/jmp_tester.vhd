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
        i_jmp_type  : in  std_ulogic_vector(2 downto 0);
        i_test_data : in  std_ulogic_vector(15 downto 0);
        o_jmp_ack   : out std_ulogic
    );
end entity jmp_tester;


architecture rtl of jmp_tester is
    
    signal w_equal_zero : std_ulogic;
    signal w_less_zero  : std_ulogic;
    
begin
    
    w_equal_zero <= '1' when i_test_data = (15 downto 0 => '0') else '0';
    
    w_less_zero <= i_test_data(15);
    
    with i_jmp_type select o_jmp_ack <= 
        '0'                                  when c_JMP_NEVER,
        '1'                                  when c_JMP_ALWAYS,
        not w_equal_zero                     when c_JMP_NE,
        w_equal_zero                         when c_JMP_E,
        w_less_zero                          when c_JMP_L,
        w_less_zero or w_equal_zero          when c_JMP_LE,
        not w_less_zero and not w_equal_zero when c_JMP_G,
        not w_less_zero                      when c_JMP_GE,
        'X'                                  when others;
    
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
