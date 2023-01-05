--------------------------------------------------------------------------------
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
--------------------------------------------------------------------------------
ENTITY DATAPATH_TB_3 IS
END DATAPATH_TB_3;
--------------------------------------------------------------------------------
ARCHITECTURE behavior OF DATAPATH_TB_3 IS 

		-- Component Declaration for the Unit Under Test (UUT)

		COMPONENT DATAPATH_MC
		PORT(
				 CLK : IN  std_logic;
				 RST : IN  std_logic;
				 PC_LdEn : IN  std_logic;
				 PC_sel : IN  std_logic;
				 RF_WrEn : IN  std_logic;
				 RF_WrData_sel : IN  std_logic;
				 RF_A_sel : IN  std_logic;
				 RF_B_sel : IN  std_logic;
				 Immed_ctrl : IN  std_logic_vector(1 downto 0);
				 ALU_Bin_sel : IN  std_logic;
				 Op : IN  std_logic_vector(3 downto 0);
				 ByteOp : IN  std_logic;
				 MEM_WrEn : IN  std_logic;
				 ALU_zero : OUT  std_logic;
				 REG_A_WrEn : IN  std_logic;
				 REG_B_WrEn : IN  std_logic;
				 REG_ALU_WrEn : IN  std_logic;
				 MDR_WrEn : IN  std_logic;
				 IR_WrEn : IN  std_logic;
				 Instr : IN  std_logic_vector(31 downto 0);
				 MM_RdData : IN  std_logic_vector(31 downto 0);
				 MM_Addr : OUT  std_logic_vector(31 downto 0);
				 MM_WrEn : OUT  std_logic;
				 MM_WrData : OUT  std_logic_vector(31 downto 0);
				 PC : OUT  std_logic_vector(31 downto 0)
				);
		END COMPONENT;


	--COMPONENT RAM
	--PORT (
	--	clk				: IN STD_LOGIC;
	--	inst_addr		: IN STD_LOGIC_VECTOR(10 DOWNTO 0);
	--	inst_dout		: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
	--	data_we			: IN STD_LOGIC;
	--	data_addr		: IN STD_LOGIC_VECTOR(10 DOWNTO 0);
	--	data_din		: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
	--	data_dout		: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	--);
	--END COMPONENT;
		

	 --Inputs
	 signal CLK : std_logic := '0';
	 signal RST : std_logic := '0';
	 signal PC_LdEn : std_logic := '0';
	 signal PC_sel : std_logic := '0';
	 signal RF_WrEn : std_logic := '0';
	 signal RF_WrData_sel : std_logic := '0';
	 signal RF_A_sel : std_logic := '0';
	 signal RF_B_sel : std_logic := '0';
	 signal Immed_ctrl : std_logic_vector(1 downto 0) := (others => '0');
	 signal ALU_Bin_sel : std_logic := '0';
	 signal Op : std_logic_vector(3 downto 0) := (others => '0');
	 signal ByteOp : std_logic := '0';
	 signal MEM_WrEn : std_logic := '0';
	 signal REG_A_WrEn : std_logic := '0';
	 signal REG_B_WrEn : std_logic := '0';
	 signal REG_ALU_WrEn : std_logic := '0';
	 signal MDR_WrEn : std_logic := '0';
	 signal IR_WrEn : std_logic := '0';
	 signal Instr : std_logic_vector(31 downto 0) := (others => '0');
	 signal MM_RdData : std_logic_vector(31 downto 0) := (others => '0');

	--Outputs
	 signal ALU_zero : std_logic;
	 signal MM_Addr : std_logic_vector(31 downto 0);
	 signal MM_WrEn : std_logic;
	 signal MM_WrData : std_logic_vector(31 downto 0);
	 signal PC : std_logic_vector(31 downto 0);

	 -- Clock period definitions
	 constant CLK_period : time := 10 ns;
 
BEGIN
 
	-- Instantiate the Unit Under Test (UUT)
	 uut: DATAPATH_MC PORT MAP (
					CLK => CLK,
					RST => RST,
					PC_LdEn => PC_LdEn,
					PC_sel => PC_sel,
					RF_WrEn => RF_WrEn,
					RF_WrData_sel => RF_WrData_sel,
					RF_A_sel => RF_A_sel,
					RF_B_sel => RF_B_sel,
					Immed_ctrl => Immed_ctrl,
					ALU_Bin_sel => ALU_Bin_sel,
					Op => Op,
					ByteOp => ByteOp,
					MEM_WrEn => MEM_WrEn,
					ALU_zero => ALU_zero,
					REG_A_WrEn => REG_A_WrEn,
					REG_B_WrEn => REG_B_WrEn,
					REG_ALU_WrEn => REG_ALU_WrEn,
					MDR_WrEn => MDR_WrEn,
					IR_WrEn => IR_WrEn,
					Instr => Instr,
					MM_RdData => MM_RdData,
					MM_Addr => MM_Addr,
					MM_WrEn => MM_WrEn,
					MM_WrData => MM_WrData,
					PC => PC
	);
		
	--ram_inst : RAM
	--PORT MAP (
	--	clk				=> clk,
	--	inst_addr		=> PC(12 DOWNTO 2),
	--	inst_dout		=> Instr,
	--	data_we			=> MM_WrEn,
	--	data_addr		=> MM_Addr(12 DOWNTO 2),
	--	data_din		=> MM_WrData,
	--	data_dout		=> MM_RdData
	--);

	 -- Clock process definitions
	 CLK_process :process
	 begin
		CLK <= '0';
		wait for CLK_period/2;
		CLK <= '1';
		wait for CLK_period/2;
	 end process;
 

	 -- Stimulus process
	 stim_proc: process
	 begin		
			-- hold reset state for 100 ns.
			wait for 100 ns;	

			wait for CLK_period*10;


			wait;
	 end process;

END;
--------------------------------------------------------------------------------