LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- An n-bit adder with one level of carry-select.
-- By Tyler Bletsch for Duke ECE550, Fall 2016

ENTITY adder_cs IS
	GENERIC(n: integer:=8);
	PORT (	
		A, B : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		cin  : IN STD_LOGIC;
		cout : OUT STD_LOGIC;
		sum  : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0);
		signed_overflow : OUT STD_LOGIC	);
END adder_cs;

ARCHITECTURE Structure OF adder_cs IS
	SIGNAL cout_lo, cout_hi0, cout_hi1 : STD_LOGIC;	-- internal carry / multiplexer select
	SIGNAL sum_hi0, sum_hi1	: STD_LOGIC_VECTOR(n/2-1 DOWNTO 0);	-- temporary High vectors for port mapping
	SIGNAL so_hi0, so_hi1 : STD_LOGIC;
	COMPONENT adder_rc
		GENERIC(n: integer:=4);
		PORT (	
			A, B : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			cin  : IN STD_LOGIC;
			cout : OUT STD_LOGIC;
			sum  : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			signed_overflow : OUT STD_LOGIC	);
	END COMPONENT;
	COMPONENT mux
		GENERIC(n: integer:=16);
		PORT (	A, B	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
				s	: IN STD_LOGIC;	-- select (NOT A / B)
				F	: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0) );
	END COMPONENT;
BEGIN
	lower:	adder_rc GENERIC MAP (n => n/2) PORT MAP (A=>A(n/2-1 DOWNTO 0), B=>B(n/2-1 DOWNTO 0), cin=>cin, cout=>cout_lo, sum=>sum(n/2-1 DOWNTO 0));
	upper0:	adder_rc GENERIC MAP (n => n/2) PORT MAP (A=>A(n-1 DOWNTO n/2), B=>B(n-1 DOWNTO n/2), cin=>'0', cout=>cout_hi0, sum=>sum_hi0, signed_overflow=>so_hi0);
	upper1:	adder_rc GENERIC MAP (n => n/2) PORT MAP (A=>A(n-1 DOWNTO n/2), B=>B(n-1 DOWNTO n/2), cin=>'1', cout=>cout_hi1, sum=>sum_hi1, signed_overflow=>so_hi1);
	upper:	mux GENERIC MAP (n=>n/2) PORT MAP (A=>sum_hi0, B=>sum_hi1, s=>cout_lo, F=>sum(n-1 DOWNTO n/2));
	cout <= (cout_hi0 AND NOT cout_lo) OR (cout_hi1 AND cout_lo);
	signed_overflow <= (so_hi0 AND NOT cout_lo) OR (so_hi1 AND cout_lo);
	
END Structure;