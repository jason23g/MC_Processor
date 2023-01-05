-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
-------------------------------------------------------------------------------
ENTITY CONTROL_MC IS
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
END CONTROL_MC;
-------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF CONTROL_MC IS

	TYPE STATE IS (S0, S1, S2, S3, S4, S5, S6, S7, S8, S9, S10, S11);
	SIGNAL currS, nextS : STATE;

BEGIN

	fsm_Asynch : PROCESS (currS, Opcode)
	BEGIN
		CASE currS IS
			WHEN S0	=> nextS <= S1;

			WHEN S1	=>
				IF		Opcode = "100000" THEN
					nextS <= S2; -- R-type
				ELSIF	(Opcode(5 DOWNTO 4) = "11") AND (Opcode(2) = '0') THEN
					nextS <= S4; -- I-type
				ELSIF Opcode = "111111" THEN
					nextS <= S5; -- jump
				ELSIF Opcode = "000000" THEN
					nextS <= S6; -- Branch equal
				ELSIF Opcode = "000001" THEN
					nextS <= S7; -- Branch not equal
				ELSIF Opcode(5) = '0' AND Opcode(1) = '1' THEN
					nextS <= S8; -- Mem address computation (load/store instr)
				ELSE
					nextS <= S0;
				END IF;

			WHEN S2 => -- R-type
				nextS <= S3; -- R-type and I-type completion

			WHEN S3 => -- R-type and I-type completion
				nextS <= S0;

			WHEN S4 => -- I-type
				nextS <= S3;

			WHEN S5 => -- jump
				nextS <= S0;

			WHEN S6 => -- branch if equal
				nextS <= S0;

			WHEN S7 => -- branch if NOT equal
				nextS <= S0;

			WHEN S8 => -- mem address computation
				IF Opcode(4 DOWNTO 1) = "0001" OR Opcode(4 DOWNTO 1) = "0111" THEN
					nextS <= S9;
				ELSIF Opcode(4 DOWNTO 1) = "0011" OR Opcode(4 DOWNTO 1) = "1111" THEN
					nextS <= S11;
				ELSE
					nextS <= S0;
				END IF;

			WHEN S9 => -- memory access
				nextS <= S10;

			WHEN S10 => -- Load completion
				nextS <= S0;

			WHEN S11 => -- Store completion 
				nextS <= S0;

			WHEN OTHERS => nextS <= S0;
		END CASE;
	END PROCESS fsm_Asynch;

	fsm_Synch : PROCESS (CLK)
	BEGIN
		IF rising_edge(CLK) THEN
			IF (RST = '0') THEN
				currS <= S0;
			ELSE
				currS <= nextS;
			END IF;
		END IF;
	END PROCESS fsm_Synch;

	ALU_Op			<=	"001"	WHEN currS = S0 OR currS = S1 OR currS = S8 OR (currS = S4 AND Opcode = "110000") ELSE
						"000"	WHEN currS = S2 ELSE
						"011"	WHEN currS = S4 AND (Opcode = "111000" OR Opcode = "111001" OR  Opcode = "110011") ELSE
						"100"	WHEN currS = S4 AND Opcode = "110010"  ELSE
						"010"	WHEN currS = S6 OR currS = S7 ELSE "111";


	ALU_Ain_sel		<=	'1'		WHEN currS = S0 OR currS = S1 ELSE '0';


	ALU_Bin_sel		<=	"10"	WHEN currS = S0 ELSE
						"01"	WHEN currS = S1 OR currS = S4 OR currS = S8 ELSE "00";


	RF_A_sel		<=	'1'		WHEN currS = S1 AND Opcode(5 DOWNTO 2) = "1110" ELSE '0';


	RF_B_sel		<=	'0'		WHEN currS = S1 AND Opcode(5 DOWNTO 4) = "10" ELSE '1';


	MEM_WrEn		<=	'1'		WHEN currS = S11 ELSE '0';


	RF_WrEn			<=	'1'		WHEN currS = S3 OR currS = S10 ELSE '0';


	RF_WrData_sel	<=	'1'		WHEN currS = S10 ELSE '0';


	ByteOp			<=	'1'		WHEN (currS = S10 AND Opcode = "000011") OR (currS = S11 AND Opcode = "000111") ELSE '0';


	Immed_ctrl		<=	"00"	WHEN (currS = S1) AND (Opcode = "111001") ELSE
						"01" 	WHEN (currS = S1) AND (Opcode(5 DOWNTO 1) = "11001") ELSE
						"10" 	WHEN (currS = S0) OR ((currS = S1) AND (Opcode = "111111" OR Opcode = "000000" OR Opcode = "000001")) ELSE
						"11" 	WHEN (currS = S1) AND (Opcode = "110000" OR Opcode = "111000" OR (Opcode(5) = '0' AND Opcode(1 DOWNTO 0) = "11"));-- ELSE "00";


	PC_sel			<=	'1'		WHEN currS = S5 OR currS = S6 OR currS = S7 ELSE '0';


	PC_LdEn 		<= '1'		WHEN (currS = S0) OR (currS = S5) OR (currS = S6 AND (ALU_Zero = '1')) OR (currS = S7 AND (NOT ALU_Zero = '1')) ELSE '0';

	IR_WrEn			<= '1'		WHEN currS = S0 ELSE '0';

END Behavioral;
-------------------------------------------------------------------------------