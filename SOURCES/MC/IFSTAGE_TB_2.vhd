-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
-------------------------------------------------------------------------------
ENTITY IFSTAGE_TB_2 IS
END IFSTAGE_TB_2;
-------------------------------------------------------------------------------
ARCHITECTURE behavior OF IFSTAGE_TB_2 IS

	-- Component Declaration for the Unit Under Test (UUT)
	
	COMPONENT IFSTAGE
	PORT (
		Clk			: IN STD_LOGIC;
		Reset		: IN STD_LOGIC;
		PC_LdEn		: IN STD_LOGIC;
		PC_sel		: IN STD_LOGIC;
		PC_Immed	: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		PC_In		: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		PC			: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
	END COMPONENT;

	COMPONENT EXSTAGE
	PORT (
		RF_A		: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		RF_B		: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		Immed		: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		PC			: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		ALU_Ain_sel	: IN STD_LOGIC;
		ALU_Bin_sel	: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		Op			: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		ALU_out		: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		ALU_zero	: OUT STD_LOGIC
	);
	END COMPONENT;

	COMPONENT REG
	PORT (
		CLK	: IN STD_LOGIC;
		RST	: IN STD_LOGIC;
		WE	: IN STD_LOGIC;
		d	: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		q	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
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
	SIGNAL Clk			: STD_LOGIC := '0';
	SIGNAL Reset		: STD_LOGIC := '0';
	SIGNAL RF_A			: STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL RF_B			: STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Immed		: STD_LOGIC_VECTOR(31 DOWNTO 0) := (OTHERS => '0');
	SIGNAL ALU_Ain_sel	: STD_LOGIC := '0';
	SIGNAL ALU_Bin_sel	: STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Op			: STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
	SIGNAL PC_LdEn		: STD_LOGIC := '0';	
	SIGNAL PC_sel		: STD_LOGIC := '0';
	
	--Outputs
	SIGNAL inst_dout	: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL PC			: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL ALU_out		: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL ALU_zero		: STD_LOGIC;
	SIGNAL REG_ALU_out	: STD_LOGIC_VECTOR(31 DOWNTO 0);
	
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
		PC_In		=> ALU_out,
		PC_Immed	=> REG_ALU_out,
		PC			=> PC
	);
	
	exstage_inst : EXSTAGE
	PORT MAP (
		RF_A            => RF_A,
		RF_B            => RF_B,
		Immed           => Immed,
		PC              => PC,
		ALU_Ain_sel     => ALU_Ain_sel,
		ALU_Bin_sel     => ALU_Bin_sel,
		Op              => Op,
		ALU_out         => ALU_out,
		ALU_zero        => ALU_zero
	);

	reg_alu : REG
	PORT MAP (
		CLK		=> CLK,
		RST		=> Reset,
		WE		=> '1',
		d		=> ALU_out,
		q		=> REG_ALU_out
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
		-- insert stimulus here
		-- RF_A, RF_B are not used bc this TB is for testing the equivalent of
		-- the IFSTAGE_TB of PROC_SC (1st phase of the project)
		
		ALU_Ain_sel	<= '1'; -- to always choose the PC

		--plus 4 for 4 cycles (PC = xF)
		Reset		<= '1';
		PC_LdEn		<= '1';
		PC_sel		<= '0';
		ALU_Bin_sel	<= "10";
		Immed		<= "00000000011110000011111100000000";
		WAIT FOR Clk_period*4;
		
		--wait state
		PC_LdEn	<= '0';
		WAIT FOR Clk_period*2;


		--PC+4 (PC=x13)
		Reset		<= '1';
		PC_LdEn		<= '1';
		PC_sel		<= '0';
		ALU_Bin_sel	<= "10";
		Immed		<= "00000000000000000000000111111110";
		WAIT FOR Clk_period;

		--PC+immed (PC= x13 + Immed of the last cycle)
		Reset		<= '1';
		PC_LdEn		<= '1';
		PC_sel		<= '1';
		ALU_Bin_sel	<= "01";
		Immed		<= "01111111111111111111111111111111";
		WAIT FOR Clk_period;
		

		--ovf
		Reset		<= '1';
		PC_LdEn		<= '1';
		PC_sel		<= '1';
		ALU_Bin_sel	<= "01";
		Immed		<= "00000000011110000011111100000000";
		WAIT FOR Clk_period;
		

		--plus 4 for 4 cycles
		Reset		<= '1';
		PC_LdEn		<= '1';
		PC_sel		<= '0';
		ALU_Bin_sel	<= "10";
		Immed		<= "00000000011110000011111100000000";
		WAIT FOR Clk_period*4;
		

		Reset <= '0';
		WAIT FOR Clk_period;
		

		--plus 4
		Reset		<= '1';
		PC_LdEn		<= '1';
		PC_sel		<= '0';
		ALU_Bin_sel	<= "10";
		Immed		<= "11111111111111111111111111111110";
		WAIT FOR Clk_period;
		

		--minus 4
		Reset		<= '1';
		PC_LdEn		<= '1';
		PC_sel		<= '1';
		ALU_Bin_sel	<= "01";
		Immed		<= "00000000000000000000000000000000";
		WAIT FOR Clk_period;
		

		--plus 4
		Reset		<= '1';
		PC_LdEn		<= '1';
		PC_sel		<= '0';
		ALU_Bin_sel	<= "10";
		Immed		<= "11111111111111111111111111111110";
		WAIT FOR Clk_period;
		

		--minus 4
		Reset		<= '1';
		PC_LdEn		<= '1';
		PC_sel		<= '1';
		ALU_Bin_sel	<= "01";
		Immed		<= "11111111111111111111111111111110";
		WAIT FOR Clk_period;
		

		Reset		<= '0';
		WAIT FOR 140ns;
		

		Reset		<= '1';
		PC_LdEn 	<= '0';
		WAIT FOR Clk_period;

		WAIT;
	END PROCESS;
END;
-------------------------------------------------------------------------------