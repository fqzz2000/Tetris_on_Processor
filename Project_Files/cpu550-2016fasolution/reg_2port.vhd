LIBRARY ieee;
USE ieee.std_logic_1164.all;
LIBRARY altera;
USE altera.altera_primitives_components.all;

-- An n-bit register with two tri-state outputs
-- By Tyler Bletsch for Duke ECE550, Fall 2016

ENTITY reg_2port IS
	GENERIC ( n : integer := 32 );
	PORT (	D	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			clock, clear, enable, readA, readB : IN STD_LOGIC;
			Qa, Qb : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0) );
END reg_2port;

ARCHITECTURE Structure OF reg_2port IS
	SIGNAL Q	: STD_LOGIC_VECTOR(n-1 DOWNTO 0);
	COMPONENT reg
		GENERIC ( n : integer := 32 );
		PORT (	D	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
				clock, clear, enable	: IN STD_LOGIC;
				Q	: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0) );
	END COMPONENT;
	COMPONENT TRI
    PORT (
        a_in  :  in    std_logic;
        oe    :  in    std_logic;
        a_out :  out   std_logic);
	END COMPONENT;
BEGIN
	r: reg GENERIC MAP (n=>n) PORT MAP (D=>D, clock=>clock, clear=>clear, enable=>enable, Q=>Q);
	bits : FOR i IN 0 TO n-1 GENERATE
		ta: TRI PORT MAP (a_in=>Q(i), oe=>readA, a_out=>Qa(i));
		tb: TRI PORT MAP (a_in=>Q(i), oe=>readB, a_out=>Qb(i));
	END GENERATE bits;
END;