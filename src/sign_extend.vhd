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

use work.core_public.all; -- core_public.vhd


entity sign_extend is
    port (
        i_opcode : in  std_logic_vector(2 downto 0);
        i_data   : in  std_logic_vector(9 downto 0);
        o_data   : out std_logic_vector(15 downto 0)
    );
end entity sign_extend;


architecture rtl of sign_extend is
    
    signal w_extended_unsigned_data : std_logic_vector(15 downto 0);
    
begin
    
    w_extended_unsigned_data <= 
        i_data(9 downto 2) & (7 downto 0 => '0') when i_data(0) = '1' else
        (7 downto 0 => '0') & i_data(9 downto 2);
    
    with i_opcode select o_data <= 
        (11 downto 0 => '0') & i_data(6 downto 3)       when c_OPCODE_LI,
        w_extended_unsigned_data                        when c_OPCODE_LDI,
        (8 downto 0  => i_data(9)) & i_data(9 downto 3) when c_OPCODE_CJSI,
        (5 downto 0  => i_data(9)) & i_data(9 downto 0) when c_OPCODE_JSI,
        (11 downto 0 => i_data(7)) & i_data(6 downto 3) when others;
    
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
