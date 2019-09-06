library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity instantiate_project is
	port (
		SW : in std_logic_vector(9 downto 0);
		KEY : in std_logic_vector(3 downto 0);
		HEX0 : out std_logic_vector(6 downto 0);
		HEX1 : out std_logic_vector(6 downto 0);
		HEX2 : out std_logic_vector(6 downto 0);
		HEX3 : out std_logic_vector(6 downto 0)
	);
end;

architecture behavioural of instantiate_project is
	component datapath
		port (
			clock: in std_logic;
			rst : in std_logic;
			get_reg : in std_logic_vector(3 downto 0);
			reg_value : out std_logic_vector(15 downto 0)
		);
	end component;
	
	component binary_to_7Seg
		PORT (
			binary_value : IN std_logic_vector(3 downto 0);
			sevenSeg : OUT std_logic_vector(6 downto 0)
		);
	end component;
	
	signal target_reg_index : std_logic_vector(3 downto 0);
	signal target_reg_value : std_logic_vector(15 downto 0);
	
begin
	processor : datapath port map (
		clock => KEY(0),
		rst => SW(9),
		get_reg => target_reg_index,
		reg_value => target_reg_value
	);
	
	disp0 : binary_to_7Seg port map (
		binary_value => target_reg_value(3 downto 0),
		sevenSeg => HEX0
	);
	
	disp1 : binary_to_7Seg port map (
		binary_value => target_reg_value(7 downto 4),
		sevenSeg => HEX1
	);
	
	disp2 : binary_to_7Seg port map (
		binary_value => target_reg_value(11 downto 8),
		sevenSeg => HEX2
	);
	
	disp3 : binary_to_7Seg port map (
		binary_value => target_reg_value(15 downto 12),
		sevenSeg => HEX3
	);
												
	process (SW)
	begin
		if SW(0) = '1' then
			target_reg_index <= "0000";
		elsif SW(1) = '1' then
			target_reg_index <= "0001";
		elsif SW(2) = '1' then
			target_reg_index <= "0010";
		elsif SW(3) = '1' then
			target_reg_index <= "0011";
		end if;
	end process;
end behavioural;