-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
-------------------------------------------------------------------------------
ENTITY PROC_MC IS
	PORT (
		CLK				: IN STD_LOGIC;
		RST				: IN STD_LOGIC;
		inst_addr		: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		inst_dout		: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		data_we			: OUT STD_LOGIC;
		data_addr		: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		data_din		: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		data_dout		: IN STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END PROC_MC;
-------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF PROC_MC IS

	COMPONENT DATAPATH_MC
	PORT (
		CLK				: IN STD_LOGIC;
		RST 			: IN STD_LOGIC;
		PC_LdEn 		: IN STD_LOGIC;
		PC_sel			: IN STD_LOGIC;
		RF_WrEn			: IN STD_LOGIC;
		RF_WrData_sel	: IN STD_LOGIC;
		RF_A_sel		: IN STD_LOGIC;
		RF_B_sel		: IN STD_LOGIC;
		Immed_ctrl		: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		ALU_Ain_sel		: IN STD_LOGIC;
		ALU_Bin_sel 	: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		Op				: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		ByteOp			: IN STD_LOGIC;
		MEM_WrEn		: IN STD_LOGIC;
		REG_A_WrEn		: IN STD_LOGIC;
		REG_B_WrEn		: IN STD_LOGIC;
		REG_ALU_WrEn	: IN STD_LOGIC;
		Instr			: IN STD_LOGIC_VECTOR(31 DOWNTO 0);	--connect with IR
		MM_RdData 		: IN STD_LOGIC_VECTOR(31 DOWNTO 0);	--connect with MDR
		MM_Addr 		: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);--connect with ram
		MM_WrEn 		: OUT STD_LOGIC;					--connect with ram
		MM_WrData 		: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);--connect with ram
		PC				: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);--connect with ram
		ALU_zero		: OUT STD_LOGIC
	);
	END COMPONENT;
	
	COMPONENT ALU_CONTROL
	PORT (
		ALU_Op			: IN STD_LOGIC_VECTOR(2 DOWNTO 0);
		func			: IN STD_LOGIC_VECTOR(5 DOWNTO 0);
		Op				: OUT STD_LOGIC_VECTOR(3 DOWNTO 0)
	);
	END COMPONENT;
	
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
	
	COMPONENT REG
	PORT (
		CLK				: IN STD_LOGIC;
		RST				: IN STD_LOGIC;
		WE				: IN STD_LOGIC;
		d				: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		q				: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
	END COMPONENT;


	SIGNAL PC_LdEn_internal			: STD_LOGIC;
	SIGNAL PC_sel_internal			: STD_LOGIC;
	SIGNAL RF_WrEn_internal			: STD_LOGIC;
	SIGNAL RF_WrData_sel_internal	: STD_LOGIC;
	SIGNAL RF_A_sel_internal		: STD_LOGIC;
	SIGNAL RF_B_sel_internal		: STD_LOGIC;
	SIGNAL Immed_ctrl_internal		: STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL ALU_Ain_sel_internal		: STD_LOGIC;
	SIGNAL ALU_Bin_sel_internal		: STD_LOGIC_VECTOR(1 DOWNTO 0);
	SIGNAL Op_internal				: STD_LOGIC_VECTOR(3 DOWNTO 0);
	SIGNAL ALU_Op_internal			: STD_LOGIC_VECTOR(2 DOWNTO 0);
	SIGNAL ByteOp_internal			: STD_LOGIC;
	SIGNAL MEM_WrEn_internal		: STD_LOGIC;
	SIGNAL Instr_internal			: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL MM_RdData_internal		: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL ALU_Zero_internal		: STD_LOGIC;
	SIGNAL IR_WrEn_internal			: STD_LOGIC;
	
BEGIN
	
	datapath_inst : DATAPATH_MC
	PORT MAP (
		CLK				=> CLK,--connects with top level
		RST				=> RST,--connects with top level
		PC_LdEn			=> PC_LdEn_internal,
		PC_sel			=> PC_sel_internal,
		RF_WrEn			=> RF_WrEn_internal,
		RF_WrData_sel	=> RF_WrData_sel_internal,
		RF_A_sel		=> RF_A_sel_internal,
		RF_B_sel		=> RF_B_sel_internal,
		Immed_ctrl		=> Immed_ctrl_internal,
		ALU_Ain_sel		=> ALU_Ain_sel_internal,
		ALU_Bin_sel		=> ALU_Bin_sel_internal,
		Op				=> Op_internal,
		ByteOp			=> ByteOp_internal,
		MEM_WrEn		=> MEM_WrEn_internal,
		ALU_Zero		=> ALU_Zero_internal,
		REG_A_WrEn		=> '1',
		REG_B_WrEn		=> '1',
		REG_ALU_WrEn	=> '1',
		Instr			=> Instr_internal,--comes from the IR
		PC				=> inst_addr,
		MM_RdData		=> MM_RdData_internal,
		MM_Addr			=> data_addr,
		MM_WrEn			=> data_we,
		MM_WrData		=> data_din
	);
	
	IR : REG
	PORT MAP (
		CLK				=> CLK,
		RST				=> RST,
		WE				=> IR_WrEn_internal,
		d				=> inst_dout,
		q				=> Instr_internal
	);

	MDR : REG
	PORT MAP (
		CLK				=> CLK,
		RST				=> RST,
		WE				=> '1',
		d				=> data_dout,
		q				=> MM_RdData_internal
	);
	
	control_mc_inst : CONTROL_MC
	PORT MAP (
		CLK				=> CLK,
		RST				=> RST,
		Opcode			=> Instr_internal(31 DOWNTO 26),
		ALU_Zero		=> ALU_Zero_internal,
		ALU_Op			=> ALU_Op_internal,
		ALU_Ain_sel		=> ALU_Ain_sel_internal,
		ALU_Bin_sel		=> ALU_Bin_sel_internal,
		RF_A_sel		=> RF_A_sel_internal,
		RF_B_sel		=> RF_B_sel_internal,
		MEM_WrEn		=> MEM_WrEn_internal,
		RF_WrEn			=> RF_WrEn_internal,
		RF_WrData_sel	=> RF_WrData_sel_internal,
		ByteOp			=> ByteOp_internal,
		Immed_ctrl		=> Immed_ctrl_internal,
		PC_sel			=> PC_sel_internal,
		PC_LdEn			=> PC_LdEn_internal,
		IR_WrEn			=> IR_WrEn_internal
	);
	
	alu_control_inst : ALU_CONTROL
	PORT MAP (
		ALU_Op			=> ALU_Op_internal,--input, comes from the FSM
		func			=> Instr_internal(5 DOWNTO 0),--input, comes from the instruction
		Op				=> Op_internal-- output, goes to the Datapath and more specifically to the ALU
	);

END Behavioral;
-------------------------------------------------------------------------------