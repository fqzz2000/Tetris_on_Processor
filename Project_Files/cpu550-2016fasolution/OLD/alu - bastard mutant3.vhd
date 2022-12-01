LIBRARY ieee;
USE ieee.std_logic_1164.all;

ENTITY alu IS
	PORT (	data_operandA, data_operandB	: IN STD_LOGIC_VECTOR(31 DOWNTO 0);	-- 32bit inputs
			ctrl_ALUopcode	: IN STD_LOGIC_VECTOR(2 DOWNTO 0);	-- 3bit ALU opcode
			data_result	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);	-- 32bit output
			isEqual, isGreaterThan	: OUT STD_LOGIC);
END alu;

ARCHITECTURE Structure OF alu IS
	SIGNAL real_B, addResult, shiftResult, andResult, orResult, AndOrResult, AddShiftResult	: STD_LOGIC_VECTOR(31 DOWNTO 0);	-- internal results
	SIGNAL select_And_Or, select_Add_Shift, select_AndOr_AddShift, ctrl_subtract, ctrl_rightshift, addResultCarryOut, so_flag : STD_LOGIC;
	COMPONENT adder
		PORT (	data_addendA, data_addendB	: IN STD_LOGIC_VECTOR(31 DOWNTO 0);	-- 32bit inputs
				ctrl_subtract	: IN STD_LOGIC;	-- subtraction control (NOT add / subtract)
				data_sum	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);	-- 32bit sum output
				data_carryout	: OUT STD_LOGIC);
	END COMPONENT;
	COMPONENT adder_rc
		GENERIC(n: integer:=32);
		PORT (	
			A, B : IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			cin  : IN STD_LOGIC;
			cout : OUT STD_LOGIC;
			sum  : OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0);
			signed_overflow : OUT STD_LOGIC	);
	END COMPONENT;
	COMPONENT shifter
		PORT (	A	: IN STD_LOGIC_VECTOR(31 DOWNTO 0);
				shiftright	: IN STD_LOGIC;	-- shift direction (right / NOT left)
				shamt	: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
				R	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0) );
	END COMPONENT;
	COMPONENT muxGeneric
		GENERIC(n: integer:=16);
		PORT (	A, B	: IN STD_LOGIC_VECTOR(n-1 DOWNTO 0);	-- 32bit inputs
				s	: IN STD_LOGIC;	-- select (NOT A / B)
				F	: OUT STD_LOGIC_VECTOR(n-1 DOWNTO 0) );	-- 32bit output
	END COMPONENT;
BEGIN
	ctrl_subtract <= ctrl_ALUopcode(0);
	ctrl_rightshift <= ctrl_ALUopcode(0);
	intB : FOR i IN 0 TO 31 GENERATE
		intB_vector: real_B(i) <= data_operandB(i) XOR ctrl_subtract;
	END GENERATE intB;
	--add:	adder PORT MAP (data_operandA, data_operandB, ctrl_subtract, addResult, addResultCarryOut);
	add:	adder_rc GENERIC MAP (n=>32) PORT MAP (data_operandA, real_B, ctrl_subtract, addResultCarryOut, addResult, so_flag);
	shift:	shifter PORT MAP (data_operandA, ctrl_rightshift, data_operandB(4 DOWNTO 0), shiftResult);
	andResult <= data_operandA AND data_operandB;
	orResult <= data_operandA OR data_operandB;
	--bitwise:	FOR i IN 0 TO 31 GENERATE
	--	bitwise_and: andResult(i) <= data_operandA(i) AND data_operandB(i);
	--	bitwise_or: orResult(i) <= data_operandA(i) OR data_operandB(i);
	--END GENERATE bitwise;
	--select_And_Or <= ctrl_ALUopcode(0);
	--select_Add_Shift <= ctrl_ALUopcode(2);
	--select_AndOr_AddShift <= ctrl_ALUopcode(2) OR NOT ctrl_ALUopcode(1);
	--mux1:	muxGeneric GENERIC MAP (n => 32) PORT MAP (andResult, orResult, select_And_Or, AndOrResult);
	--mux2:	muxGeneric GENERIC MAP (n => 32) PORT MAP (addResult, shiftResult, select_Add_Shift, AddShiftResult);
	--mux3:	muxGeneric GENERIC MAP (n => 32) PORT MAP (AndOrResult, AddShiftResult, select_AndOr_AddShift, data_result);
	data_result <= addResult   WHEN ctrl_ALUopcode="000" else
	  addResult   WHEN ctrl_ALUopcode="001" else -- subtract handled via op_subtract
	  andResult   WHEN ctrl_ALUopcode="010" else
	  orResult    WHEN ctrl_ALUopcode="011" else
	  shiftResult WHEN ctrl_ALUopcode="100" else -- shift direction handled by op_shiftright
	  shiftResult WHEN ctrl_ALUopcode="101" else -- shift direction handled by op_shiftright
	  (others=>'0'); -- output 0 if an invalid op is given
	--isEqual <= (data_operandA(0) XNOR data_operandB(0)) AND (data_operandA(1) XNOR data_operandB(1)) AND (data_operandA(2) XNOR data_operandB(2)) AND (data_operandA(3) XNOR data_operandB(3)) AND (data_operandA(4) XNOR data_operandB(4)) AND (data_operandA(5) XNOR data_operandB(5)) AND (data_operandA(6) XNOR data_operandB(6)) AND (data_operandA(7) XNOR data_operandB(7)) AND (data_operandA(8) XNOR data_operandB(8)) AND (data_operandA(9) XNOR data_operandB(9)) AND (data_operandA(10) XNOR data_operandB(10)) AND (data_operandA(11) XNOR data_operandB(11)) AND (data_operandA(12) XNOR data_operandB(12)) AND (data_operandA(13) XNOR data_operandB(13)) AND (data_operandA(14) XNOR data_operandB(14)) AND (data_operandA(15) XNOR data_operandB(15)) AND (data_operandA(16) XNOR data_operandB(16)) AND (data_operandA(17) XNOR data_operandB(17)) AND (data_operandA(18) XNOR data_operandB(18)) AND (data_operandA(19) XNOR data_operandB(19)) AND (data_operandA(20) XNOR data_operandB(20)) AND (data_operandA(21) XNOR data_operandB(21)) AND (data_operandA(22) XNOR data_operandB(22)) AND (data_operandA(23) XNOR data_operandB(23)) AND (data_operandA(24) XNOR data_operandB(24)) AND (data_operandA(25) XNOR data_operandB(25)) AND (data_operandA(26) XNOR data_operandB(26)) AND (data_operandA(27) XNOR data_operandB(27)) AND (data_operandA(28) XNOR data_operandB(28)) AND (data_operandA(29) XNOR data_operandB(29)) AND (data_operandA(30) XNOR data_operandB(30)) AND (data_operandA(31) XNOR data_operandB(31));
	isEqual <= not (addResult(0) or addResult(1) or addResult(2) or addResult(3) or addResult(4) or addResult(5) or addResult(6) or addResult(7) or addResult(8) or addResult(9) or addResult(10) or addResult(11) or addResult(12) or addResult(13) or addResult(14) or addResult(15) or addResult(16) or addResult(17) or addResult(18) or addResult(19) or addResult(20) or addResult(21) or addResult(22) or addResult(23) or addResult(24) or addResult(25) or addResult(26) or addResult(27) or addResult(28) or addResult(29) or addResult(30) or addResult(31)); 
	
	
	
	isGreaterThan <= addResult(31) OR (data_operandA(31) AND NOT data_operandB(31));
END Structure;