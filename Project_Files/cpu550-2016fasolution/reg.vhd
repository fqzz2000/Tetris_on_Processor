LIBRARY ieee;
USE ieee.std_logic_1164.all;
LIBRARY altera;
USE altera.altera_primitives_components.all;

-- An n-bit register made of D flip flops
-- By Tyler Bletsch for Duke ECE550, Fall 2016

ENTITY reg IS
	GENERIC ( n : integer := 32 );
	PORT (	D	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			clock, clear, enable	: IN STD_LOGIC;
			Q	: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0) );
END reg;

ARCHITECTURE Structure OF reg IS
	SIGNAL clrn : STD_LOGIC;
	COMPONENT DFFE
		PORT (d   : IN STD_LOGIC;
			clk : IN STD_LOGIC;
			clrn: IN STD_LOGIC;
			prn : IN STD_LOGIC;
			ena : IN STD_LOGIC;
			q   : OUT STD_LOGIC );
	END COMPONENT;
BEGIN
	clrn <= NOT clear;
	bits : FOR i IN 0 TO n-1 GENERATE
		r: DFFE PORT MAP (d=>D(i), clk=>clock, clrn=>clrn, prn=>'1', ena=>enable, q=>Q(i));
	END GENERATE bits;
END;