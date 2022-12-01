LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- register $r0 always equals zero
ENTITY register0 IS
	PORT (	outEnableA, outEnableB	: IN STD_LOGIC;
			Qa, Qb	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0) );
END register0;

ARCHITECTURE Structure OF register0 IS
	COMPONENT triStateBuffer
		PORT (	input	: IN STD_LOGIC;
				enable	: IN STD_LOGIC;
				output	: OUT STD_LOGIC );
	END COMPONENT;
BEGIN
	zeroes : FOR i IN 0 TO 31 GENERATE
		outA: triStateBuffer PORT MAP ('0', outEnableA, Qa(i));
		outB: triStateBuffer PORT MAP ('0', outEnableB, Qb(i));
	END GENERATE zeroes;
END;