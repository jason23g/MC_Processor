-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
-------------------------------------------------------------------------------
ENTITY CONTROL_MC_TB IS
END CONTROL_MC_TB;
-------------------------------------------------------------------------------
ARCHITECTURE behavior OF CONTROL_MC_TB IS

    -- Component Declaration for the Unit Under Test (UUT)

	COMPONENT CONTROL_MC
	PORT (
		CLK				: IN STD_LOGIC;
		RST				: IN STD_LOGIC;
		Opcode			: IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		ALU_Zero		: IN STD_LOGIC;
		ALU_Op			: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		ALU_Ain_sel		: OUT STD_LOGIC;
		ALU_Bin_sel		: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		RF_A_sel		: OUT STD_LOGIC;
		RF_B_sel		: OUT STD_LOGIC;
		MEM_WrEn		: OUT STD_LOGIC;
		RF_WrEn			: OUT STD_LOGIC;
		RF_WrData_sel	: OUT STD_LOGIC;
		ByteOp			: OUT STD_LOGIC;
		Immed_ctrl		: OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		PC_sel			: OUT STD_LOGIC;
		PC_LdEn			: OUT STD_LOGIC;
		IR_WrEn			: OUT STD_LOGIC
	);
	END COMPONENT;

	--Inputs
	SIGNAL CLK				: STD_LOGIC := '0';
	SIGNAL RST				: STD_LOGIC := '0';
	SIGNAL Opcode			: STD_LOGIC_VECTOR(5 DOWNTO 0) := (OTHERS => '0');
	SIGNAL ALU_Zero			: STD_LOGIC := '0';

	--Outputs
	SIGNAL ALU_Op			: STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL ALU_Ain_sel		: STD_LOGIC;
	SIGNAL ALU_Bin_sel		: STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL RF_A_sel			: STD_LOGIC;
	SIGNAL RF_B_sel			: STD_LOGIC;
	SIGNAL MEM_WrEn			: STD_LOGIC;
	SIGNAL RF_WrEn			: STD_LOGIC;
	SIGNAL RF_WrData_sel	: STD_LOGIC;
	SIGNAL ByteOp			: STD_LOGIC;
	SIGNAL Immed_ctrl		: STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL PC_sel			: STD_LOGIC;
	SIGNAL PC_LdEn			: STD_LOGIC;
	SIGNAL IR_WrEn			: STD_LOGIC;
	
	-- Clock period definitions
	CONSTANT CLK_period		: TIME := 100 ns;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	
	uut : CONTROL_MC
	PORT MAP (
		CLK				=> CLK,
		RST				=> RST,
		Opcode			=> Opcode,
		ALU_Zero		=> ALU_Zero,
		ALU_Op			=> ALU_Op,
		ALU_Ain_sel		=> ALU_Ain_sel,
		ALU_Bin_sel		=> ALU_Bin_sel,
		RF_A_sel		=> RF_A_sel,
		RF_B_sel		=> RF_B_sel,
		MEM_WrEn		=> MEM_WrEn,
		RF_WrEn			=> RF_WrEn,
		RF_WrData_sel	=> RF_WrData_sel,
		ByteOp			=> ByteOp,
		Immed_ctrl		=> Immed_ctrl,
		PC_sel			=> PC_sel,
		PC_LdEn			=> PC_LdEn,
		IR_WrEn			=> IR_WrEn
	);

	-- Clock process definitions
	CLK_PROCESS : PROCESS
	BEGIN
		CLK <= '0';
		WAIT FOR CLK_period/2;
		CLK <= '1';
		WAIT FOR CLK_period/2;
	END PROCESS;

	-- Stimulus PROCESS
	stim_proc : PROCESS
	BEGIN		
		-- hold reset state for 2 clock cycles.
		RST			<= '0';
		WAIT FOR 2*CLK_period;
		
		-- stimulus here
		RST			<= '1';
		Opcode		<= "100000";-- R-type instructions
		ALU_Zero 	<= '0';
		WAIT FOR 4*CLK_period;
		
		RST			<= '1';
		Opcode		<= "111000";--li instruction
		ALU_Zero 	<= '0';		
		WAIT FOR 4*CLK_period;
		
		RST			<= '1';
		Opcode		<= "110000";-- addi instruction 
		ALU_Zero 	<= '0';
		WAIT FOR 4*CLK_period;
		
		RST			<= '1';
		Opcode		<= "110010";-- nandi instruction
		ALU_Zero 	<= '0';
		WAIT FOR 4*CLK_period;
		
		RST			<= '1';
		Opcode		<= "110011";--ori instruction 
		ALU_Zero 	<= '0';
		WAIT FOR 4*CLK_period;
		
		RST			<= '1';
		Opcode		<= "111111";-- jump instruction
		ALU_Zero 	<= '0';
		WAIT FOR 3*CLK_period;
		
		RST			<= '1';
		Opcode		<= "000000";-- branch equal instruction
		ALU_Zero 	<= '1';
		WAIT FOR 3*CLK_period;
		
		RST			<= '1';
		Opcode		<= "000001";-- branch not equal instruction 
		ALU_Zero 	<= '0';
		WAIT FOR 3*CLK_period;
		
		RST			<= '1';
		Opcode		<= "000011";-- load byte instruction
		ALU_Zero 	<= '0';
		WAIT FOR 5*CLK_period;
		
		RST			<= '1';
		Opcode		<= "000111";-- store byte instruction
		ALU_Zero 	<= '0';
		WAIT FOR 4*CLK_period;
		
		RST			<= '1';
		Opcode		<= "001111";-- load word instruction
		ALU_Zero 	<= '0';
		WAIT FOR 5*CLK_period;
		
		RST			<= '1';
		Opcode		<= "011111";-- store byte instruction
		ALU_Zero 	<= '0';
		WAIT FOR 4*CLK_period;
		
		RST			<= '1';
		Opcode		<= "010000";-- store byte instruction
		ALU_Zero 	<= '0';
		WAIT FOR 4*CLK_period;

		RST			<= '0';
		WAIT;
	END PROCESS;
	
END;
-------------------------------------------------------------------------------