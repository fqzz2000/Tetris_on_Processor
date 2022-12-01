LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY mux12 IS
	PORT (	A, B	: IN STD_LOGIC_VECTOR(11 DOWNTO 0);	-- 12bit inputs
			s	: IN STD_LOGIC;	-- select (NOT A / B)
			F	: OUT STD_LOGIC_VECTOR(11 DOWNTO 0) );	-- 12bit output
END mux12;

ARCHITECTURE Structure OF mux12 IS
BEGIN
	mux : FOR i IN 0 TO 11 GENERATE
		mux_bit: F(i) <= (A(i) AND NOT s) OR (B(i) AND s);
	END GENERATE mux;
END Structure;