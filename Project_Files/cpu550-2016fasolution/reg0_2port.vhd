LIBRARY ieee;
USE ieee.std_logic_1164.all;
LIBRARY altera;
USE altera.altera_primitives_components.all;

-- An n-bit "register 0" (always contains zero) with two tri-state outputs
-- By Tyler Bletsch for Duke ECE550, Fall 2016

ENTITY reg0_2port IS
	GENERIC ( n : integer := 32 );
		PORT ( readA, readB : IN STD_LOGIC;
				Qa, Qb : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0) );
END reg0_2port;

ARCHITECTURE Structure OF reg0_2port IS
	COMPONENT TRI
    PORT (
        a_in  :  in    std_logic;
        oe    :  in    std_logic;
        a_out :  out   std_logic);
	END COMPONENT;
BEGIN
	bits : FOR i IN 0 TO n-1 GENERATE
		ta: TRI PORT MAP (a_in=>'0', oe=>readA, a_out=>Qa(i));
		tb: TRI PORT MAP (a_in=>'0', oe=>readB, a_out=>Qb(i));
	END GENERATE bits;
END;