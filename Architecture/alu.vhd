LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;


-- Arithmetic Logic Unit
 -- add : 1 add two vectors, 0 xor two vectors.
 -- data_in_1 : first vector.
 -- data_in_2 : second vector.
 -- data_out : resultant vector.
 --

 
entity alu is
	port (
		operator : in std_logic_vector(3 downto 0);
		data_in_1 : in std_logic_vector(15 downto 0);
		data_in_2 : in std_logic_vector(15 downto 0);
		data_out : out std_logic_vector(15 downto 0);
		reset : in std_logic
	);
end;


architecture behavioural of alu is

begin

	process(operator, data_in_1, data_in_2) is
	begin
		if(reset = '1') then
			data_out <= "0000000000000000";
		end if;
		
		-- ADD
		if (operator = "0001") then
			data_out <= data_in_1 + data_in_2;
			
		-- XOR
		elsif (operator = "0011") then
			data_out <= data_in_2 xor data_in_1;
			
		-- CMP
		elsif (operator = "0100") then
			data_out <= data_in_2 - data_in_1;
			
		-- INC
		elsif (operator = "0101") then
			data_out <= data_in_1 + "0001";
		end if;
	end process;
	
end behavioural;