library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

use work.core_shared.all;
use work.reg_file_port.all;
use work.alu_port.all;
use work.jmp_tester_port.all;


entity core is
    generic (
        INT_ADDR   : std_logic_vector(15 downto 0);
        IP_REG_RST : std_logic_vector(15 downto 0);
        PRNG_SEED  : std_logic_vector(15 downto 0)
        );
    port (
        clk : in std_logic;
        rst : in std_logic;
        irq : in std_logic;

        mem_excl  : in  std_logic;
        sync_ack  : in  std_logic;
        mem_yield : out std_logic;
        sync_req  : out std_logic;

        mem_in   : in  std_logic_vector(15 downto 0);
        mem_we   : out std_logic;
        mem_addr : out std_logic_vector(15 downto 0);
        mem_out  : out std_logic_vector(15 downto 0)
        );
end entity core;


architecture rtl of core is

    constant CLK_PHASE_0 : std_logic_vector(1 downto 0) := "00";
    constant CLK_PHASE_1 : std_logic_vector(1 downto 0) := "01";
    constant CLK_PHASE_2 : std_logic_vector(1 downto 0) := "10";
    constant CLK_PHASE_3 : std_logic_vector(1 downto 0) := "11";

    constant REG_MSR  : std_logic_vector(2 downto 0) := "000";
    constant REG_SIP  : std_logic_vector(2 downto 0) := "001";
    constant REG_PRNG : std_logic_vector(2 downto 0) := "010";

    constant REG_MSR_RST : std_logic_vector(15 downto 0) := x"0001";

    signal rf_z_we    : std_logic;
    signal rf_z_index : std_logic_vector(2 downto 0);
    signal rf_z_data  : std_logic_vector(15 downto 0);
    signal rf_y_index : std_logic_vector(2 downto 0);
    signal rf_y_data  : std_logic_vector(15 downto 0);
    signal rf_x_index : std_logic_vector(2 downto 0);
    signal rf_x_data  : std_logic_vector(15 downto 0);

    signal se_data_out : std_logic_vector(15 downto 0);

    signal alu_operation_reg : std_logic_vector(3 downto 0);
    signal alu_sub_add_reg   : std_logic;
    signal alu_operand_l_reg : std_logic_vector(15 downto 0);
    signal alu_operand_r_reg : std_logic_vector(15 downto 0);
    signal alu_result        : std_logic_vector(15 downto 0);

    signal inst_alu_operation : std_logic_vector(3 downto 0);
    signal inst_alu_operand_l : std_logic_vector(15 downto 0);
    signal inst_alu_operand_r : std_logic_vector(15 downto 0);

    signal jt_jmp_type_reg  : std_logic_vector(2 downto 0);
    signal jt_test_data_reg : std_logic_vector(15 downto 0);
    signal jt_jmp_ack       : std_logic;

    signal clk_phase  : std_logic_vector(1 downto 0);
    signal sync_phase : std_logic_vector(1 downto 0);

    signal ip_reg : std_logic_vector(15 downto 0) := (others => '-');
    signal ir_reg : std_logic_vector(15 downto 0);

    signal inc_ip_reg     : std_logic_vector(15 downto 0);
    signal alu_result_reg : std_logic_vector(15 downto 0);

    signal opcode       : std_logic_vector(2 downto 0);
    signal ll_inst_dec  : std_logic;
    signal ld_inst_dec  : std_logic;
    signal sc_inst_dec  : std_logic;
    signal st_inst_dec  : std_logic;
    signal rtc_inst_dec : std_logic;
    signal ctr_inst_dec : std_logic;

    signal alu_mem_en    : std_logic;
    signal next_ip       : std_logic_vector(15 downto 0);
    signal alu_ldimm_opc : std_logic_vector(3 downto 0);

    signal msr_reg  : std_logic_vector(15 downto 0);
    signal sip_reg  : std_logic_vector(15 downto 0) := (others => '-');
    signal prng_reg : std_logic_vector(15 downto 0);

    signal c_reg_index : std_logic_vector(2 downto 0);
    signal c_reg_d_in  : std_logic_vector(15 downto 0);
    signal c_reg_d_out : std_logic_vector(15 downto 0);

