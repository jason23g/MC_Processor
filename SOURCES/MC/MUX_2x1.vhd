-------------------------------------------------------------------------------
LIBRARY IEEE;
USE IEEE.STD_LOGIC_1164.ALL;
-------------------------------------------------------------------------------
ENTITY MUX_2x1 IS
	PORT (
		Ctrl : IN STD_LOGIC;
		Din0 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		Din1 : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
		Dout : OUT STD_LOGIC_VECTOR(31 DOWNTO 0)
	);
END MUX_2x1;
-------------------------------------------------------------------------------
ARCHITECTURE Behavioral OF MUX_2x1 IS

BEGIN
	PROCESS (Din0, Din1, ctrl)
	BEGIN
		CASE ctrl IS
			WHEN '0'	=>	Dout <= Din0 after 10 ns;
			WHEN '1'	=>	Dout <= Din1 after 10 ns;
			WHEN OTHERS =>	Dout <= x"00000000" after 10 ns;
		END CASE;
	END PROCESS;
END Behavioral;
-------------------------------------------------------------------------------