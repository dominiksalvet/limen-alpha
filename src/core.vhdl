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

use work.core_public.all;

use work.reg_file;
use work.reg_file_interf.all;

use work.sign_extend;

use work.alu;
use work.alu_interf.all;

use work.jmp_tester;
use work.jmp_tester_interf.all;


entity core is
    generic (
        INT_ADDR   : std_ulogic_vector(15 downto 0);
        IP_REG_RST : std_ulogic_vector(15 downto 0);
        PRNG_SEED  : std_ulogic_vector(15 downto 0)
        );
    port (
        clk : in std_ulogic;
        rst : in std_ulogic;
        irq : in std_ulogic;

        mem_excl  : in  std_ulogic;
        sync_ack  : in  std_ulogic;
        mem_yield : out std_ulogic;
        sync_req  : out std_ulogic;

        mem_in   : in  std_ulogic_vector(15 downto 0);
        mem_we   : out std_ulogic;
        mem_addr : out std_ulogic_vector(15 downto 0);
        mem_out  : out std_ulogic_vector(15 downto 0)
        );
end entity core;


architecture rtl of core is

    constant CLK_PHASE_0 : std_ulogic_vector(1 downto 0) := "00";
    constant CLK_PHASE_1 : std_ulogic_vector(1 downto 0) := "01";
    constant CLK_PHASE_2 : std_ulogic_vector(1 downto 0) := "10";
    constant CLK_PHASE_3 : std_ulogic_vector(1 downto 0) := "11";

    constant REG_MSR  : std_ulogic_vector(2 downto 0) := "000";
    constant REG_SIP  : std_ulogic_vector(2 downto 0) := "001";
    constant REG_PRNG : std_ulogic_vector(2 downto 0) := "010";

    constant REG_MSR_RST : std_ulogic_vector(15 downto 0) := x"0001";

    -- reg_file_0 ports
    signal rf_i_z_we    : std_ulogic;
    signal rf_i_z_index : std_ulogic_vector(2 downto 0);
    signal rf_i_z_data  : std_ulogic_vector(15 downto 0);

    signal rf_i_y_index : std_ulogic_vector(2 downto 0);
    signal rf_o_y_data  : std_ulogic_vector(15 downto 0);

    signal rf_i_x_index : std_ulogic_vector(2 downto 0);
    signal rf_o_x_data  : std_ulogic_vector(15 downto 0);

    -- sign_extend_0 ports
    signal se_o_data : std_ulogic_vector(15 downto 0);

    -- alu_0 ports
    signal alu_i_operation : std_ulogic_vector(3 downto 0);
    signal alu_i_sub_add   : std_ulogic;
    signal alu_i_operand_l : std_ulogic_vector(15 downto 0);
    signal alu_i_operand_r : std_ulogic_vector(15 downto 0);
    signal alu_o_result    : std_ulogic_vector(15 downto 0);

    signal inst_alu_operation : std_ulogic_vector(3 downto 0);
    signal inst_alu_operand_l : std_ulogic_vector(15 downto 0);
    signal inst_alu_operand_r : std_ulogic_vector(15 downto 0);

    -- jmp_tester_0 ports
    signal jt_i_jmp_type  : std_ulogic_vector(2 downto 0);
    signal jt_i_test_data : std_ulogic_vector(15 downto 0);
    signal jt_o_jmp_ack       : std_ulogic;

    signal clk_phase  : std_ulogic_vector(1 downto 0);
    signal sync_phase : std_ulogic_vector(1 downto 0);

    signal ip_reg : std_ulogic_vector(15 downto 0) := (others => '-');
    signal ir_reg : std_ulogic_vector(15 downto 0);

    signal inc_ip_reg     : std_ulogic_vector(15 downto 0);
    signal alu_result_reg : std_ulogic_vector(15 downto 0);

    signal opcode       : std_ulogic_vector(2 downto 0);
    signal ll_inst_dec  : std_ulogic;
    signal ld_inst_dec  : std_ulogic;
    signal sc_inst_dec  : std_ulogic;
    signal st_inst_dec  : std_ulogic;
    signal rtc_inst_dec : std_ulogic;
    signal ctr_inst_dec : std_ulogic;

    signal alu_mem_en    : std_ulogic;
    signal next_ip       : std_ulogic_vector(15 downto 0);
    signal alu_ldimm_opc : std_ulogic_vector(3 downto 0);

    signal msr_reg  : std_ulogic_vector(15 downto 0);
    signal sip_reg  : std_ulogic_vector(15 downto 0) := (others => '-');
    signal prng_reg : std_ulogic_vector(15 downto 0);

    signal c_reg_index : std_ulogic_vector(2 downto 0);
    signal c_reg_d_in  : std_ulogic_vector(15 downto 0);
    signal c_reg_d_out : std_ulogic_vector(15 downto 0);

