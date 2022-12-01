LIBRARY ieee;
USE ieee.std_logic_1164.all;

-- Control logic for the Duke 550 processor
-- Author unknown, for Duke ECE550

ENTITY control IS
	PORT (	op	: IN STD_LOGIC_VECTOR(4 DOWNTO 0);	-- instruction opcode
			reg_wren	: OUT STD_LOGIC;	-- register file write enable
			immed_notRT	: OUT STD_LOGIC;	-- mux select immediate instead of $rt
			rs_zero, rt_zero	: OUT STD_LOGIC;	-- force $rs or $rt to zero
			rd_to_rt	: OUT STD_LOGIC;	-- redirect $rd write register to $rt read register
			ALUopcode	: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);	-- ALU opcode to ALU
			dmem_wren	: OUT STD_LOGIC;	-- data memory write enable
			mem_notALU	: OUT STD_LOGIC;	-- register write data from memory instead of ALU
			branch_equals, branch_greater	: OUT STD_LOGIC;	-- branches
			jump	: OUT STD_LOGIC;	-- jump or jump-and-link
			link	: OUT STD_LOGIC;	-- jump-and-link store PC to $r31
			jump_reg	: OUT STD_LOGIC;	-- return PC from register
			keyboard	: OUT STD_LOGIC;	-- input
			lcd	: OUT STD_LOGIC);	-- output
END control;

ARCHITECTURE Behavior OF control IS
BEGIN
	reg_wren <= '1' WHEN op="00000"	-- add
					OR op="00001"	-- sub
					OR op="00010"	-- and
					OR op="00011"	-- or
					OR op="00100"	-- sll
					OR op="00101"	-- srl
					OR op="00110"	-- addi
					OR op="00111"	-- lw
					OR op="01101"	-- jal
					OR op="01110"	-- input
					ELSE '0';
	immed_notRT <= '1' WHEN op="00110"	-- addi
					OR op="00111"		-- lw
					OR op="01000"		-- sw
					ELSE '0';
	rs_zero <= '1' WHEN op="01011"	-- jr
					OR op="01100"	-- j
					OR op="01101"	-- jal
					OR op="01110"	-- input
					OR op="01111"	-- output
					ELSE '0';
	rt_zero <= '1' WHEN op="00110"	-- addi
					OR op="00111"	-- lw
					OR op="01100"	-- j
					OR op="01101"	-- jal
					OR op="01110"	-- input
					ELSE '0';
	rd_to_rt <= '1' WHEN op="01000"	-- sw
					OR op="01001"	-- beq
					OR op="01010"	-- bgt
					OR op="01011"	-- jr
					OR op="01111"	-- output
					ELSE '0';
	ALUopcode <= "000" WHEN op="00000"	-- add
			ELSE "001" WHEN op="00001"	-- sub
			ELSE "010" WHEN op="00010"	-- and
			ELSE "011" WHEN op="00011"	-- or
			ELSE "100" WHEN op="00100"	-- sll
			ELSE "101" WHEN op="00101"	-- srl
			ELSE "001" WHEN op="01010"	-- bgt
			ELSE "001" WHEN op="01001"	-- beq -- tkb!
			ELSE "000";
	dmem_wren <= '1' WHEN op="01000"	-- sw
					ELSE '0';
	mem_notALU <= '1' WHEN op="00111"	-- lw
					ELSE '0';
	branch_equals <= '1' WHEN op="01001"	-- beq
						ELSE '0';
	branch_greater <= '1' WHEN op="01010"	-- bgt
						ELSE '0';
	jump <= '1' WHEN op="01100"	-- j
				OR op="01101"	-- jal
				ELSE '0';
	link <= '1' WHEN op="01101"	-- jal
				ELSE '0';
	jump_reg <= '1' WHEN op="01011"	-- jr
					ELSE '0';
	keyboard <= '1' WHEN op="01110"	-- input
					ELSE '0';
	lcd <= '1' WHEN op="01111"	-- output
				ELSE '0';
END Behavior;