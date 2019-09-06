LIBRARY ieee;
USE ieee.std_logic_1164.aLL;
USE ieee.std_logic_unsigned.all;
 
 
entity data_source is
	port (
		clock : in std_logic;
		write_enable : in std_logic;
		data_in : in std_logic_vector(15 downto 0);
		data_out : out std_logic_vector(15 downto 0);
		reset : in std_logic
	);
end;


architecture behavioural of data_source is 
	-- Trisate Buffer Component
	component tristate
		port (
			data_in : in std_logic_vector(15 downto 0);
			is_closed : in std_logic;
			data_out : out std_logic_vector(15 downto 0)
		);
	end component;

	-- Used to store data generated from external source.
	signal stored_data : std_logic_vector(15 downto 0);

begin
	reg_switch : tristate port map (
		data_in => stored_data, 
		is_closed => write_enable, 
		data_out => data_out
	);

	process(clock) is
	begin
		if (rising_edge(clock))then 
			if (reset = '1') then 
				stored_data <= "0000000000000000";
			else
				stored_data <= data_in;
			end if;
		end if;
	end process;
end behavioural;