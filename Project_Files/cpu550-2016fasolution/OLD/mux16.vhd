LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY mux16 IS
	PORT (	A, B	: IN STD_LOGIC_VECTOR(15 DOWNTO 0);	-- 16bit inputs
			s	: IN STD_LOGIC;	-- select (NOT A / B)
			F	: OUT STD_LOGIC_VECTOR(15 DOWNTO 0) );	-- 16bit output
END mux16;

ARCHITECTURE Structure OF mux16 IS
BEGIN
	mux : FOR i IN 0 TO 15 GENERATE
		mux_bit: F(i) <= (A(i) AND NOT s) OR (B(i) AND s);
	END GENERATE mux;
END Structure;