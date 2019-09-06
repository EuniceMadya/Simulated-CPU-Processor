LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_unsigned.all;

entity datapath is
	port (
		clock: in std_logic;
		rst : in std_logic;
		get_reg : in std_logic_vector(3 downto 0);
		reg_value : out std_logic_vector(15 downto 0)
	);
	end;
	
	
architecture behaviour of datapath is

	-- Control Circuit
	component control_circuit 
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
			reset : in std_logic;
			next_inst: out std_logic;
			is_load : out std_logic
		);
	end component;


	-- Register
	component reg 
		port (
			clock : in std_logic;
			read_enable : in std_logic;
			write_enable : in std_logic;
			data_in : in std_logic_vector(15 downto 0);
			data_out : out std_logic_vector(15 downto 0);
			reset : in std_logic
		);

	end component;


	-- Program Counter
	component program_counter
		port (
			clock : in std_logic;
			next_instruction : in std_logic;
			reset : in std_logic;
			counter : out std_logic_vector(5 downto 0)
		);
	end component;


	-- Processor Registers
	component processor_regs 
		port (
			clock : in std_logic;
			R_IN_RAM : in std_logic_vector(3 downto 0);
			R_OUT_RAM : in std_logic_vector(3 downto 0);
			data_in : in std_logic_vector(15 downto 0);
			data_out : out std_logic_vector(15 downto 0);
			reset : in std_logic;
			R_PEEK_RAM : in std_logic_vector(3 downto 0);
			peek_value : out std_logic_vector(15 downto 0)
		);

	end component;

	-- ALU
	component alu
		port (
			operator : in std_logic_vector(3 downto 0);
			data_in_1 : in std_logic_vector(15 downto 0);
			data_in_2 : in std_logic_vector(15 downto 0);
			data_out : out std_logic_vector(15 downto 0);
			reset: in std_logic
		);
	end component;


	-- External Data
	component data_source
		port (
			clock : in std_logic;
			write_enable : in std_logic;
			data_in : in std_logic_vector(15 downto 0);
			data_out : out std_logic_vector(15 downto 0);
			reset : in std_logic
		);
	end component;

	-- RAM
	component ram
		port (
			clock : in std_logic;
			write_enable : in std_logic;
			data_in : in std_logic_vector(15 downto 0);
			write_addr : in std_logic_vector(5 downto 0);
			read_addr : in std_logic_vector(5 downto 0);
			data_out : out std_logic_vector(15 downto 0)
		);
	end component;

	-- Intermedia signals to store control signals.
	signal R_temp_In, R_temp_OUT, operator_temp : std_logic_vector(3 downto 0);
	signal RA_temp_IN, RG_temp_IN, RG_temp_OUT, DATA_temp_OUT, next_instruction_temp, is_load_temp : std_logic;
	signal internal_bus : std_logic_vector(15 downto 0);
	signal RA_OUT, RG_IN : std_logic_vector(15 downto 0);
	signal pc_temp : std_logic_vector(5 downto 0);

	signal instruction_temp, external_data_temp: std_logic_vector(15 downto 0);
	signal ram_out_temp : std_logic_vector(15 downto 0);
				
begin

	control_circuit_instance : control_circuit port map(
		clock => clock, 
		instruction => instruction_temp, 
		R_IN => R_temp_IN, 
		R_OUT => R_temp_OUT,
		RA_IN => RA_temp_IN, 
		RG_IN => RG_temp_IN, 
		RG_OUT =>RG_temp_OUT,
		DATA_OUT => DATA_temp_OUT,
		operator => operator_temp, 
		reset => rst,
		next_inst => next_instruction_temp,
		is_load => is_load_temp
	);
	
	pc_instance : program_counter port map(
		clock => clock,
		next_instruction => next_instruction_temp,																													
		reset => rst,
		counter => pc_temp
	);
		
	regs : processor_regs port map(
		clock => clock,
		R_IN_RAM => R_temp_IN,
		R_OUT_RAM => R_temp_OUT,
		data_in => internal_bus,
		data_out => internal_bus,
		reset => rst,
		peek_value => reg_value,
		R_PEEK_RAM => get_reg
	);

	regA : reg port map(
		clock => clock,
		read_enable => RA_temp_IN,
		write_enable => '1',
		data_in => internal_bus,
		data_out => RA_OUT,
		reset => rst
	);
								
	regG : reg port map(
		clock => clock,
		read_enable => RG_temp_IN,
		write_enable => RG_temp_OUT,
		data_in => RG_IN,
		data_out => internal_bus,
		reset => rst
	);
								
	ALU_instance: alu port map(
		operator => operator_temp,
		data_in_1 => RA_OUT,
		data_in_2 => internal_bus,
		data_out => RG_IN,
		reset => rst
	);
	
	external_data : data_source port map (
		clock => clock,
		write_enable => DATA_temp_OUT,
		data_in => external_data_temp,
		data_out => internal_bus,
		reset => rst
	);
	
	ram_storage : ram port map (
		clock => clock,
		write_enable => '0',
		data_in => "1111111111111111",
		write_addr => "000000",
		read_addr => pc_temp,
		data_out => ram_out_temp
	);
														
	process(clock) is
	begin
		if(rising_edge(clock)) then
			-- Read a new instruction.
			if (next_instruction_temp = '1' and is_load_temp = '0') then
				instruction_temp <= ram_out_temp;
			end if;
			
			-- Read data.
			if(is_load_temp = '1') then
				external_data_temp <= ram_out_temp;
			end if;
		end if;
	end process;
	
end behaviour;