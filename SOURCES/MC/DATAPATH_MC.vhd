-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
-------------------------------------------------------------------------------
ENTITY DATAPATH_MC IS
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
		Instr			: IN STD_LOGIC_VECTOR(31 DOWNTO 0);		--connect with ram
		MM_RdData 		: IN STD_LOGIC_VECTOR(31 DOWNTO 0);		--connect with ram
		MM_Addr 		: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);	--connect with ram
		MM_WrEn 		: OUT STD_LOGIC;						--connect with ram
		MM_WrData 		: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);	--connect with ram
		PC				: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);	--connect with ram
		ALU_zero		: OUT STD_LOGIC
	);
END DATAPATH_MC;
-------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF DATAPATH_MC IS

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
	
	COMPONENT DECSTAGE
	PORT (
		Clk				: IN STD_LOGIC;
		RST				: IN STD_LOGIC;
		Instr			: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		RF_WrEn			: IN STD_LOGIC;
		ALU_out			: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		MEM_out			: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		RF_WrData_sel	: IN STD_LOGIC;
		RF_A_sel		: IN STD_LOGIC;
		RF_B_sel		: IN STD_LOGIC;
		Immed_ctrl		: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		Immed			: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		RF_A			: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		RF_B			: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
	END COMPONENT;
	
	COMPONENT EXSTAGE
	PORT (
		RF_A		: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		RF_B		: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		Immed		: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		PC			: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		ALU_Ain_sel : IN STD_LOGIC;
		ALU_Bin_sel	: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		Op			: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		ALU_out		: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		ALU_zero	: OUT STD_LOGIC
	);
	END COMPONENT;
	
	COMPONENT MEMSTAGE
	PORT (
		ByteOp			: IN STD_LOGIC;
		MEM_WrEn		: IN STD_LOGIC;
		ALU_MEM_Addr	: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		MEM_DataIn		: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		MEM_DataOut		: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		MM_Addr			: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		MM_WrEn			: OUT STD_LOGIC;
		MM_WrData		: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
		MM_RdData		: IN STD_LOGIC_VECTOR(31 DOWNTO 0)
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
	
	SIGNAL RF_A_internal			: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL RF_B_internal			: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL Immed_internal			: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL EX_RF_A_internal			: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL EX_RF_B_internal			: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL EX_Immed_internal		: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL ALU_out_internal			: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL MEM_out_internal			: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL REG_ALU_out_internal		: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL REG_IR_out_internal		: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL PC_internal				: STD_LOGIC_VECTOR(31 DOWNTO 0);
	
BEGIN
	
	ifstage_inst : IFSTAGE
	PORT MAP (
		Clk				=> CLK,
		Reset			=> RST,
		PC_LdEn			=> PC_LdEn,
		PC_sel			=> PC_sel,
		PC_Immed		=> REG_ALU_out_internal, -- me tin exodo tou reg ALU_Out
		PC_In			=> ALU_out_internal, -- me tin exodo tou
		PC				=> PC_internal -- sto top level kai me thn seira tou sth ram
	);

	PC <= PC_internal;-- connect the internal signal with the top level output
	
	decstage_inst : DECSTAGE
	PORT MAP (
		Clk				=> CLK,
		RST				=> RST,
		Instr			=> Instr,--REG_IR_out_internal,
		RF_WrEn			=> RF_WrEn,
		ALU_out			=> REG_ALU_out_internal, --me thn exodo ths alu
		MEM_out			=> MEM_out_internal, --me to MEM_DataOut tou MEMSTAGE
		RF_WrData_sel	=> RF_WrData_sel,
		RF_A_sel		=> RF_A_sel,
		RF_B_sel		=> RF_B_sel,
		Immed_ctrl		=> Immed_ctrl,
		Immed			=> Immed_internal, --apo to decode
		RF_A			=> RF_A_internal,
		RF_B			=> RF_B_internal
	);
	
	exstage_inst : EXSTAGE
	PORT MAP (
		RF_A			=> EX_RF_A_internal,
		RF_B			=> EX_RF_B_internal,
		Immed			=> Immed_internal,--EX_Immed_internal,
		PC				=> PC_internal,
		ALU_Ain_sel 	=> ALU_Ain_sel,
		ALU_Bin_sel		=> ALU_Bin_sel,
		Op				=> Op,
		ALU_out			=> ALU_out_internal, --mia eisodos sto dec kai mia sto mem
		ALU_zero		=> ALU_zero
	);
	
	memstage_inst : MEMSTAGE
	PORT MAP (
		ByteOp			=> ByteOp,
		MEM_WrEn		=> MEM_WrEn,
		ALU_MEM_Addr	=> REG_ALU_out_internal,
		MEM_DataIn		=> EX_RF_B_internal,
		MEM_DataOut		=> MEM_out_internal,
		MM_Addr			=> MM_Addr,
		MM_WrEn			=> MM_WrEn,
		MM_WrData		=> MM_WrData,
		MM_RdData		=> MM_RdData
	);
	
	reg_a : REG
	PORT MAP (
		CLK		=> CLK,
		RST		=> RST,
		WE		=> REG_A_WrEn,
		d		=> RF_A_internal,
		q		=> EX_RF_A_internal
	);
	
	reg_b : REG
	PORT MAP (
		CLK		=> CLK,
		RST		=> RST,
		WE		=> REG_B_WrEn,
		d		=> RF_B_internal,
		q		=> EX_RF_B_internal
	);
	
	reg_immed : REG
	PORT MAP (
		CLK		=> CLK,
		RST		=> RST,
		WE		=> '1',--REG_Immed_WrEn,
		d		=> Immed_internal,
		q		=> EX_Immed_internal
	);
	
	reg_alu : REG
	PORT MAP (
		CLK		=> CLK,
		RST		=> RST,
		WE		=> REG_ALU_WrEn,
		d		=> ALU_out_internal,
		q		=> REG_ALU_out_internal
	);
	
	--MDR : REG
	--PORT MAP (
	--	CLK		=> CLK,
	--	RST		=> RST,
	--	WE		=> MDR_WrEn,
	--	d		=> Immed_internal,
	--	q		=> REG_MEM_out_internal
	--);
	
	--IR : REG
	--PORT MAP (
	--	CLK		=> CLK,
	--	RST		=> RST,
	--	WE		=> IR_WrEn,
	--	d		=> Instr,
	--	q		=> REG_IR_out
	--);
	
end Behavioral;
-------------------------------------------------------------------------------