library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;


 --
 -- Compute Next State
 --

 
entity next_state is
	port (
		state: in std_logic_vector(4 downto 0);
		instruction: in std_logic_vector(3 downto 0);
		next_state : out std_logic_vector(4 downto 0)
	);
end;


architecture behaviour of next_state is
begin
	process(instruction, state) is
	begin			
		-- Load a new Instruction 
		if state = "11111" then
			next_state <= "11110";
			
		-- Load data if instruction is "load"
		elsif state = "11110" then
			next_state <= "11101";
			
		-- Load data if instruction is "load"
		elsif state = "11101" then
			next_state <= "11100";
			
			
		-- Enter Terminate State
		elsif instruction = "1111" and state = "11111" then
			next_state <= "00000";
			
		-- New load instruction.
		elsif instruction = "0000" and state = "11100" then
			next_state <= "00001";
			
		-- New add instruction.
		elsif instruction = "0001" and state = "11100" then
			next_state <= "00100";

		-- New mov instruction.
		elsif instruction = "0010" and state = "11100" then
			next_state <= "01100";

		-- New xor instruction.
		elsif instruction = "0011" and state = "11100" then
			next_state <= "00100";

		-- New cmp instruction.
		elsif instruction = "0100" and state = "11100" then
			next_state <= "00100";
		
		-- New inc instruction.
		elsif instruction = "0101" and state = "11100" then
			next_state <= "00100";
				
		-- Executing load instruction.
		elsif instruction = "0000" then
			case state is
				when "00001" => next_state <= "00010";
				when "00010" => next_state <= "11111";
				when others => next_state <= "00000";
			end case;
	
		-- Executing add instruction.
		elsif instruction = "0001" then
			case state is
				when "00100" => next_state <= "00101";
				when "00101" => next_state <= "00110";
				when "00110" => next_state <= "11111";
				when others => next_state <= "00000";
			end case;	
			
		-- Executing mov instruction.
		elsif instruction = "0010" then
			case state is
				when "01100" => next_state <= "11111";
				when others => next_state <= "00000";
			end case;	
			
		-- Executing xor instruction.
		elsif instruction = "0011" then
			case state is
				when "00100" => next_state <= "01001";
				when "01001" => next_state <= "00110";
				when "00110" => next_state <= "11111";
				when others => next_state <= "00000";
			end case;	
			
		-- Executing cmp instruction.
		elsif instruction = "0100" then
			case state is
				when "00100" => next_state <= "01110";
				when "01110" => next_state <= "00110";
				when "00110" => next_state <= "11111";
				when others => next_state <= "00000";
			end case;
			
		-- Executing inc instruction.
		elsif instruction = "0101" then
			case state is
				when "00100" => next_state <= "10010";
				when "10010" => next_state <= "00110";
				when "00110" => next_state <= "11111";
				when others => next_state <= "00000";
			end case;		
		end if;
	end process;
end behaviour;
