--------------------------------------------------------------------------------
-- Description:
--------------------------------------------------------------------------------
-- Notes:
--------------------------------------------------------------------------------


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity limen_alpha_tb is
end entity limen_alpha_tb;


architecture behavior of limen_alpha_tb is
    
    -- uut ports
    signal clk   : std_logic := '0';
    signal rst   : std_logic := '0';
    signal irq_0 : std_logic := '0';
    signal irq_1 : std_logic := '0';
    
    signal mem_in   : std_logic_vector(15 downto 0);
    signal mem_we   : std_logic                     := '0';
    signal mem_addr : std_logic_vector(15 downto 0) := (others => '0');
    signal mem_out  : std_logic_vector(15 downto 0) := (others => '0');
    
    
    constant MEM_ADDR_WIDTH : integer range 0 to 16 := 8;
    
    type mem_array is array ((2 ** MEM_ADDR_WIDTH) - 1 downto 0) of std_logic_vector(15 downto 0);
    signal rwm_array : mem_array := (
        
        -- == Two investors ==
        -- there are two investors, they have shared money account
        -- investors try to invest their money with change to double it
        -- one investor is lucky, the other does not
        -- together their investments have increasing potential
        
        -- == Data address definitions ==
        -- 176 - investor1 hired
        -- 177 - shared account lock
        -- 178 - shared account balance
        
        -- 179 - investor0 money required for investment
        -- 180 - investor0 x/4 bad luck
        -- 181 - investor0 report address
        
        -- 182 - investor1 money required for investment
        -- 183 - investor1 x/4 bad luck
        -- 184 - investor1 report address
        
        -- 256 - core0 stack base (255 -> 240, 16 DB)
        -- 240 - core1 stack base (239 -> 224, 16 DB)
        
        -- == Register purpose definitions ==
        -- R7 - top of stack
        -- R6 - function return address
        -- R5 - investor0/investor1 data pointer
        -- R4 - wallet balance
        -- R3 - luck reagent
        -- R2 - auxiliary register
        -- R1 - interrupt handler only
        
        -- == Core0 entry point ==
        0 => "1000111000000010", -- LI R2, 112
        1 => "1110000000010000", -- JWL R0, R2              ; jump to investor0 initialize
        
        -- == Core0 interrupt vector ==
        4 => "1001001000000001", -- LI R1, 144
        5 => "1110000000001000", -- JWL R0, R1              ; jump to investor0 report
        
        -- == Core1 entry point ==
        8  => "1001011000000010", -- LI R2, 176
        9  => "0011100000010000", -- ST R0, R2, 0           ; investor1 has not been hired
        10 => "1001000000000011", -- LI R3, 128
        11 => "1110000000011000", -- JWL R0, R3             ; jump to investor1 initialize
        
        -- == Core1 interrupt vector ==
        12 => "1001001000000001", -- LI R1, 144
        13 => "1110000000001000", -- JWL R0, R1             ; jump to investor1 report
        
        -- == Function: lock account ==
        16 => "0011111111111010", -- ST R2, R7, -1          ; push registers to the stack
        17 => "0011111110111011", -- ST R3, R7, -2
        18 => "0011111101111100", -- ST R4, R7, -3
        
        19 => "1001011000100010", -- LI R2, 177
        20 => "0010100000010011", -- LD R3, R2, 0           ; load account lock
        21 => "1011111111011010", -- JNE R3, -1 (20)        ; repeat until account will be unlocked
        
        22 => "1000000000100100", -- LI R4, 1
        23 => "0010000000010011", -- LL R3, R2, 0           ; load linked account lock
        24 => "1011111100011010", -- JNE R3, -4 (20)        ; if locked, try it again without link
        25 => "0011000000010100", -- SC R4, R2, 0           ; try to finish atomic swap
        26 => "1011111100100011", -- JE R4, -4 (22)         ; repeat until swap will be atomic
        
        27 => "0010111101111100", -- LD R4, R7, -3          ; pop registers from the stack
        28 => "0010111110111011", -- LD R3, R7, -2
        29 => "0010111111111010", -- LD R2, R7, -1
        
        30 => "1110000000110000", -- JWL R0, R6             ; jump to return address
        
        -- == Function: withdraw from account ==
        -- out: R2 - success
        32 => "0001111110111111", -- ADD R7, R7, -2         ; create stack frame
        33 => "0011100001111011", -- ST R3, R7, 1           ; push registers to the stack
        34 => "0011100000111110", -- ST R6, R7, 0
        
        35 => "0010100000101010", -- LD R2, R5, 0           ; load money required
        36 => "1001011001000011", -- LI R3, 178
        37 => "0010100000011011", -- LD R3, R3, 0           ; load account balance
        38 => "0111000010011110", -- SLU R6, R3, R2         ; check if account has enough money
        39 => "1010000011010110", -- JE R6, +3 (42)
        --                              ; -> if not
        40 => "1000000000000010", -- LI R2, 0
        41 => "1100000001111000", -- JWL R0, +15 (56)       ; return with fail
        --                              ; -> else
        42 => "1000001000000110", -- LI R6, 16
        43 => "1110000000110110", -- JWL R6, R6             ; call lock account function
        
        44 => "1001011001000011", -- LI R3, 178
        45 => "0010100000011011", -- LD R3, R3, 0           ; load account balance with exclusive access
        46 => "0111010010011011", -- SUB R3, R3, R2
        47 => "1010000011011111", -- JGE R3, +3 (50)        ; check if account still has enough money
        --                              ; -> if not
        48 => "1000000000000010", -- LI R2, 0
        49 => "1100000000101000", -- JWL R0, +5 (54)        ; return with fail
        --                              ; -> else
        50 => "0111011010100100", -- ADD R4, R4, R2         ; add money to wallet
        51 => "1001011001000110", -- LI R6, 178
        52 => "0011100000110011", -- ST R3, R6, 0           ; write back account balance after withdraw
        53 => "1000000000100010", -- LI R2, 1                   ; return with success
        
        54 => "1001011000100110", -- LI R6, 177
        55 => "0011100000110000", -- ST R0, R6, 0           ; unlock account
        
        56 => "0010100000111110", -- LD R6, R7, 0           ; pop registers from the stack
        57 => "0010100001111011", -- LD R3, R7, 1
        58 => "0001100010111111", -- ADD R7, R7, 2          ; delete stack frame
        
        59 => "1110000000110000", -- JWL R0, R6             ; jump to return address
        
        -- == Function: invest ==
        64 => "0000000011011010", -- SLU R2, R3, 3          ; check if luck reagent is within the range
        65 => "0001100001011011", -- ADD R3, R3, 1          ; increment luck reagent value
        66 => "0101011111010010", -- SLL R2, R2, 15         ; create condition mask
        67 => "0101111111010010", -- SRA R2, R2, 15
        68 => "0110010010011011", -- AND R3, R3, R2         ; write back increased value or zero value
        
        69 => "0010100001101010", -- LD R2, R5, 1           ; load investor luck
        70 => "0111000010011010", -- SLU R2, R3, R2         ; check if investor has enough luck to double investment
        71 => "0101010001100100", -- SLL R4, R4, 1          ; double investor's money in wallet
        72 => "0101011111010010", -- SLL R2, R2, 15         ; create condition mask
        73 => "0101111111010010", -- SRA R2, R2, 15
        74 => "0110010010100100", -- AND R4, R4, R2         ; write back doubled value or zero value to wallet
        
        75 => "1110000000110000", -- JWL R0, R6             ; jump to return address
        
        -- == Function: deposit wallet to account ==
        80 => "0001111111111111", -- ADD R7, R7, -1         ; create stack frame
        81 => "0011100000111110", -- ST R6, R7, 0           ; push register to the stack
        
        82 => "1000001000000010", -- LI R2, 16
        83 => "1110000000010110", -- JWL R6, R2             ; call lock account function
        84 => "1001011001000010", -- LI R2, 178
        85 => "0010100000010110", -- LD R6, R2, 0           ; load account balance with exclusive access
        86 => "0111011100110110", -- ADD R6, R6, R4
        87 => "0011100000010110", -- ST R6, R2, 0           ; add money from the wallet to the account
        88 => "0011111111010000", -- ST R0, R2, -1          ; unlock account
        89 => "1000000000000100", -- LI R4, 0                   ; set wallet value to zero
        
        90 => "0010100000111110", -- LD R6, R7, 0           ; pop register from the stack
        91 => "0001100001111111", -- ADD R7, R7, 1          ; delete stack frame
        
        92 => "1110000000110000", -- JWL R0, R6             ; jump to return address
        
        -- == Investor life cycle ==
        96 => "0111110000000000", -- RTC R0, MSR                ; enable interrupts
        
        97  => "1000010000000010", -- LI R2, 32
        98  => "1110000000010110", -- JWL R6, R2                ; call withdraw from account function
        99  => "1011111110010011", -- JE R2, -2 (97)            ; repeat until there is enough money to withdraw
        100 => "1000100000000010", -- LI R2, 64
        101 => "1110000000010110", -- JWL R6, R2                ; call invest function
        102 => "1000101000000010", -- LI R2, 80
        103 => "1110000000010110", -- JWL R6, R2                ; call deposit wallet to account function
        104 => "1101111111001000", -- JWL R0, -7 (97)       ; repeat
        
        -- == Investor0 initialize ==
        112 => "1001011000000010", -- LI R2, 176
        113 => "0011100001010000", -- ST R0, R2, 1          ; create account
        114 => "1000001010000011", -- LI R3, 20
        115 => "0011100010010011", -- ST R3, R2, 2          ; perform first deposit
        116 => "1000000000100011", -- LI R3, 1
        117 => "0011100000010011", -- ST R3, R2, 0          ; hire investor1
        
        118 => "1000000000101111", -- LIS R7, 1             ; initialize stack for core0
        
        119 => "1001011001100101", -- LI R5, 179                ; initialize investor0 data pointer
        120 => "1000000011100010", -- LI R2, 7
        121 => "0011100000101010", -- ST R2, R5, 0          ; set money required by investor0 for investment
        122 => "1000000000100010", -- LI R2, 1
        123 => "0011100001101010", -- ST R2, R5, 1          ; set investor0 luck
        124 => "1000000000000100", -- LI R4, 0                  ; set investor0 wallet value to zero
        125 => "1000000000000011", -- LI R3, 0                  ; set investor0 luck reagent to zero
        
        126 => "1000110000000010", -- LI R2, 96
        127 => "1110000000010000", -- JWL R0, R2                ; jump to investor life cycle
        
        -- == Investor1 initialize ==
        128 => "0010100000010011", -- LD R3, R2, 0
        129 => "1011111111011011", -- JE R1, -1 (128)       ; wait until investor1 will be hired
        
        130 => "1001111000000111", -- LI R7, 240                ; initialize stack for core1
        
        131 => "1001011011000101", -- LI R5, 182                ; initialize investor1 data pointer
        132 => "1000000100000010", -- LI R2, 8
        133 => "0011100000101010", -- ST R2, R5, 0          ; set money required by investor1 for investment
        134 => "1000000001100010", -- LI R2, 3
        135 => "0011100001101010", -- ST R2, R5, 1          ; set investor1 luck
        136 => "1000000000000100", -- LI R4, 0                  ; set investor1 wallet value to zero
        137 => "1000000000000011", -- LI R3, 0                  ; set investor1 luck reagent to zero
        
        138 => "1000110000000010", -- LI R2, 96
        139 => "1110000000010000", -- JWL R0, R2                ; jump to investor life cycle
        
        -- == Core0 + core1 interrupt handler ==
        144 => "0011100010101110", -- ST R6, R5, 2          ; store wallet value to report address
        145 => "0111111000001001", -- CTR R1, SIP               ; load address of next instruction after interrupt
        146 => "0111110000000000", -- RTC R0, MSR               ; enable interrupts
        147 => "1110000000001000", -- JWL R0, R1                ; jump back to next instruction
        
        others => (others => '-')
        );
    
    
    constant CLK_PERIOD : time := 10 ns;
    
