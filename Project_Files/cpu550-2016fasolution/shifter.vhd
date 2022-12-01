LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- A 32-bit shifter
-- Author unknown, for Duke ECE550
-- Updated Fall 2016 by Tyler Bletsch

ENTITY shifter IS
	PORT (	A	: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
			shiftright	: IN STD_LOGIC;	-- shift direction (right / NOT left)
			shamt	: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
			R	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0) );
END shifter;

ARCHITECTURE Structure OF shifter IS
	SIGNAL L0, L1, L2, L3, L4, R0, R1, R2, R3, R4	: STD_LOGIC_VECTOR(31 DOWNTO 0);	-- 32bit mux interconnects
	COMPONENT mux
		GENERIC(n: integer:=32);
		PORT (	A, B	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
				s	: IN STD_LOGIC;	-- select (NOT A / B)
				F	: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0) );
	END COMPONENT;
	
	SIGNAL dd1, dd2, dd3, dd4, dd5, dd6, dd7, dd8, dd9, dd10 : STD_LOGIC_VECTOR(31 downto 0);
	
BEGIN

	dd1  <= A(30 DOWNTO 0) & "0";
	dd2  <= L0(29 DOWNTO 0) & "00";
	dd3  <= L1(27 DOWNTO 0) & "0000";
	dd4  <= L2(23 DOWNTO 0) & "00000000";
	dd5  <= L3(15 DOWNTO 0) & "0000000000000000";
	dd6  <= "0" & A(31 DOWNTO 1);
	dd7  <= "00" & R0(31 DOWNTO 2);
	dd8  <= "0000" & R1(31 DOWNTO 4);
	dd9  <= "00000000" & R2(31 DOWNTO 8);
	dd10 <= "0000000000000000" & R3(31 DOWNTO 16);

	Dxxxxx:	mux PORT MAP (L4, R4, shiftright, R);
	LxxxxN: 	mux PORT MAP ( A(31 DOWNTO 0), dd1, shamt(0), L0);
	LxxxNx:	mux PORT MAP (L0(31 DOWNTO 0), dd2, shamt(1), L1);
	LxxNxx:	mux PORT MAP (L1(31 DOWNTO 0), dd3, shamt(2), L2);
	LxNxxx: 	mux PORT MAP (L2(31 DOWNTO 0), dd4, shamt(3), L3);
	LNxxxx: 	mux PORT MAP (L3(31 DOWNTO 0), dd5, shamt(4), L4);
	RxxxxN:	mux PORT MAP ( A(31 DOWNTO 0), dd6, shamt(0), R0);
	RxxxNx: 	mux PORT MAP (R0(31 DOWNTO 0), dd7, shamt(1), R1);
	RxxNxx: 	mux PORT MAP (R1(31 DOWNTO 0), dd8, shamt(2), R2);
	RxNxxx: 	mux PORT MAP (R2(31 DOWNTO 0), dd9, shamt(3), R3);
	RNxxxx: 	mux PORT MAP (R3(31 DOWNTO 0), dd10,shamt(4), R4);
END Structure;