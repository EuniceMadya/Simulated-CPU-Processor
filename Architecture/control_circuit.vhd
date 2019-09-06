library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;


entity control_circuit is
	port (
		clock : in std_logic;
		instruction : in std_logic_vector(15 downto 0);
		R_IN: out std_logic_vector(3 downto 0);
		R_OUT: out std_logic_vector(3 downto 0);
		RA_IN : out std_logic;
		RG_IN : out std_logic;
		RG_OUT : out std_logic;
		DATA_OUT : OUT std_logic;
		operator : OUT std_logic_vector(3 downto 0);
		reset: in std_logic;
		next_inst: out std_logic;
		is_load : out std_logic
	);
end;

architecture behavioural of control_circuit is 

	component next_state 
		port (
			state: in std_logic_vector(4 downto 0);
			instruction: in std_logic_vector(3 downto 0);
			next_state : out std_logic_vector(4 downto 0)
		);
	end component;
		
	-- store the state
	signal current_state, transit_state : std_logic_vector(4 downto 0);

begin

	inst: next_state port map (
		state=> current_state, 
		instruction => instruction(15 downto 12), 
		next_state=> transit_state
	);

	process(current_state)
	begin
		-- Default
		R_IN <= "0000";
		R_OUT<= "0000";
		RA_IN <= '0';
		RG_IN <= '0';
		RG_OUT <= '0'; 
		DATA_OUT <= '0'; 
		operator <= "0000";
		is_load <='0';
		next_inst <='0';

		case current_state is
		
			-- Read instruction.
			when "11111" => next_inst <= '1';
			
				
			-- Read data if load instruction.
			when "11110" => 
				if(instruction(15 downto 12) = "0000" ) then
					next_inst <= '1';
				end if;
				
			-- Store data to data source if load instruction.
			when "11101" => 
				if(instruction(15 downto 12) = "0000" ) then
					is_load <= '1';
				end if;

			-- load
			when "00001" => R_IN(to_integer(UNSIGNED(instruction(11 downto 8)))) <= '1'; DATA_OUT <= '1';
			 
			-- Entering add / xor / cmp / inc
			when "00100" => R_OUT(to_integer(UNSIGNED(instruction(11 downto 8)))) <= '1'; RA_IN <= '1';
			
			-- add
			when "00101" => R_OUT(to_integer(UNSIGNED(instruction(7 downto 4))))<= '1'; operator <= "0001"; RG_IN <= '1';
			
			-- xor
			when "01001" => R_OUT(to_integer(UNSIGNED(instruction(7 downto 4))))<= '1'; operator <= "0011"; RG_IN <= '1';
			
			-- cmp
			when "01110" => R_OUT(to_integer(UNSIGNED(instruction(7 downto 4))))<= '1'; operator <= "0100"; RG_IN <= '1';
			
			-- inc
			when "10010" => operator <= "0101"; RG_IN <= '1';
			
			-- Exiting add / xor / cmp / inc
			when "00110" => R_IN(to_integer(UNSIGNED(instruction(11 downto 8)))) <= '1'; RG_OUT <= '1';

			-- mov
			when "01100" => R_IN(to_integer(UNSIGNED(instruction(11 downto 8)))) <= '1';
								 R_OUT(to_integer(UNSIGNED(instruction(7 downto 4)))) <= '1';

			--Fall back.
			when others  => R_IN <= "0000";R_OUT<= "0000";
		end case;
	end process;
	
	process(clock)
	begin
		if rising_edge(clock) then
			if(reset = '1') then
				current_state <= "11111";
			else
				current_state <= transit_state;
			end if;
		end if;
	end process;
	
end behavioural;