begin

    opcode <= ir_reg(15 downto 13);

    ll_inst_dec <= '1' when opcode = OPCODE_TSIMM and ir_reg(12 downto 11) = "00"
                   else '0';

    ld_inst_dec <= '1' when opcode = OPCODE_TSIMM and ir_reg(12 downto 11) = "01"
                   else '0';

    sc_inst_dec <= '1' when opcode = OPCODE_TSIMM and ir_reg(12 downto 11) = "10"
                   else '0';

    st_inst_dec <= '1' when opcode = OPCODE_TSIMM and ir_reg(12 downto 11) = "11"
                   else '0';

    rtc_inst_dec <= '1' when opcode = OPCODE_ALREG and ir_reg(12 downto 9) = "1110"
                    else '0';

    ctr_inst_dec <= '1' when opcode = OPCODE_ALREG and ir_reg(12 downto 9) = "1111"
                    else '0';

    mem_yield <= '1' when clk_phase = CLK_PHASE_1
                 else '0';

    sync_req <= ll_inst_dec or sc_inst_dec when clk_phase = CLK_PHASE_0
                else '0';

    mem_we <= sc_inst_dec or st_inst_dec when clk_phase = CLK_PHASE_0
              else '0';

    mem_addr <= ip_reg when alu_mem_en = '0'
                else alu_result;

    mem_out <= rf_x_data;

    c_reg_index <= ir_reg(5 downto 3);

    c_reg_d_in <= rf_x_data;

    reg_file_0 : entity work.reg_file(rtl)
        port map (
            clk => clk,

            z_we    => rf_z_we,
            z_index => rf_z_index,
            z_data  => rf_z_data,

            y_index => rf_y_index,
            y_data  => rf_y_data,

            x_index => rf_x_index,
            x_data  => rf_x_data
            );

    rf_z_we <= '1' when clk_phase = CLK_PHASE_1
               else '0';

    rf_z_index <= REG_R0 when st_inst_dec = '1' or opcode = OPCODE_CJSIMM
                  else ir_reg(2 downto 0);

    rf_z_data <= (14 downto 0 => '0') & sync_ack when sc_inst_dec = '1' else
                 mem_in      when ld_inst_dec = '1' or ll_inst_dec = '1' else
                 inc_ip_reg  when opcode = OPCODE_JSIMM or opcode = OPCODE_JREG else
                 c_reg_d_out when ctr_inst_dec = '1'
                 else alu_result_reg;

    rf_y_index <= ir_reg(2 downto 0) when opcode = OPCODE_LDIMM
                  else ir_reg(5 downto 3);

    rf_x_index <= ir_reg(2 downto 0) when st_inst_dec = '1' or sc_inst_dec = '1'
                  else ir_reg(8 downto 6);

    sign_extend_0 : entity work.sign_extend(rtl)
        port map (
            opcode   => opcode,
            data_in  => ir_reg(12 downto 3),
            data_out => se_data_out
            );

    alu_0 : entity work.alu(rtl)
        port map (
            operation => alu_operation_reg,
            sub_add   => alu_sub_add_reg,
            operand_l => alu_operand_l_reg,
            operand_r => alu_operand_r_reg,
            result    => alu_result
            );

    alu_ldimm_opc <= ALU_R when ir_reg(4) = '0'
                     else "111" & ir_reg(3);

    with opcode select inst_alu_operation <=
        ir_reg(12 downto 9)         when OPCODE_ALREG,
        '0' & ir_reg(12 downto 10)  when OPCODE_LIMM,
        "10" & ir_reg(12 downto 11) when OPCODE_ASIMM,
        ALU_L                       when OPCODE_JREG,
        alu_ldimm_opc               when OPCODE_LDIMM,
        ALU_ADD                     when others;

    inst_alu_operand_l <= ip_reg when opcode = OPCODE_CJSIMM or opcode = OPCODE_JSIMM
                          else rf_y_data;

    inst_alu_operand_r <= rf_x_data when opcode = OPCODE_ALREG
                          else se_data_out;

    jmp_tester_0 : entity work.jmp_tester(rtl)
        port map (
            jmp_type  => jt_jmp_type_reg,
            test_data => jt_test_data_reg,
            jmp_ack   => jt_jmp_ack
            );

    alu_mem_en <= '1' when clk_phase = CLK_PHASE_0
                  else '0';

    next_ip <= inc_ip_reg when jt_jmp_ack = '0'
               else alu_result;

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
                clk_phase       <= CLK_PHASE_0;
                ir_reg          <= INST_NOP;
                inc_ip_reg      <= IP_REG_RST;
                msr_reg         <= REG_MSR_RST;
                jt_jmp_type_reg <= JMP_NEVER;
            else

                case clk_phase is
                    when CLK_PHASE_0 => clk_phase <= sync_phase;
                    when CLK_PHASE_1 => clk_phase <= CLK_PHASE_2;
                    when CLK_PHASE_2 => clk_phase <= CLK_PHASE_3;
                    when CLK_PHASE_3 => clk_phase <= CLK_PHASE_0;
                    when others      => clk_phase <= (others => 'X');
                end case;

                case opcode is
                    when OPCODE_CJSIMM              => jt_jmp_type_reg <= ir_reg(2 downto 0);
                    when OPCODE_JSIMM | OPCODE_JREG => jt_jmp_type_reg <= JMP_ALWAYS;
                    when others                     => jt_jmp_type_reg <= JMP_NEVER;
                end case;

                jt_test_data_reg <= rf_y_data;

                if ((clk_phase = CLK_PHASE_0 or clk_phase = CLK_PHASE_1) and mem_excl = '1') then
                    alu_operation_reg <= ALU_ADD;
                    alu_sub_add_reg   <= '0';
                    alu_operand_l_reg <= ip_reg;
                    alu_operand_r_reg <= std_logic_vector(to_signed(1, alu_operand_r_reg'length));
                else
                    alu_operation_reg <= inst_alu_operation;
                    alu_sub_add_reg   <= (inst_alu_operation(3) and not inst_alu_operation(2)) and
                                       not (inst_alu_operation(1) and inst_alu_operation(0));
                    alu_operand_l_reg <= inst_alu_operand_l;
                    alu_operand_r_reg <= inst_alu_operand_r;
                end if;

                if (clk_phase = CLK_PHASE_0 and mem_excl = '1') then
                    alu_result_reg <= alu_result;

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
                    inc_ip_reg <= alu_result;
                end if;

            end if;
        end if;
    end process control_unit;

end architecture rtl;


---------------------------------------------------------------------------------
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
