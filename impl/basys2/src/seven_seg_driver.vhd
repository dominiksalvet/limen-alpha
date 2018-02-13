library ieee;
use ieee.std_logic_1164.all;


entity seven_seg_driver is
    generic (
        LED_ON_VALUE  : std_logic;
        LED_SEL_VALUE : std_logic;
        DIGIT_COUNT   : positive
        );
    port (
        clk : in std_logic;
        rst : in std_logic;

        data_in  : in  std_logic_vector((DIGIT_COUNT * 4) - 1 downto 0);
        seg_sel  : out std_logic_vector(DIGIT_COUNT - 1 downto 0);
        seg_data : out std_logic_vector(6 downto 0)
        );
end entity seven_seg_driver;


architecture rtl of seven_seg_driver is

    constant DIGIT_0_IMAGE : std_logic_vector(6 downto 0) := (6 downto 0 => LED_ON_VALUE) xor "0000001";
    constant DIGIT_1_IMAGE : std_logic_vector(6 downto 0) := (6 downto 0 => LED_ON_VALUE) xor "1001111";
    constant DIGIT_2_IMAGE : std_logic_vector(6 downto 0) := (6 downto 0 => LED_ON_VALUE) xor "0010010";
    constant DIGIT_3_IMAGE : std_logic_vector(6 downto 0) := (6 downto 0 => LED_ON_VALUE) xor "0000110";
    constant DIGIT_4_IMAGE : std_logic_vector(6 downto 0) := (6 downto 0 => LED_ON_VALUE) xor "1001100";
    constant DIGIT_5_IMAGE : std_logic_vector(6 downto 0) := (6 downto 0 => LED_ON_VALUE) xor "0100100";
    constant DIGIT_6_IMAGE : std_logic_vector(6 downto 0) := (6 downto 0 => LED_ON_VALUE) xor "0100000";
    constant DIGIT_7_IMAGE : std_logic_vector(6 downto 0) := (6 downto 0 => LED_ON_VALUE) xor "0001111";
    constant DIGIT_8_IMAGE : std_logic_vector(6 downto 0) := (6 downto 0 => LED_ON_VALUE) xor "0000000";
    constant DIGIT_9_IMAGE : std_logic_vector(6 downto 0) := (6 downto 0 => LED_ON_VALUE) xor "0000100";
    constant DIGIT_A_IMAGE : std_logic_vector(6 downto 0) := (6 downto 0 => LED_ON_VALUE) xor "0001000";
    constant DIGIT_B_IMAGE : std_logic_vector(6 downto 0) := (6 downto 0 => LED_ON_VALUE) xor "1100000";
    constant DIGIT_C_IMAGE : std_logic_vector(6 downto 0) := (6 downto 0 => LED_ON_VALUE) xor "0110001";
    constant DIGIT_D_IMAGE : std_logic_vector(6 downto 0) := (6 downto 0 => LED_ON_VALUE) xor "1000010";
    constant DIGIT_E_IMAGE : std_logic_vector(6 downto 0) := (6 downto 0 => LED_ON_VALUE) xor "0110000";
    constant DIGIT_F_IMAGE : std_logic_vector(6 downto 0) := (6 downto 0 => LED_ON_VALUE) xor "0111000";

    signal seg_sel_reg   : std_logic_vector(DIGIT_COUNT - 1 downto 0);
    signal seg_sel_index : natural range 0 to DIGIT_COUNT - 1;

    signal converted_data : std_logic_vector(3 downto 0);

begin

    seg_sel <= seg_sel_reg;

    converted_data <= data_in((seg_sel_index * 4) + 3 downto (seg_sel_index * 4));

    with converted_data select seg_data <=
        DIGIT_0_IMAGE   when "0000",
        DIGIT_1_IMAGE   when "0001",
        DIGIT_2_IMAGE   when "0010",
        DIGIT_3_IMAGE   when "0011",
        DIGIT_4_IMAGE   when "0100",
        DIGIT_5_IMAGE   when "0101",
        DIGIT_6_IMAGE   when "0110",
        DIGIT_7_IMAGE   when "0111",
        DIGIT_8_IMAGE   when "1000",
        DIGIT_9_IMAGE   when "1001",
        DIGIT_A_IMAGE   when "1010",
        DIGIT_B_IMAGE   when "1011",
        DIGIT_C_IMAGE   when "1100",
        DIGIT_D_IMAGE   when "1101",
        DIGIT_E_IMAGE   when "1110",
        DIGIT_F_IMAGE   when "1111",
        (others => 'X') when others;

    seg_refresh_cycle : process(clk)
    begin
        if (rising_edge(clk)) then

            seg_sel_reg                <= (others => not LED_SEL_VALUE);
            seg_sel_reg(seg_sel_index) <= LED_SEL_VALUE;

            if (rst = '1') then
                seg_sel_index <= 0;
            else
                if (seg_sel_index = DIGIT_COUNT - 1) then
                    seg_sel_index <= 0;
                else
                    seg_sel_index <= seg_sel_index + 1;
                end if;
            end if;

        end if;
    end process seg_refresh_cycle;

end architecture rtl;


---------------------------------------------------------------------------------
-- MIT License
--
-- Copyright (c) 2016-2018 Dominik Salvet
--
-- Permission is hereby granted, free of charge, to any person obtaining a copy
-- of this software and associated documentation files (the "Software"), to deal
-- in the Software without restriction, including without limitation the rights
-- to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
-- copies of the Software, and to permit persons to whom the Software is
-- furnished to do so, subject to the following conditions:
--
-- The above copyright notice and this permission notice shall be included in all
-- copies or substantial portions of the Software.
--
-- THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
-- IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
-- FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
-- AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
-- LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
-- OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
-- SOFTWARE.
---------------------------------------------------------------------------------
