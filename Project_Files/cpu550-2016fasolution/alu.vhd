LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- An Arithmetic/Logic Unit (ALU)
-- By Dr. Tyler Bletsch for Duke ECE550, Fall 2016

-- ops:
--  000 add
--  001 subtract
--  010 and
--  011 or
--  100 shift left logical
--  101 shift right logical


ENTITY alu IS
	PORT (	A, B	: IN STD_LOGIC_VECTOR(31 DOWNTO 0);	-- 32bit inputs
			op	: IN STD_LOGIC_VECTOR(2 DOWNTO 0);	-- 3bit ALU opcode
			R	: OUT STD_LOGIC_VECTOR(31 DOWNTO 0);	-- 32bit output
			isEqual : OUT STD_LOGIC; -- true if A=B
			isLessThan	: OUT STD_LOGIC ); -- true if A<B
END alu;

ARCHITECTURE Structure OF alu IS
	SIGNAL R_add, R_shift, R_and, R_or : STD_LOGIC_VECTOR(31 DOWNTO 0);	-- internal results
	SIGNAL op_subtract, op_shiftright : STD_LOGIC; -- control signals
	SIGNAL zero_flag, sign_flag, overflow_flag: STD_LOGIC; -- flags from add operation (based on x86 ALu flags)
	SIGNAL B_prime : STD_LOGIC_VECTOR(31 DOWNTO 0); -- possibly negated for subtraction
	COMPONENT adder_cs
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
BEGIN
	op_subtract <= op(0);
	op_shiftright <= op(0);
	
	intB : FOR i IN 0 TO 31 GENERATE
		intB_vector: B_prime(i) <= B(i) XOR op_subtract;
	END GENERATE intB;
	adder_inst: adder_cs GENERIC MAP (n => 32) PORT MAP (A=>A, B=>B_prime, cin=>op_subtract, sum=>R_add, signed_overflow=>overflow_flag);
	zero_flag <= not (R_add(0) or R_add(1) or R_add(2) or R_add(3) or R_add(4) or R_add(5) or R_add(6) or R_add(7) or R_add(8) or R_add(9) or R_add(10) or R_add(11) or R_add(12) or R_add(13) or R_add(14) or R_add(15) or R_add(16) or R_add(17) or R_add(18) or R_add(19) or R_add(20) or R_add(21) or R_add(22) or R_add(23) or R_add(24) or R_add(25) or R_add(26) or R_add(27) or R_add(28) or R_add(29) or R_add(30) or R_add(31)); 
	sign_flag <= R_add(31);
	-- overflow_flag set by adder directly
	
	shifter_inst: shifter PORT MAP(A=>A, shiftright=>op_shiftright, shamt=>B(4 DOWNTO 0), R=>R_shift);
	
	R_and <= A AND B;
	
	R_or <= A OR B;
	
	R <= R_add   WHEN op="000" else
		  R_add   WHEN op="001" else -- subtract handled via op_subtract
		  R_and   WHEN op="010" else
		  R_or    WHEN op="011" else
		  R_shift WHEN op="100" else -- shift direction handled by op_shiftright
		  R_shift WHEN op="101" else -- shift direction handled by op_shiftright
		  (others=>'0'); -- output 0 if an invalid op is given
	
	-- we compare values directly rather than assume subtraction, that way the isEqual output works regardless of ALU op
	isEqual <= (A(0) XNOR B(0)) AND (A(1) XNOR B(1)) AND (A(2) XNOR B(2)) AND (A(3) XNOR B(3)) AND (A(4) XNOR B(4)) AND (A(5) XNOR B(5)) AND (A(6) XNOR B(6)) AND (A(7) XNOR B(7)) AND (A(8) XNOR B(8)) AND (A(9) XNOR B(9)) AND (A(10) XNOR B(10)) AND (A(11) XNOR B(11)) AND (A(12) XNOR B(12)) AND (A(13) XNOR B(13)) AND (A(14) XNOR B(14)) AND (A(15) XNOR B(15)) AND (A(16) XNOR B(16)) AND (A(17) XNOR B(17)) AND (A(18) XNOR B(18)) AND (A(19) XNOR B(19)) AND (A(20) XNOR B(20)) AND (A(21) XNOR B(21)) AND (A(22) XNOR B(22)) AND (A(23) XNOR B(23)) AND (A(24) XNOR B(24)) AND (A(25) XNOR B(25)) AND (A(26) XNOR B(26)) AND (A(27) XNOR B(27)) AND (A(28) XNOR B(28)) AND (A(29) XNOR B(29)) AND (A(30) XNOR B(30)) AND (A(31) XNOR B(31));
	
	-- this definition is based on how Intel x86 determines LESS THAN (see http://unixwiz.net/techtips/x86-jumps.html)
	-- (requires op to be subtract)
	isLessThan <= (sign_flag XOR overflow_flag); 
	
	
END Structure;