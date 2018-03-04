library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

library limen_alpha;
use limen_alpha.reg_file_const.all;
use limen_alpha.sim_data_types.all;



entity reg_file_tb is
end reg_file_tb;



architecture behavioral of reg_file_tb is

	component reg_file is
		generic(	sim_en:	boolean := true
					);
		port(	clk:			in  std_logic;
				
				z_wr_en:		in  std_logic;
				z_index:		in  std_logic_vector(2 downto 0);
				z_data:		in  std_logic_vector(15 downto 0);
				y_index:		in  std_logic_vector(2 downto 0);
				x_index:		in  std_logic_vector(2 downto 0);
				
				y_data:		out  std_logic_vector(15 downto 0);
				x_data:		out  std_logic_vector(15 downto 0);
				
				sim:			out  rf_sim_data_type
				);
	end component;

	signal clk:		std_logic := '0';
	
	signal z_wr_en:	std_logic := '0';
	signal z_index:	std_logic_vector(2 downto 0) := "000";
	signal z_data:		std_logic_vector(15 downto 0) := "0000000000000000";
	signal y_index:	std_logic_vector(2 downto 0) := "001";
	signal x_index:	std_logic_vector(2 downto 0) := "001";

	signal y_data:		std_logic_vector(15 downto 0);
	signal x_data:		std_logic_vector(15 downto 0);
	
	
	signal sim:		rf_sim_data_type;
	
	
	constant CLK_PERIOD:		time := 10 ns;
	
begin

	uut: reg_file port map(
		clk =>		clk,
		z_wr_en =>	z_wr_en,
		z_index =>	z_index,
		z_data =>	z_data,
		y_index =>	y_index,
		y_data =>	y_data,
		x_index =>	x_index,
		x_data =>	x_data,
		
		sim =>		sim
		);
	
	
	clk_proc: process
	begin
		clk <= '0';
		wait for CLK_PERIOD/2;
		clk <= '1';
		wait for CLK_PERIOD/2;
	end process;
	
	
   stim_proc: process
   begin
	
		loop
		
			wait for 10 ns;
			
			z_index <= std_logic_vector(unsigned(z_index) + 1);
			z_data <= std_logic_vector(unsigned(z_data) + 1);
			y_index <= std_logic_vector(unsigned(y_index) + 3);
			x_index <= std_logic_vector(unsigned(y_index) + 5);
			
			if(z_index = RI_R0) then
				z_wr_en <= not z_wr_en;
			end if;
			
		end loop;
		
   end process;

end behavioral;