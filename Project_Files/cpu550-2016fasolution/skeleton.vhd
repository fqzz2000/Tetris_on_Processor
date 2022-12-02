LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;

-- Top-level entity for the Duke 550 processor system
-- Author unknown, for Duke ECE550
-- Updated Fall 2016 by Tyler Bletsch

ENTITY skeleton IS
	PORT (	inclock, resetn, ps2_clock, ps2_data	: IN STD_LOGIC;
			lcd_data, leds	: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
			lcd_rw, lcd_en, lcd_rs, lcd_on, lcd_blon	: OUT STD_LOGIC;--);
			-- ADDED BY QUANZHI--
			VGA_CLK, VGA_HS, VGA_VS, VGA_BLANK, VGA_SYNC : OUT STD_LOGIC; -- PORT FOR VGA
			VGA_R, VGA_G, VGA_B : OUT STD_LOGIC_VECTOR(7 DOWNTO 0)); -- DATA FOR VGA
END skeleton;

ARCHITECTURE Structure OF skeleton IS
	SIGNAL lcd_write_en, ps2_acknowledge	: STD_LOGIC;
	SIGNAL lcd_write_data, ps2_ascii	: STD_LOGIC_VECTOR(31 DOWNTO 0);
	SIGNAL clock	: STD_LOGIC;
	SIGNAL flag	: STD_LOGIC;
	COMPONENT ps2 IS
		PORT (	clock, reset, acknowledge, ps2_clock, ps2_data	: IN STD_LOGIC;
				output	: OUT STD_LOGIC_VECTOR(8 DOWNTO 0) );
	END COMPONENT;
	COMPONENT lcd IS
		PORT (	clock, reset, write_en : IN STD_LOGIC;
				data	: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
				lcd_data	: OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
				lcd_rw,lcd_en,lcd_rs,lcd_on,lcd_blon : OUT STD_LOGIC);
	END COMPONENT;
	COMPONENT processor IS
		PORT (	clock, reset	: IN STD_LOGIC;
				keyboard_in	: IN STD_LOGIC_VECTOR(31 downto 0);
				keyboard_ack, lcd_write	: OUT STD_LOGIC;
				lcd_data	: OUT STD_LOGIC_VECTOR(31 downto 0);
				out_data : OUT STD_LOGIC_VECTOR(1999 DOWNTO 0));
	END COMPONENT;
	COMPONENT pll IS
		PORT (	inclk0	: IN STD_LOGIC;
				c0	: OUT STD_LOGIC);
	END COMPONENT;
	-- add by Quanzhi VGA Related module --
	COMPONENT Reset_Delay IS
		PORT ( iCLK : IN STD_LOGIC;
				oRESET : OUT STD_LOGIC);
	END COMPONENT;
	
	COMPONENT VGA_Audio_PLL IS
		PORT (	areset : IN STD_LOGIC;
				inclk0 : IN STD_LOGIC;
				c0 : OUT STD_LOGIC;
				c1 : OUT STD_LOGIC;
				c2 : OUT STD_LOGIC);
	END COMPONENT;	
	
	COMPONENT vga_controller IS
		PORT (	iRST_n : IN STD_LOGIC;
				iVGA_CLK : IN STD_LOGIC;
				grid_data : IN STD_LOGIC_VECTOR(1999 DOWNTO 0);
				oBLANK_n : OUT STD_LOGIC;
				oHS : OUT STD_LOGIC;
				oVS : OUT STD_LOGIC;
				b_data : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
				g_data : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
				r_data : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
	END COMPONENT;
	-- end section --
	
	SIGNAL reset : STD_LOGIC;
	-- SIGNAL ADD BY QUANZHI --
	SIGNAL DLY_RST : STD_LOGIC;
	SIGNAL NDLY_RST : STD_LOGIC;
	SIGNAL VGA_CTRL_CLK : STD_LOGIC;
	SIGNAL AUD_CTRL_CLK : STD_LOGIC;
	SIGNAL VGA_CLK_FOR_CTRL : STD_LOGIC;
	SIGNAL VGA_BUFFER : STD_LOGIC_VECTOR(1999 DOWNTO 0);
	-- END SECTION --
BEGIN
	--clock divider
	div:	pll PORT MAP (inclock, clock);
	--clock <= inclock;

	-- your processor
	reset <= NOT resetn;
	myprocessor: processor PORT MAP (clock, reset, ps2_ascii, ps2_acknowledge, lcd_write_en, lcd_write_data, VGA_BUFFER);

	-- keyboard controller
	myps2:	ps2 PORT MAP (clock, reset, ps2_acknowledge, ps2_clock, ps2_data, ps2_ascii(8 DOWNTO 0));
	ps2_ascii(31 DOWNTO 9) <= (OTHERS => '0');

	-- lcd controller
	mylcd:	lcd PORT MAP (clock, reset, lcd_write_en, lcd_write_data(7 DOWNTO 0), lcd_data, lcd_rw, lcd_en, lcd_rs, lcd_on, lcd_blon);

	-- some LEDs that you could use for debugging if you wanted
	leds <= "00101010";
	
	-- added by Quanzhi --
	NDLY_RST <= NOT DLY_RST;
	VGA_CLK <= VGA_CLK_FOR_CTRL;
	r0:		Reset_Delay PORT MAP (inclock, DLY_RST);
	p1:		VGA_Audio_PLL PORT MAP (NDLY_RST, inclock, VGA_CTRL_CLK, AUD_CTRL_CLK, VGA_CLK_FOR_CTRL);
	vga_ins: vga_controller PORT MAP (DLY_RST, VGA_CLK_FOR_CTRL, VGA_BUFFER, VGA_BLANK, VGA_HS, VGA_VS, VGA_B, VGA_G, VGA_R);
	-- end section --
END Structure;