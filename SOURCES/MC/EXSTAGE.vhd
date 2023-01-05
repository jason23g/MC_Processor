-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
-------------------------------------------------------------------------------
ENTITY EXSTAGE IS
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
END EXSTAGE;
-------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF EXSTAGE IS
	
	COMPONENT ALU
	PORT (
		A		: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		B		: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		Op		: IN STD_LOGIC_VECTOR(3 DOWNTO 0);
		Cout	: OUT STD_LOGIC;
		Zero	: OUT STD_LOGIC;
		Ovf		: OUT STD_LOGIC;
		Output	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
	END COMPONENT;
	
	COMPONENT MUX_2x1
	PORT (
		Ctrl	: IN STD_LOGIC;
		Din0	: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		Din1	: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		Dout	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
	END COMPONENT;
	
	COMPONENT MUX_4x1
	PORT (
		Ctrl	: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		Din0	: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		Din1	: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		Din2	: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		Din3	: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		Dout	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
	END COMPONENT;
	
	SIGNAL mux_out_a : STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL mux_out_b : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN

	mux_a : MUX_2x1
	PORT MAP (
		ctrl	=> ALU_Ain_sel,
		Din0	=> RF_A,
		Din1	=> PC,
		Dout	=> mux_out_a
	);

	mux_b: MUX_4x1
	PORT MAP (
		Ctrl	=> ALU_Bin_sel,
		Din0	=> RF_B,
		Din1	=> Immed,
		Din2	=> x"00000004",
		Din3	=> x"00000000",
		Dout	=> mux_out_b
	);
	
	arithmetic_logic_unit : ALU
	PORT MAP (
		A		=> mux_out_a,
		B		=> mux_out_b,
		Op		=> Op,
		--Cout => Cout,
		Zero	=> ALU_zero,
		-- Ovf => Ovf,
		Output	=> ALU_out
	);

END Behavioral;
-------------------------------------------------------------------------------