-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_unsigned.ALL;
-------------------------------------------------------------------------------
ENTITY IFSTAGE IS
	PORT (
		Clk			: IN STD_LOGIC;
		Reset		: IN STD_LOGIC;
		PC_LdEn		: IN STD_LOGIC;
		PC_sel		: IN STD_LOGIC;
		PC_Immed	: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		PC_In		: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		PC			: OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END IFSTAGE;
-------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF IFSTAGE IS

	COMPONENT REG
	PORT (
		CLK	: IN STD_LOGIC; -- clock.
		RST	: IN STD_LOGIC; -- async. clear.
		WE	: IN STD_LOGIC; -- load/enable.
		d	: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		q	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0) -- output
	);
	END COMPONENT;

	COMPONENT MUX_2x1
	PORT (
		Ctrl : IN STD_LOGIC;
		Din0 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		Din1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		Dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
	END COMPONENT;

	SIGNAL PC_In_internal : STD_LOGIC_VECTOR(31 DOWNTO 0);

BEGIN

	pc_reg : REG
	PORT MAP (
		CLK		=> clk,
		RST		=> Reset,
		WE		=> PC_LdEn,
		d		=> PC_In_internal,
		q		=> PC
	);
	
	mux : MUX_2x1
	PORT MAP (
		ctrl	=> PC_Sel,
		Din0	=> PC_In,
		Din1	=> PC_Immed,
		Dout	=> PC_In_internal
	);

END Behavioral;
-------------------------------------------------------------------------------