begin
    
    -- instantiate the unit under test (uut)
    uut : entity work.limen_alpha(rtl)
        port map (
            clk   => clk,
            rst   => rst,
            irq_0 => irq_0,
            irq_1 => irq_1,
            
            mem_in   => mem_in,
            mem_we   => mem_we,
            mem_addr => mem_addr,
            mem_out  => mem_out
        ); 
    
    clk_proc : process is
    begin
        clk <= '0';
        wait for CLK_PERIOD/2;
        clk <= '1';
        wait for CLK_PERIOD/2;
    end process clk_proc;
    
    
    irq_proc : process is
    begin
        
        wait for 1575 ns;
        
        irq_0 <= '1';
        wait for 50 ns;
        
        irq_0 <= '0';
        wait for 2090 ns;
        
        irq_0 <= '1';
        irq_1 <= '1';
        wait for 50 ns;
        
        irq_0 <= '0';
        wait for 250 ns;
        
        irq_1 <= '0';
        wait;
        
    end process irq_proc;
    
    
    stim_proc : process is
    begin
        rst <= '1';
        wait for 10 ns;
        rst <= '0';
        wait;
    end process stim_proc;
    
    
    mem_proc : process (clk) is
    begin
        if(rising_edge(clk)) then
            
            if(mem_we = '1') then
                rwm_array(to_integer(unsigned(mem_addr))) <= mem_out;
            end if;
            
            if(to_integer(unsigned(mem_addr)) < 2 ** MEM_ADDR_WIDTH) then
                mem_in <= rwm_array(to_integer(unsigned(mem_addr)));
            end if;
            
        end if;
    end process mem_proc;
    
end architecture behavior;


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
