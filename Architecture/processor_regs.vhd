library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity processor_regs is
	port(
		clock : in std_logic;
		R_IN_RAM : in std_logic_vector(3 downto 0);
		R_OUT_RAM : in std_logic_vector(3 downto 0);
		R_PEEK_RAM : in std_logic_vector(3 downto 0);
		data_in : in std_logic_vector(15 downto 0);
		data_out : out std_logic_vector(15 downto 0);
		peek_value : out std_logic_vector(15 downto 0);
		reset : in std_logic
	);
end;

architecture behavioural of processor_regs is
	-- Register
	component reg 
		port (
			clock : in std_logic;
			read_enable : in std_logic;
			write_enable : in std_logic;
			data_in : in std_logic_vector(15 downto 0);
			data_out : out std_logic_vector(15 downto 0);
			reset : in std_logic;
			peek_value : out std_logic_vector(15 downto 0)
		);
	end component;

	signal reg_values: std_logic_vector(63 downto 0);

begin
			
	reg0 : reg port map(
		clock => clock,
		read_enable => R_IN_RAM(0),
		write_enable => R_OUT_RAM(0),
		peek_value => reg_values(15 downto 0), 
		data_in => data_in,
		data_out => data_out,
		reset => reset
	);
								
	reg1 : reg port map(
		clock => clock,
		read_enable => R_IN_RAM(1),
		write_enable => R_OUT_RAM(1),
		peek_value => reg_values(31 downto 16), 
		data_in => data_in,
		data_out => data_out,
		reset => reset
	);
								
	reg2 : reg port map(
		clock => clock,
		read_enable => R_IN_RAM(2),
		write_enable => R_OUT_RAM(2),
		peek_value => reg_values(47 downto 32), 
		data_in => data_in,
		data_out => data_out,
		reset => reset
	);
								
	reg3 : reg port map(
		clock => clock,
		read_enable => R_IN_RAM(3),
		write_enable => R_OUT_RAM(3),
		peek_value => reg_values(63 downto 48), 
		data_in => data_in,
		data_out => data_out,
		reset => reset
	);
		
	peek_value <= reg_values(to_integer(UNSIGNED(R_PEEK_RAM))*16 +15  downto to_integer(UNSIGNED(R_PEEK_RAM)) *16);
								
end behavioural;