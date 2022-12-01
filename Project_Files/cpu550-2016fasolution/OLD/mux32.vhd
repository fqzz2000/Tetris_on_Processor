LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY mux32 IS
	PORT (	A, B	: IN STD_LOGIC_VECTOR(31 DOWNTO 0);	-- 32bit inputs
			s	: IN STD_LOGIC;	-- select (NOT A / B)
			F	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0) );	-- 32bit output
END mux32;

ARCHITECTURE Structure OF mux32 IS
BEGIN
	mux : FOR i IN 0 TO 31 GENERATE
		mux_bit: F(i) <= (A(i) AND NOT s) OR (B(i) AND s);
	END GENERATE mux;
END Structure;