LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY latch12 IS
	PORT (	D	: IN STD_LOGIC_VECTOR(11 DOWNTO 0);	-- 12bits data input
			clock, inEnable, clear	: IN STD_LOGIC;	-- clock, write enable, and reset
			Q	: OUT STD_LOGIC_VECTOR(11 DOWNTO 0) );	-- 12bits data output
END latch12;

ARCHITECTURE Structure OF latch12 IS
	COMPONENT DflipflopE IS
		PORT (	D	: IN STD_LOGIC;
				clock	: IN STD_LOGIC;
				inEnable	: IN STD_LOGIC;
				clear	: IN STD_LOGIC;
				Q	:	 OUT STD_LOGIC);
	END COMPONENT;
BEGIN
	latch : FOR i IN 0 TO 11 GENERATE
		latch_bit: DflipflopE PORT MAP (D(i), clock, inEnable, clear, Q(i));
	END GENERATE latch;
END;