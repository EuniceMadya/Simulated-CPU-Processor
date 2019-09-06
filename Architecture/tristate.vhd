LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;


-- 
 -- Tristate Buffer.
 -- data_in : input data.
 -- closed : 0 open circuit, 1 closed circuit.
 -- data_out : output data.
 --


entity tristate is
	port (
		data_in : in std_logic_vector(15 downto 0);
		is_closed : in std_logic;
		data_out : out std_logic_vector(15 downto 0)
	);
end;


architecture behavioural of tristate is 
begin

	process(data_in, is_closed) is
	begin
		if (is_closed = '1') then
			data_out <= data_in;
		else
			data_out <= (OTHERS => 'Z');
		end if;
	end process;
	
end behavioural;
