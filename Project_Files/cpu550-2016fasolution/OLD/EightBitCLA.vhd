LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY EightBitCLA IS
	PORT (	A, B	: IN STD_LOGIC_VECTOR(7 DOWNTO 0);	-- 8bit addends
			carryIn	: IN STD_LOGIC;
			sum	: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);	-- 8bit sum output
			carryOut	: OUT STD_LOGIC);
END EightBitCLA;

ARCHITECTURE Structure OF EightBitCLA IS
	SIGNAL g0, g1, g2, g3, g4, g5, g6, g7	: STD_LOGIC;	-- generate
	SIGNAL p0, p1, p2, p3, p4, p5, p6, p7	: STD_LOGIC;	-- propagate
	SIGNAL c1, c2, c3, c4, c5, c6, c7	: STD_LOGIC;	-- internal carryins
	SIGNAL s0, s1, s2, s3, s4, s5, s6, s7	: STD_LOGIC;	-- sum
BEGIN
	g0 <= A(0) AND B(0);
	g1 <= A(1) AND B(1);
	g2 <= A(2) AND B(2);
	g3 <= A(3) AND B(3);
	g4 <= A(4) AND B(4);
	g5 <= A(5) AND B(5);
	g6 <= A(6) AND B(6);
	g7 <= A(7) AND B(7);
	p0 <= A(0) OR B(0);
	p1 <= A(1) OR B(1);
	p2 <= A(2) OR B(2);
	p3 <= A(3) OR B(3);
	p4 <= A(4) OR B(4);
	p5 <= A(5) OR B(5);
	p6 <= A(6) OR B(6);
	p7 <= A(7) OR B(7);
	c1 <= g0 OR (p0 AND carryIn);
	c2 <= g1 OR (p1 AND g0) OR (p1 AND p0 AND carryIn);
	c3 <= g2 OR (p2 AND g1) OR (p2 AND p1 AND g0) OR (p2 AND p1 AND p0 AND carryIn);
	c4 <= g3 OR (p3 AND g2) OR (p3 AND p2 AND g1) OR (p3 AND p2 AND p1 AND g0) OR (p3 AND p2 AND p1 AND p0 AND carryIn);
	c5 <= g4 OR (p4 AND g3) OR (p4 AND p3 AND g2) OR (p4 AND p3 AND p2 AND g1) OR (p4 AND p3 AND p2 AND p1 AND g0) OR (p4 AND p3 AND p2 AND p1 AND p0 AND carryIn);
	c6 <= g5 OR (p5 AND g4) OR (p5 AND p4 AND g3) OR (p5 AND p4 AND p3 AND g2) OR (p5 AND p4 AND p3 AND p2 AND g1) OR (p5 AND p4 AND p3 AND p2 AND p1 AND g0) OR (p5 AND p4 AND p3 AND p2 AND p1 AND p0 AND carryIn);
	c7 <= g6 OR (p6 AND g5) OR (p6 AND p5 AND g4) OR (p6 AND p5 AND p4 AND g3) OR (p6 AND p5 AND p4 AND p3 AND g2) OR (p6 AND p5 AND p4 AND p3 AND p2 AND g1) OR (p6 AND p5 AND p4 AND p3 AND p2 AND p1 AND g0) OR (p6 AND p5 AND p4 AND p3 AND p2 AND p1 AND p0 AND carryIn);
	carryOut <= g7 OR (p7 AND g6) OR (p7 AND p6 AND g5) OR (p7 AND p6 AND p5 AND g4) OR (p7 AND p6 AND p5 AND p4 AND g3) OR (p7 AND p6 AND p5 AND p4 AND p3 AND g2) OR (p7 AND p6 AND p5 AND p4 AND p3 AND p2 AND g1) OR (p7 AND p6 AND p5 AND p4 AND p3 AND p2 AND p1 AND g0) OR (p7 AND p6 AND p5 AND p4 AND p3 AND p2 AND p1 AND p0 AND carryIn);
	s0 <= carryIn XOR A(0) XOR B(0);
	s1 <= c1 XOR A(1) XOR B(1);
	s2 <= c2 XOR A(2) XOR B(2);
	s3 <= c3 XOR A(3) XOR B(3);
	s4 <= c4 XOR A(4) XOR B(4);
	s5 <= c5 XOR A(5) XOR B(5);
	s6 <= c6 XOR A(6) XOR B(6);
	s7 <= c7 XOR A(7) XOR B(7);
	sum <= s7&s6&s5&s4&s3&s2&s1&s0;
END Structure;
	