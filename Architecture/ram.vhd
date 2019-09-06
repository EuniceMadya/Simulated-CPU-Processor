library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity ram is
	port (
		clock : in std_logic;
		write_enable : in std_logic;
		data_in : in std_logic_vector(15 downto 0);
		write_addr : in std_logic_vector(5 downto 0);
		read_addr : in std_logic_vector(5 downto 0);
		data_out : out std_logic_vector(15 downto 0)
	);
end;

architecture behavioural of ram is

	type memory is array (63 downto 0) of std_logic_vector(15 downto 0);

	function initialise_ram return memory is
		variable result : memory := (others=>(others=>'0'));
		begin
		result(0) := "00000000" & "00000000"; --LOAD R0
		result(1) := "00000000" & "10101010"; --For the sake of fun...
		
		result(2) := "00000000" & "00000000"; --LOAD R0
		result(3) := "00000000" & "00000000"; --DATA 0
		
		result(4) := "00000001" & "00000000"; --LOAD R1
		result(5) := "00000000" & "00000001"; --DATA 1
		
		result(6) := "00000010" & "00000000"; --LOAD R2
		result(7) := "00000000" & "00000010"; --DATA 2
		
		result(8) := "00000011" & "00000000"; --LOAD R3
		result(9) := "00000000" & "00000101"; --DATA 5
		
		result(10) := "00010000" & "00010000"; --ADD R0 R1
		
		result(11) := "00010010" & "00110000"; --ADD R2 R3
		
		result(12) := "00100011" & "00100000"; --MOV R3 R2
		
		result(13) := "00110000" & "00100000"; --XOR R0, R2
		
		result(14) := "01000000" & "00100000"; --CMP R0, R2
		
		result(15):= "01000000" & "00000000"; --CMP R0, R0
		
		result(16):= "01010000" & "00000000"; --INC R0
		
		result(17) := "00000011" & "00000000"; --LOAD R3
		result(18) := "00000000" & "00001010"; --DATA 10
		
		result(19) := "00110010" & "00110000"; --XOR R2, R3
		
		result(20) := "00110010" & "00100000"; --XOR R2, R2
		
		result(21) := "00010001" & "00110000"; --ADD R1, R3
		
		result(22):= "01010001" & "00000000"; --INC R1
		
		
		result(23):= "1111111111111111"; --TERMINATE
		return result;
	end initialise_ram;

	signal ram_memory : memory := initialise_ram;

begin

	process (clock)
	begin
		if rising_edge(clock) then
			data_out <= ram_memory(to_integer(unsigned(read_addr)));
		end if;
	end process;

end behavioural;


