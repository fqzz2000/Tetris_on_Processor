LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY SixteenBitRCLA IS
	PORT (	A, B	: IN STD_LOGIC_VECTOR(15 DOWNTO 0);	-- 8bit addends
			carryIn	: IN STD_LOGIC;
			sum	: OUT STD_LOGIC_VECTOR(15 DOWNTO 0);	-- 8bit sum output
			carryOut	: OUT STD_LOGIC);
END SixteenBitRCLA;

ARCHITECTURE Structure OF SixteenBitRCLA IS
	SIGNAL c8	: STD_LOGIC;	-- internal carries
	COMPONENT EightBitCLA IS
		PORT (	A, B	: IN STD_LOGIC_VECTOR(7 DOWNTO 0);	-- 8bit addends
				carryIn	: IN STD_LOGIC;
				sum	: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);	-- 8bit sum output
				carryOut	: OUT STD_LOGIC);
	END COMPONENT;
BEGIN
	lower: EightBitCLA PORT MAP (A(7 DOWNTO 0), B(7 DOWNTO 0), carryIn, sum(7 DOWNTO 0), c8);
	upper: EightBitCLA PORT MAP (A(15 DOWNTO 8), B(15 DOWNTO 8), c8, sum(15 DOWNTO 8), carryOut);
END Structure;