begin

    opcode <= ir_reg(15 downto 13);

    ll_inst_dec <= '1' when opcode = c_OPCODE_TSI and ir_reg(12 downto 11) = "00"
                   else '0';

    ld_inst_dec <= '1' when opcode = c_OPCODE_TSI and ir_reg(12 downto 11) = "01"
                   else '0';

    sc_inst_dec <= '1' when opcode = c_OPCODE_TSI and ir_reg(12 downto 11) = "10"
                   else '0';

    st_inst_dec <= '1' when opcode = c_OPCODE_TSI and ir_reg(12 downto 11) = "11"
                   else '0';

    rtc_inst_dec <= '1' when opcode = c_OPCODE_ALC and ir_reg(12 downto 9) = "1110"
                    else '0';

    ctr_inst_dec <= '1' when opcode = c_OPCODE_ALC and ir_reg(12 downto 9) = "1111"
                    else '0';

    mem_yield <= '1' when clk_phase = CLK_PHASE_1
                 else '0';

    sync_req <= ll_inst_dec or sc_inst_dec when clk_phase = CLK_PHASE_0
                else '0';

    mem_we <= sc_inst_dec or st_inst_dec when clk_phase = CLK_PHASE_0
              else '0';

    mem_addr <= ip_reg when alu_mem_en = '0'
                else alu_o_result;

    mem_out <= rf_o_x_data;

    c_reg_index <= ir_reg(5 downto 3);

    c_reg_d_in <= rf_o_x_data;

    reg_file_0 : entity work.reg_file(rtl)
        port map (
            i_clk => clk,

            i_z_we    => rf_i_z_we,
            i_z_index => rf_i_z_index,
            i_z_data  => rf_i_z_data,

            i_y_index => rf_i_y_index,
            o_y_data  => rf_o_y_data,

            i_x_index => rf_i_x_index,
            o_x_data  => rf_o_x_data
        );

    rf_i_z_we <= '1' when clk_phase = CLK_PHASE_1
                 else '0';

    rf_i_z_index <= c_REG_R0 when st_inst_dec = '1' or opcode = c_OPCODE_CJSI
                    else ir_reg(2 downto 0);

    rf_i_z_data <= (14 downto 0 => '0') & sync_ack when sc_inst_dec = '1' else
                   mem_in      when ld_inst_dec = '1' or ll_inst_dec = '1' else
                   inc_ip_reg  when opcode = c_OPCODE_JSI or opcode = c_OPCODE_J else
                   c_reg_d_out when ctr_inst_dec = '1'
                   else alu_result_reg;

    rf_i_y_index <= ir_reg(2 downto 0) when opcode = c_OPCODE_LDI
                    else ir_reg(5 downto 3);

    rf_i_x_index <= ir_reg(2 downto 0) when st_inst_dec = '1' or sc_inst_dec = '1'
                    else ir_reg(8 downto 6);

    sign_extend_0 : entity work.sign_extend(rtl)
        port map (
            i_opcode => opcode,
            i_data   => ir_reg(12 downto 3),
            o_data   => se_o_data
        );

    alu_0 : entity work.alu(rtl)
        port map (
            i_operation => alu_i_operation,
            i_sub_add   => alu_i_sub_add,
            i_operand_l => alu_i_operand_l,
            i_operand_r => alu_i_operand_r,
            o_result    => alu_o_result
        );

    alu_ldimm_opc <= c_ALU_R when ir_reg(4) = '0'
                     else "111" & ir_reg(3);

    with opcode select inst_alu_operation <=
        ir_reg(12 downto 9)         when c_OPCODE_ALC,
        '0' & ir_reg(12 downto 10)  when c_OPCODE_LI,
        "10" & ir_reg(12 downto 11) when c_OPCODE_ASI,
        c_ALU_L                     when c_OPCODE_J,
        alu_ldimm_opc               when c_OPCODE_LDI,
        c_ALU_ADD                   when others;

    inst_alu_operand_l <= ip_reg when opcode = c_OPCODE_CJSI or opcode = c_OPCODE_JSI
                          else rf_o_y_data;

    inst_alu_operand_r <= rf_o_x_data when opcode = c_OPCODE_ALC
                          else se_o_data;

    jmp_tester_0 : entity work.jmp_tester(rtl)
        port map (
            i_jmp_type  => jt_i_jmp_type,
            i_test_data => jt_i_test_data,
            o_jmp_ack   => jt_o_jmp_ack
        );

    alu_mem_en <= '1' when clk_phase = CLK_PHASE_0
                  else '0';

    next_ip <= inc_ip_reg when jt_o_jmp_ack = '0'
               else alu_o_result;

    sync_phase <= CLK_PHASE_1 when mem_excl = '1'
                  else CLK_PHASE_0;

    galois_lfsr : process(clk)
    begin
        if (rising_edge(clk)) then
            if (rst = '1') then
                prng_reg <= PRNG_SEED;
            else
                prng_reg <= prng_reg(0) & (prng_reg(15) xor prng_reg(0)) &
                            (prng_reg(14) xor prng_reg(0)) & prng_reg(13) &
                            (prng_reg(12) xor prng_reg(0)) & (prng_reg(11) xor prng_reg(0)) &
                            prng_reg(10) & (prng_reg(9) xor prng_reg(0)) &
                            (prng_reg(8) xor prng_reg(0)) & (prng_reg(7) xor prng_reg(0)) &
                            prng_reg(6) & (prng_reg(5) xor prng_reg(0)) &
                            prng_reg(4) & prng_reg(3) &
                            (prng_reg(2) xor prng_reg(0)) & prng_reg(1);
            end if;
        end if;
    end process galois_lfsr;

    control_unit : process(clk)
    begin
        if (rising_edge(clk)) then
            if (rst = '1') then
                clk_phase     <= CLK_PHASE_0;
                ir_reg        <= c_INST_NOP;
                inc_ip_reg    <= IP_REG_RST;
                msr_reg       <= REG_MSR_RST;
                jt_i_jmp_type <= c_JMP_NEVER;
            else

                case clk_phase is
                    when CLK_PHASE_0 => clk_phase <= sync_phase;
                    when CLK_PHASE_1 => clk_phase <= CLK_PHASE_2;
                    when CLK_PHASE_2 => clk_phase <= CLK_PHASE_3;
                    when CLK_PHASE_3 => clk_phase <= CLK_PHASE_0;
                    when others      => clk_phase <= (others => 'X');
                end case;

                case opcode is
                    when c_OPCODE_CJSI                => jt_i_jmp_type <= ir_reg(2 downto 0);
                    when c_OPCODE_JSI | c_OPCODE_J => jt_i_jmp_type <= c_JMP_ALWAYS;
                    when others                         => jt_i_jmp_type <= c_JMP_NEVER;
                end case;

                jt_i_test_data <= rf_o_y_data;

                if ((clk_phase = CLK_PHASE_0 or clk_phase = CLK_PHASE_1) and mem_excl = '1') then
                    alu_i_operation <= c_ALU_ADD;
                    alu_i_sub_add   <= '0';
                    alu_i_operand_l <= ip_reg;
                    alu_i_operand_r <= std_ulogic_vector(to_signed(1, alu_i_operand_r'length));
                else
                    alu_i_operation <= inst_alu_operation;
                    alu_i_sub_add   <= (inst_alu_operation(3) and not inst_alu_operation(2)) and
                                         not (inst_alu_operation(1) and inst_alu_operation(0));
                    alu_i_operand_l <= inst_alu_operand_l;
                    alu_i_operand_r <= inst_alu_operand_r;
                end if;

                if (clk_phase = CLK_PHASE_0 and mem_excl = '1') then
                    alu_result_reg <= alu_o_result;

                    case c_reg_index is
                        when REG_MSR  => c_reg_d_out <= msr_reg;
                        when REG_SIP  => c_reg_d_out <= sip_reg;
                        when REG_PRNG => c_reg_d_out <= prng_reg;
                        when others   => c_reg_d_out <= (others => 'X');
                    end case;

                    if (msr_reg(0) = '0' and irq = '1' and rtc_inst_dec = '0') then
                        sip_reg    <= next_ip;
                        msr_reg(0) <= '1';
                        ip_reg     <= INT_ADDR;
                    else
                        ip_reg <= next_ip;
                        if (rtc_inst_dec = '1') then
                            case c_reg_index is
                                when REG_MSR  => msr_reg <= c_reg_d_in;
                                when REG_SIP  => sip_reg <= c_reg_d_in;
                                when REG_PRNG => null;
                                when others   => null;
                            end case;
                        end if;
                    end if;
                end if;

                if (clk_phase = CLK_PHASE_2) then
                    ir_reg     <= mem_in;
                    inc_ip_reg <= alu_o_result;
                end if;

            end if;
        end if;
    end process control_unit;

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
