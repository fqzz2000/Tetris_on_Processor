LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY regfile IS
	PORT (	clock, ctrl_writeEnable, ctrl_reset	: IN STD_LOGIC;
			ctrl_writeReg, ctrl_readRegA, ctrl_readRegB	: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
			data_writeReg	: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			data_readRegA, data_readRegB	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0) );
END regfile;

ARCHITECTURE Structure OF regfile IS
	SIGNAL writeEnable, outEnableA, outEnableB	: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL inEnable	: STD_LOGIC_VECTOR(31 DOWNTO 1);
	COMPONENT decoder5to32
		PORT (	s	: IN STD_LOGIC_VECTOR(4 DOWNTO 0);	-- 5bit select vector
				w	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0) );	-- selected output bit becomes high
	END COMPONENT;
	COMPONENT register32bit
		PORT (	D	: IN STD_LOGIC_VECTOR(31 DOWNTO 0);	-- 32bits data input
				clock, clear, inEnable, outEnableA, outEnableB	: IN STD_LOGIC;
				Qa, Qb	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0) );	-- 32bits data output
	END COMPONENT;
	COMPONENT register0
		PORT (	outEnableA, outEnableB	: IN STD_LOGIC;
				Qa, Qb	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0) );
	END COMPONENT;
BEGIN
	writeDecode: decoder5to32 PORT MAP (ctrl_writeReg, writeEnable);
	readDecodeA: decoder5to32 PORT MAP (ctrl_readRegA, outEnableA);
	readDecodeB: decoder5to32 PORT MAP (ctrl_readRegB, outEnableB);
	reg0: register0 PORT MAP (outEnableA(0), outEnableB(0), data_readRegA, data_readRegB);
	regs : FOR i IN 1 TO 31 GENERATE
		inEnable(i) <= ctrl_writeEnable AND writeEnable(i);
		reg_array: register32bit PORT MAP (data_writeReg, clock, ctrl_reset, inEnable(i), outEnableA(i), outEnableB(i), data_readRegA, data_readRegB);
	END GENERATE regs;
END;