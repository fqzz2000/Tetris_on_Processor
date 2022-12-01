LIBRARY ieee;
USE ieee.std_logic_1164.all;
	
ENTITY adder IS
	PORT (	data_addendA, data_addendB	: IN STD_LOGIC_VECTOR(31 DOWNTO 0);	-- 32bit inputs
			ctrl_subtract	: IN STD_LOGIC;	-- subtraction control (NOT add / subtract)
			data_sum	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);	-- 32bit sum output
			data_carryout	: OUT STD_LOGIC);	-- carry output
END adder;

ARCHITECTURE Structure OF adder IS
	SIGNAL int_addendB	: STD_LOGIC_VECTOR(31 DOWNTO 0);
	COMPONENT ThirtyTwoBitCSLA
		PORT (	A, B	: IN STD_LOGIC_VECTOR(31 DOWNTO 0);	-- 32bit inputs
				carryIn	: IN STD_LOGIC;
				sum	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);	-- 32bit sum output
				carryOut : OUT STD_LOGIC );
	END COMPONENT;
BEGIN
	intB : FOR i IN 0 TO 31 GENERATE
		intB_vector: int_addendB(i) <= data_addendB(i) XOR ctrl_subtract;
	END GENERATE intB;
	adder: ThirtyTwoBitCSLA PORT MAP (data_addendA, int_addendB, ctrl_subtract, data_sum, data_carryout);
END Structure;