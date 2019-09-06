library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
 
 
entity program_counter is
	port (
		clock : in std_logic;
		next_instruction : in std_logic;
		reset : in std_logic;
		counter : out std_logic_vector(5 downto 0)
	);
end;


architecture behavioural of program_counter is 

	signal internal_counter : std_logic_vector(5 downto 0);

begin
	counter <= internal_counter;

	process(clock) is
	begin
		if (rising_edge(clock))then 
		
			if (reset = '1') then 
				internal_counter <= "000000";
				
			elsif (next_instruction = '1') then
				internal_counter <= internal_counter + 1;
			end if;
			
		end if;
	end process;
end behavioural;