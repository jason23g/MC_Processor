-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
-------------------------------------------------------------------------------
ENTITY DATAPATH_TB_2 IS
END DATAPATH_TB_2;
-------------------------------------------------------------------------------
ARCHITECTURE behavior OF DATAPATH_TB_2 IS

	-- Component Declaration for the Unit Under Test (UUT)

	COMPONENT DATAPATH
	PORT (
		CLK				: IN STD_LOGIC;
		RST				: IN STD_LOGIC;
		PC_LdEn			: IN STD_LOGIC;
		PC_sel			: IN STD_LOGIC;
		RF_WrEn			: IN STD_LOGIC;
		RF_WrData_sel	: IN STD_LOGIC;
		RF_A_sel		: IN STD_LOGIC;
		RF_B_sel		: IN STD_LOGIC;
		Immed_ctrl		: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		ALU_Ain_sel		: IN STD_LOGIC;
		ALU_Bin_sel		: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		Op				: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		ByteOp			: IN STD_LOGIC;
		MEM_WrEn		: IN STD_LOGIC;
		ALU_zero		: OUT STD_LOGIC;
		REG_A_WrEn		: IN STD_LOGIC;
		REG_B_WrEn		: IN STD_LOGIC;
		REG_ALU_WrEn	: IN STD_LOGIC;
		Instr			: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		MM_RdData		: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		MM_Addr			: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		MM_WrEn			: OUT STD_LOGIC;
		MM_WrData		: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		PC				: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
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

	COMPONENT REG
	PORT (
		CLK	: IN STD_LOGIC;
		RST	: IN STD_LOGIC;
		WE	: IN STD_LOGIC;
		d	: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		q	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
	END COMPONENT;

	--Inputs
	SIGNAL CLK				: STD_LOGIC := '0';
	SIGNAL RST				: STD_LOGIC := '0';
	SIGNAL PC_LdEn			: STD_LOGIC := '0';
	SIGNAL PC_sel			: STD_LOGIC := '0';
	SIGNAL RF_WrEn			: STD_LOGIC := '0';
	SIGNAL RF_WrData_sel	: STD_LOGIC := '0';
	SIGNAL RF_A_sel			: STD_LOGIC := '0';
	SIGNAL RF_B_sel			: STD_LOGIC := '0';
	SIGNAL Immed_ctrl		: STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL ALU_Ain_sel		: STD_LOGIC := '0';
	SIGNAL ALU_Bin_sel		: STD_LOGIC_VECTOR(1 DOWNTO 0) := (OTHERS => '0');
	SIGNAL Op				: STD_LOGIC_VECTOR(3 DOWNTO 0) := (OTHERS => '0');
	SIGNAL ByteOp			: STD_LOGIC := '0';
	SIGNAL MEM_WrEn			: STD_LOGIC := '0';
	SIGNAL REG_A_WrEn		: STD_LOGIC := '0';
	SIGNAL REG_B_WrEn		: STD_LOGIC := '0';
	SIGNAL REG_ALU_WrEn		: STD_LOGIC := '0';
	SIGNAL MDR_WrEn			: STD_LOGIC := '0';
	SIGNAL IR_WrEn			: STD_LOGIC := '0';

	--Outputs
	SIGNAL Instr			: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL inst_dout		: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL MM_RdData		: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL data_dout		: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL ALU_zero			: STD_LOGIC;
	SIGNAL MM_Addr			: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL MM_WrEn			: STD_LOGIC;
	SIGNAL MM_WrData		: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL PC				: STD_LOGIC_VECTOR(31 DOWNTO 0);

	-- Clock period definitions
	CONSTANT CLK_period		: TIME := 100 ns;

BEGIN

	-- Instantiate the Unit Under Test (UUT)

	uut : DATAPATH
	PORT MAP (
		CLK				=> CLK,
		RST				=> RST,
		PC_LdEn			=> PC_LdEn,
		PC_sel			=> PC_sel,
		RF_WrEn			=> RF_WrEn,
		RF_WrData_sel	=> RF_WrData_sel,
		RF_A_sel		=> RF_A_sel,
		RF_B_sel		=> RF_B_sel,
		Immed_ctrl		=> Immed_ctrl,
		ALU_Ain_sel		=> ALU_Ain_sel,
		ALU_Bin_sel		=> ALU_Bin_sel,
		Op				=> Op,
		ByteOp			=> ByteOp,
		MEM_WrEn		=> MEM_WrEn,
		ALU_zero		=> ALU_zero,
		REG_A_WrEn		=> REG_A_WrEn,
		REG_B_WrEn		=> REG_B_WrEn,
		REG_ALU_WrEn	=> REG_ALU_WrEn,
		Instr			=> Instr,
		MM_RdData		=> MM_RdData,
		MM_Addr			=> MM_Addr,
		MM_WrEn			=> MM_WrEn,
		MM_WrData		=> MM_WrData,
		PC				=> PC
	);
	
	ram_inst : RAM
	PORT MAP (
		clk				=> clk,
		inst_addr		=> PC(12 DOWNTO 2),
		inst_dout		=> inst_dout,
		data_we			=> MM_WrEn,
		data_addr		=> MM_Addr(12 DOWNTO 2),
		data_din		=> MM_WrData,
		data_dout		=> data_dout
	);

	IR : REG
	PORT MAP (
		CLK		=> CLK,
		RST		=> RST,
		WE		=> IR_WrEn,
		d		=> inst_dout,
		q		=> Instr
	);

	MDR : REG
	PORT MAP (
		CLK		=> CLK,
		RST		=> RST,
		WE		=> MDR_WrEn,
		d		=> data_dout,
		q		=> MM_RdData
	);


	--PC_LdEn <=	'1' WHEN (currS = S0) OR (currS = jump_state) ELSE
	--			'1' WHEN (currS = branch_state AND zero) ELSE
	--			'1' WHEN (currS = branch_not_state AND (NOT zero) ELSE '0';

	--RF_A_sel <= '1' WHEN (currS = S1) AND (Instr="li" OR Instr="lui")


	RF_A_sel <= '1' WHEN (Instr(31 DOWNTO 28)="1110") ELSE '0';

	-- Clock process definitions
	CLK_process : PROCESS
	BEGIN
		CLK <= '0';
		WAIT FOR CLK_period/2;
		CLK <= '1';
		WAIT FOR CLK_period/2;
	END PROCESS;

	-- Stimulus process
	stim_proc : PROCESS
	BEGIN
		-- hold reset state for 100 ns.
		-- WAIT FOR 100 ns;

		RST				<= '0';
		WAIT FOR CLK_period*2;


		---------- S0 ---------
		RST				<= '1';
		Op				<= "0000";
		PC_sel			<= '0'; -- so that the input is from the alu and not
								-- the reg ALU_Out
		--RF_A_sel		<= '0'; -- don't care bc the A input of the alu is PC
		RF_B_sel		<= '0'; -- don't care bc the B input of the alu is +4
		ALU_Ain_sel		<= '1'; -- so that the input is the PC
		ALU_Bin_sel		<= "10"; -- so that the input is +4
		MEM_WrEn		<= '0';
		RF_WrEn			<= '0';
		RF_WrData_sel	<= '0'; -- don't care
		ByteOp			<= '0'; -- don't care
		Immed_ctrl		<= "10"; -- so that the immediate in the next cycle is
								-- sign extended and sll 2
		PC_LdEn			<= '1'; -- so that it writes PC+4
		REG_A_WrEn		<= '1';
		REG_B_WrEn		<= '1';
		REG_ALU_WrEn	<= '1';
		MDR_WrEn		<= '1';
		IR_WrEn			<= '1';
		WAIT FOR CLK_period;


		---------- S1 ---------
		RST				<= '1';
		Op				<= "0000"; -- for addition
		PC_sel			<= '0'; -- don't care
		--RF_A_sel		<= '0';
		RF_B_sel		<= '0'; -- this MUST be 0 to have the rt (15-11) data stored in B
		-- prepei na einai 0 gt o B prepei na exei ta data tou rt, wste na oloklhrwthei
		-- h R-Type entolh
		ALU_Ain_sel		<= '1'; -- so that the input is the PC
		ALU_Bin_sel		<= "01"; -- so that the input is the immediate
		MEM_WrEn		<= '0';
		RF_WrEn			<= '0';
		RF_WrData_sel	<= '0'; -- don't care
		ByteOp			<= '0'; -- don't care
		Immed_ctrl		<= "11"; -- change it manually in DATAPATH_TB
		PC_LdEn			<= '0';
		REG_A_WrEn		<= '1';
		REG_B_WrEn		<= '1';
		REG_ALU_WrEn	<= '1';
		MDR_WrEn		<= '1';
		IR_WrEn			<= '0';
		WAIT FOR CLK_period;



		---------- S4 ---------
		-------- I-Type -------
		RST				<= '1';
		Op				<= "0000"; -- change it manually in DATAPATH_TB
		PC_sel			<= '0'; -- don't care
		--RF_A_sel		<= '0';
		-- RF_A_sel <= '1' WHEN (currS=S4) AND Instr(31 DOWNTO 29)="111" -- for the FSM
		RF_B_sel		<= '0'; -- don't care
		ALU_Ain_sel		<= '0';
		ALU_Bin_sel		<= "01";
		MEM_WrEn		<= '0';
		RF_WrEn			<= '0';
		RF_WrData_sel	<= '0'; -- don't care
		ByteOp			<= '0'; -- don't care
		Immed_ctrl		<= "11"; -- change it manually in DATAPATH_TB
		--Immed_ctrl	<=	"00" WHEN (currS = S4) AND (Opcode(3) = '1') AND (Opcode(0) = '1') ELSE
		--				"11" WHEN (currS = S4) AND (Opcode(1 DOWNTO 0) = "00") ELSE
		--				"01" WHEN (surrS = S4) AND (Opcode(1) = '1') ELSE
		PC_LdEn			<= '0';
		REG_A_WrEn		<= '1';
		REG_B_WrEn		<= '1';
		REG_ALU_WrEn	<= '1';
		MDR_WrEn		<= '1';
		IR_WrEn			<= '0';
		WAIT FOR CLK_period;



		---------- S3 ---------
		------ R-type and -----
		-- I-type completion --
		RST				<= '1';
		Op				<= "0000"; -- don't care
		PC_sel			<= '0'; -- don't care
		RF_A_sel		<= '0'; -- don't care
		RF_B_sel		<= '0'; -- don't care
		ALU_Ain_sel		<= '0'; -- don't care
		ALU_Bin_sel		<= "00"; -- don't care
		MEM_WrEn		<= '0';
		RF_WrEn			<= '1'; -- to write in the RF
		RF_WrData_sel	<= '0'; -- to write the output of reg ALU_Out
		ByteOp			<= '0'; -- don't care
		Immed_ctrl		<= "10"; -- don't care
		PC_LdEn			<= '0';
		REG_A_WrEn		<= '1';
		REG_B_WrEn		<= '1';
		REG_ALU_WrEn	<= '1';
		MDR_WrEn		<= '1';
		IR_WrEn			<= '0';
		WAIT FOR CLK_period;



		---------- S0 ---------
		RST				<= '1';
		Op				<= "0000";
		PC_sel			<= '0'; -- so that the input is from the alu and not
								-- the reg ALU_Out
		--RF_A_sel		<= '0'; -- don't care bc the A input of the alu is PC
		RF_B_sel		<= '0'; -- don't care bc the B input of the alu is +4
		ALU_Ain_sel		<= '1'; -- so that the input is the PC
		ALU_Bin_sel		<= "10"; -- so that the input is +4
		MEM_WrEn		<= '0';
		RF_WrEn			<= '0';
		RF_WrData_sel	<= '0'; -- don't care
		ByteOp			<= '0'; -- don't care
		Immed_ctrl		<= "10"; -- so that the immediate in the next cycle is
								-- sign extended and sll 2
		PC_LdEn			<= '1'; -- so that it writes PC+4
		REG_A_WrEn		<= '1';
		REG_B_WrEn		<= '1';
		REG_ALU_WrEn	<= '1';
		MDR_WrEn		<= '1';
		IR_WrEn			<= '1';
		WAIT FOR CLK_period;



		---------- S1 ---------
		RST				<= '1';
		Op				<= "0000"; -- for addition
		PC_sel			<= '0'; -- don't care
		--RF_A_sel		<= '0';
		RF_B_sel		<= '0'; -- this MUST be 0 to have the rt (15-11) data stored in B
		-- prepei na einai 0 gt o B prepei na exei ta data tou rt, wste na oloklhrwthei
		-- h R-Type entolh
		ALU_Ain_sel		<= '1'; -- so that the input is the PC
		ALU_Bin_sel		<= "01"; -- so that the input is the immediate
		MEM_WrEn		<= '0';
		RF_WrEn			<= '0';
		RF_WrData_sel	<= '0'; -- don't care
		ByteOp			<= '0'; -- don't care
		Immed_ctrl		<= "10"; -- change it manually in DATAPATH_TB
		PC_LdEn			<= '0';
		REG_A_WrEn		<= '1';
		REG_B_WrEn		<= '1';
		REG_ALU_WrEn	<= '1';
		MDR_WrEn		<= '1';
		IR_WrEn			<= '0';
		WAIT FOR CLK_period;



		---------- S2 ---------
		-------- R-Type -------
		RST				<= '1';
		Op				<= "0000"; -- change it manually in DATAPATH_TB
		PC_sel			<= '0'; -- don't care
		--RF_A_sel		<= '0'; -- don't care, bc reg A has the data
		RF_B_sel		<= '0'; -- don't care, bc reg B has the data
		ALU_Ain_sel		<= '0'; -- first ALU input has reg A
		ALU_Bin_sel		<= "00"; -- second ALU input has reg B
		MEM_WrEn		<= '0';
		RF_WrEn			<= '0';
		RF_WrData_sel	<= '0'; -- don't care, it will be 0 in the next cycle
		ByteOp			<= '0'; -- don't care
		Immed_ctrl		<= "10"; -- don't care
		PC_LdEn			<= '0';
		REG_A_WrEn		<= '1';
		REG_B_WrEn		<= '1';
		REG_ALU_WrEn	<= '1';
		MDR_WrEn		<= '1';
		IR_WrEn			<= '0';
		WAIT FOR CLK_period;



		---------- S3 ---------
		------ R-type and -----
		-- I-type completion --
		RST				<= '1';
		Op				<= "0000"; -- don't care
		PC_sel			<= '0'; -- don't care
		RF_A_sel		<= '0'; -- don't care
		RF_B_sel		<= '0'; -- don't care
		ALU_Ain_sel		<= '0'; -- don't care
		ALU_Bin_sel		<= "00"; -- don't care
		MEM_WrEn		<= '0';
		RF_WrEn			<= '1'; -- to write in the RF
		RF_WrData_sel	<= '0'; -- to write the output of reg ALU_Out
		ByteOp			<= '0'; -- don't care
		Immed_ctrl		<= "10"; -- don't care
		PC_LdEn			<= '0';
		REG_A_WrEn		<= '1';
		REG_B_WrEn		<= '1';
		REG_ALU_WrEn	<= '1';
		MDR_WrEn		<= '1';
		IR_WrEn			<= '0';
		WAIT FOR CLK_period;

		WAIT;
	END PROCESS;

END;
-------------------------------------------------------------------------------