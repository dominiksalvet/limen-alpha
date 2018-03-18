library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


package verif_util is
    
    -- Description:
    --     The function checks the input vector c_VECTOR and returns false if it contains any other
    --     value than '1' or '0' in it's scalar components. The function is not intended to be
    --     synthesized.
    function is_vector_of_01 (
            c_VECTOR : std_logic_vector -- input vector
        ) return boolean;
    
end package verif_util;


package body verif_util is
    
    function is_vector_of_01 (
            c_VECTOR : std_logic_vector
        ) return boolean is
    begin
        for i in 0 to c_VECTOR'length - 1 loop -- check every vector's scalar component
            if (c_VECTOR(i) /= '0' and c_VECTOR(i) /= '1') then
                return false;
            end if;
        end loop;
        return true;
    end function is_vector_of_01;
    
end package body verif_util;


--------------------------------------------------------------------------------
-- MIT License
--
-- Copyright (c) 2018 Dominik Salvet
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
