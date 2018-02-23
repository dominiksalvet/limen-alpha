--------------------------------------------------------------------------------
-- Standard:    VHDL-1993
-- Platform:    independent
-- Dependecies: none
--------------------------------------------------------------------------------
-- Description:
--------------------------------------------------------------------------------
-- Notes:
--------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;

use work.core_shared.all;


entity sign_extend is
    port (
        opcode   : in  std_logic_vector(2 downto 0);
        data_in  : in  std_logic_vector(9 downto 0);
        data_out : out std_logic_vector(15 downto 0)
        );
end entity sign_extend;


architecture rtl of sign_extend is

    signal high_low : std_logic_vector(15 downto 0);

begin

    high_low <= data_in(9 downto 2) & (7 downto 0 => '0') when data_in(0) = '1'
                else (7 downto 0 => '0') & data_in(9 downto 2);

    with opcode select data_out <=
        (11 downto 0 => '0') & data_in(6 downto 3)        when OPCODE_LIMM,
        high_low                                          when OPCODE_LDIMM,
        (8 downto 0  => data_in(9)) & data_in(9 downto 3) when OPCODE_CJSIMM,
        (5 downto 0  => data_in(9)) & data_in(9 downto 0) when OPCODE_JSIMM,
        (11 downto 0 => data_in(7)) & data_in(6 downto 3) when others;

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
