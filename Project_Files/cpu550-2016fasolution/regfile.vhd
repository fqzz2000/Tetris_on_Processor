LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY regfile IS
	PORT (	clock, wren, clear	: IN STD_LOGIC;
			regD, regA, regB	: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
			valD	: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			valA, valB	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0) );
END regfile;

ARCHITECTURE Structure OF regfile IS
	SIGNAL writeEnable, inEnable, readA, readB	: STD_LOGIC_VECTOR(31 DOWNTO 0);
	COMPONENT decoder5to32
		PORT (	s	: IN STD_LOGIC_VECTOR(4 DOWNTO 0);	-- 5bit select vector
				w	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0) );	-- selected output bit becomes high
	END COMPONENT;
	COMPONENT reg_2port IS
		GENERIC ( n : integer := 32 );
		PORT (	D	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
				clock, clear, enable, readA, readB : IN STD_LOGIC;
				Qa, Qb : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0) );
	END COMPONENT;
	COMPONENT reg0_2port IS
		GENERIC ( n : integer := 32 );
		PORT ( readA, readB : IN STD_LOGIC;
				Qa, Qb : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0) );
	END COMPONENT;
BEGIN
	writeDecode: decoder5to32 PORT MAP (regD, writeEnable);
	readDecodeA: decoder5to32 PORT MAP (regA, readA);
	readDecodeB: decoder5to32 PORT MAP (regB, readB);
	reg0: reg0_2port GENERIC MAP(n=>32) PORT MAP (readA=>readA(0), readB=>readB(0), Qa=>valA, Qb=>valB);
	regs : FOR i IN 1 TO 31 GENERATE
		inEnable(i) <= wren AND writeEnable(i);
		reg_array: reg_2port GENERIC MAP(n=>32) PORT MAP (D=>valD, clock=>clock, clear=>clear, enable=>inEnable(i), readA=>readA(i), readB=>readB(i), Qa=>valA, Qb=>valB);
	END GENERATE regs;
END;