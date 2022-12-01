LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY muxGeneric IS
	GENERIC(n: integer:=16);
	PORT (	A, B	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);	-- 16bit inputs
			s	: IN STD_LOGIC;	-- select (NOT A / B)
			F	: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0) );	-- 16bit output
END muxGeneric;

ARCHITECTURE Structure OF muxGeneric IS
BEGIN
	mux : FOR i IN 0 TO n-1 GENERATE
		mux_bit: F(i) <= (A(i) AND NOT s) OR (B(i) AND s);
	END GENERATE mux;
END Structure;