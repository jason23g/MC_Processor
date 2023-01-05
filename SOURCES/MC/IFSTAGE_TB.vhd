-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
-------------------------------------------------------------------------------
ENTITY IFSTAGE_TB IS
END IFSTAGE_TB;
--------------------------------------------------------------------------------
ARCHITECTURE behavior OF IFSTAGE_TB IS

	-- Component Declaration for the Unit Under Test (UUT)

	COMPONENT IFSTAGE
	PORT (
		Clk			: IN STD_LOGIC;
		Reset		: IN STD_LOGIC;
		PC_LdEn		: IN STD_LOGIC;
		PC_sel		: IN STD_LOGIC;
		PC_In		: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		PC_Immed	: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		PC			: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
	END COMPONENT;
	
	COMPONENT RAM
	PORT (
		clk				: IN STD_LOGIC;
		inst_addr		: IN STD_LOGIC_VECTOR(10 DOWNTO 0);
		inst_dout		: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		data_we			: IN STD_LOGIC;
		data_addr		: IN STD_LOGIC_VECTOR(10 DOWNTO 0);
		data_din		: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		data_dout		: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
	END COMPONENT;

	--Inputs
	SIGNAL Clk		: STD_LOGIC := '0';
	SIGNAL Reset	: STD_LOGIC := '0';
	SIGNAL PC_LdEn	: STD_LOGIC := '0';
	SIGNAL PC_sel	: STD_LOGIC := '0';
	SIGNAL PC_In	: STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL PC_Immed	: STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	
	--Outputs
	SIGNAL PC			: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL inst_dout	: STD_LOGIC_VECTOR(31 DOWNTO 0);
	
	-- Clock period definitions
	CONSTANT Clk_period : TIME := 100 ns;

BEGIN

	-- Instantiate the Unit Under Test (UUT)
	uut : IFSTAGE
	PORT MAP (
		Clk			=> Clk,
		Reset		=> Reset,
		PC_LdEn		=> PC_LdEn,
		PC_sel		=> PC_sel,
		PC_In		=> PC_In,
		PC_Immed	=> PC_Immed,
		PC			=> PC
	);
	
	ram_inst : RAM
	PORT MAP (
		clk			=> Clk,
		inst_addr	=> PC(12 DOWNTO 2),
		inst_dout	=> inst_dout,
		data_we		=> '0',
		data_addr	=> "00100000000",
		data_din	=> x"00000000"
	);
	
	-- Clock process definitions
	Clk_process : PROCESS
	BEGIN
		Clk <= '0';
		WAIT FOR Clk_period/2;
		Clk <= '1';
		WAIT FOR Clk_period/2;
	END PROCESS;
	
	-- Stimulus process
	stim_proc : PROCESS
	BEGIN
		-- hold reset state for 4 cycles.
		Reset <= '0';
		WAIT FOR Clk_period*3;


		-- will select the first word
		Reset		<= '1';
		PC_LdEn		<= '1';
		PC_sel		<= '0';
		PC_In		<= x"00000000";
		PC_Immed	<= x"00000004";
		WAIT FOR Clk_period;


		-- will select the second word
		Reset		<= '1';
		PC_LdEn		<= '1';
		PC_sel		<= '1';
		PC_In		<= x"00000000";
		PC_Immed	<= x"00000004";
		WAIT FOR Clk_period;


		Reset		<= '1';
		PC_LdEn		<= '1';
		PC_sel		<= '1';
		PC_In		<= x"00000078";
		PC_Immed	<= x"000000AF";
		WAIT FOR Clk_period;


		Reset		<= '1';
		PC_LdEn		<= '0';
		PC_sel		<= '0';
		PC_In		<= x"00000018";
		PC_Immed	<= x"000000B9";
		WAIT FOR Clk_period;


		Reset		<= '1';
		PC_LdEn		<= '0';
		PC_sel		<= '1';
		PC_In		<= x"00000018";
		PC_Immed	<= x"000000B9";
		WAIT FOR Clk_period;


		Reset		<= '1';
		PC_LdEn		<= '1';
		PC_sel		<= '0';
		PC_In		<= x"00000458";
		PC_Immed	<= x"00000018";
		WAIT FOR Clk_period;

		
		WAIT;
	END PROCESS;

END;
-------------------------------------------------------------------------------