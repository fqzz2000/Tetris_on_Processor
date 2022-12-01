LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY register32bit IS
	PORT (	D	: IN STD_LOGIC_VECTOR(31 DOWNTO 0);	-- 32bits data input
			clock, clear, inEnable, outEnableA, outEnableB	: IN STD_LOGIC;
			Qa, Qb	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0) );	-- 32bits data output
END register32bit;

ARCHITECTURE Structure OF register32bit IS
	COMPONENT register1bit
		PORT (	D	: IN STD_LOGIC;
				clear	: IN STD_LOGIC;
				inEnable	: IN STD_LOGIC;
				clock		: IN STD_LOGIC;
				outEnableB	: IN STD_LOGIC;
				outEnableA	: IN STD_LOGIC;
				Qa	: OUT STD_LOGIC;
				Qb	: OUT STD_LOGIC );
	END COMPONENT;
BEGIN
	bits : FOR i IN 0 TO 31 GENERATE
		bit_array: register1bit PORT MAP (D(i), clear, inEnable, clock, outEnableB, outEnableA, Qa(i), Qb(i));
	END GENERATE bits;
END;