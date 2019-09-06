library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity reg is
	port (
		clock : in std_logic;
		read_enable : in std_logic;
		write_enable : in std_logic;
		peek_value : out std_logic_vector(15 downto 0);
		data_in : in std_logic_vector(15 downto 0);
		data_out : out std_logic_vector(15 downto 0);
		reset : in std_logic
	);
end;


architecture behavioural of reg is 
	-- Trisate Buffer
	component tristate
		port (
			data_in : in std_logic_vector(15 downto 0);
			is_closed : in std_logic;
			data_out : out std_logic_vector(15 downto 0)
		);
	end component;

	-- Used to store data saved in the register.
	signal stored_data : std_logic_vector(15 downto 0);

begin

	reg_switch : tristate port map (
		data_in => stored_data, 
		is_closed => write_enable, 
		data_out => data_out
	);
	
	peek_value <= stored_data;

	process(clock) is
	begin
		if (rising_edge(clock))then 
			if (reset = '1') then 
				stored_data <= "0000000000000000";
			elsif (read_enable = '1') then
				stored_data <= data_in;
			end if;
		end if;
	end process;
end behavioural;