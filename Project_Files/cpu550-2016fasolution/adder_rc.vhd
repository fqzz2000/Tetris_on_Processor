LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- An n-bit ripple-carry adder.
-- By Tyler Bletsch for Duke ECE550, Fall 2016

ENTITY adder_rc IS
	GENERIC(n: integer:=4);
	PORT (	
		A, B : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		cin  : IN STD_LOGIC;
		cout : OUT STD_LOGIC;
		sum  : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		signed_overflow : OUT STD_LOGIC 	);
END adder_rc;

ARCHITECTURE Structure OF adder_rc IS
	SIGNAL carry : STD_LOGIC_VECTOR(n DOWNTO 0);
	SIGNAL sum_s : STD_LOGIC_VECTOR(n-1 DOWNTO 0);
BEGIN
	carry(0) <= cin;
	gen: FOR i IN 0 TO n-1 GENERATE
		sum_s(i) <= carry(i) XOR A(i) XOR B(i);
		carry(i+1) <= (A(i) AND B(i)) OR (A(i) AND carry(i)) OR (B(i) AND carry(i));
	END GENERATE gen;
	cout <= carry(n);
	sum <= sum_s;
	signed_overflow <= carry(n) XOR carry(n-1);
END Structure;