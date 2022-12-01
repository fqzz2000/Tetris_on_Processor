LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY decoder5to32 IS
	PORT (	s	: IN STD_LOGIC_VECTOR(4 DOWNTO 0);	-- 5bit select vector
			w	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0) );	-- selected output bit becomes high
END decoder5to32;

ARCHITECTURE Structure OF decoder5to32 IS
BEGIN
	w(0) <= NOT s(4) AND NOT s(3) AND NOT s(2) AND NOT s(1) AND NOT s(0);
	w(1) <= NOT s(4) AND NOT s(3) AND NOT s(2) AND NOT s(1) AND s(0);
	w(2) <= NOT s(4) AND NOT s(3) AND NOT s(2) AND s(1) AND NOT s(0);
	w(3) <= NOT s(4) AND NOT s(3) AND NOT s(2) AND s(1) AND s(0);
	w(4) <= NOT s(4) AND NOT s(3) AND s(2) AND NOT s(1) AND NOT s(0);
	w(5) <= NOT s(4) AND NOT s(3) AND s(2) AND NOT s(1) AND s(0);
	w(6) <= NOT s(4) AND NOT s(3) AND s(2) AND s(1) AND NOT s(0);
	w(7) <= NOT s(4) AND NOT s(3) AND s(2) AND s(1) AND s(0);
	w(8) <= NOT s(4) AND s(3) AND NOT s(2) AND NOT s(1) AND NOT s(0);
	w(9) <= NOT s(4) AND s(3) AND NOT s(2) AND NOT s(1) AND s(0);
	w(10) <= NOT s(4) AND s(3) AND NOT s(2) AND s(1) AND NOT s(0);
	w(11) <= NOT s(4) AND s(3) AND NOT s(2) AND s(1) AND s(0);
	w(12) <= NOT s(4) AND s(3) AND s(2) AND NOT s(1) AND NOT s(0);
	w(13) <= NOT s(4) AND s(3) AND s(2) AND NOT s(1) AND s(0);
	w(14) <= NOT s(4) AND s(3) AND s(2) AND s(1) AND NOT s(0);
	w(15) <= NOT s(4) AND s(3) AND s(2) AND s(1) AND s(0);
	w(16) <= s(4) AND NOT s(3) AND NOT s(2) AND NOT s(1) AND NOT s(0);
	w(17) <= s(4) AND NOT s(3) AND NOT s(2) AND NOT s(1) AND s(0);
	w(18) <= s(4) AND NOT s(3) AND NOT s(2) AND s(1) AND NOT s(0);
	w(19) <= s(4) AND NOT s(3) AND NOT s(2) AND s(1) AND s(0);
	w(20) <= s(4) AND NOT s(3) AND s(2) AND NOT s(1) AND NOT s(0);
	w(21) <= s(4) AND NOT s(3) AND s(2) AND NOT s(1) AND s(0);
	w(22) <= s(4) AND NOT s(3) AND s(2) AND s(1) AND NOT s(0);
	w(23) <= s(4) AND NOT s(3) AND s(2) AND s(1) AND s(0);
	w(24) <= s(4) AND s(3) AND NOT s(2) AND NOT s(1) AND NOT s(0);
	w(25) <= s(4) AND s(3) AND NOT s(2) AND NOT s(1) AND s(0);
	w(26) <= s(4) AND s(3) AND NOT s(2) AND s(1) AND NOT s(0);
	w(27) <= s(4) AND s(3) AND NOT s(2) AND s(1) AND s(0);
	w(28) <= s(4) AND s(3) AND s(2) AND NOT s(1) AND NOT s(0);
	w(29) <= s(4) AND s(3) AND s(2) AND NOT s(1) AND s(0);
	w(30) <= s(4) AND s(3) AND s(2) AND s(1) AND NOT s(0);
	w(31) <= s(4) AND s(3) AND s(2) AND s(1) AND s(0);
END;