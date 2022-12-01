library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

-- Interface for PS/2 keyboards
-- Author unknown, for Duke ECE550

entity ps2 is
  port
  (
    clock,reset,acknowledge,ps2_clock,ps2_data : in std_logic;
    output : out std_logic_vector(8 downto 0)
  );
end ps2;

architecture a of ps2 is
  constant FILTER_CYCLES : integer := 32;
  constant FIFO_DEPTH : integer := 32;

  signal head,tail : integer range 0 to FIFO_DEPTH-1;
  signal size : integer range 0 to 2*FIFO_DEPTH-1;
  signal fifo_in : std_logic_vector(7 downto 0);

  type fifo_type is array(FIFO_DEPTH-1 downto 0) of std_logic_vector(6 downto 0);
  signal fifo : fifo_type;

  signal ps2_clock_filtered,fifo_write : std_logic;

  signal last_value : std_logic;
  signal fcount : integer range 0 to FILTER_CYCLES-1;
 
  signal prev_clock : std_logic;
  signal bcount : integer range 0 to 15;
  signal reading_key : std_logic;
  signal break_code,shift : std_logic;
  signal shift_reg : std_logic_vector(8 downto 0);

  signal temp : integer range 0 to 127;

type scancode_table is array(0 to 255) of integer range 0 to 127;
constant scancode : scancode_table :=
(
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 9, 96, 0,
  0, 0, 0, 0, 0, 113, 49, 0, 0, 0, 122, 115, 97, 119, 50, 0,
  0, 99, 120, 100, 101, 52, 51, 0, 0, 32, 118, 102, 116, 114, 53, 0,
  0, 110, 98, 104, 103, 121, 54, 0, 0, 0, 109, 106, 117, 55, 56, 0,
  0, 44, 107, 105, 111, 48, 57, 0, 0, 46, 47, 108, 59, 112, 45, 0,
  0, 0, 39, 0, 91, 61, 0, 0, 0, 0, 13, 93, 0, 92, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
);
constant scancode_shift : scancode_table :=
(
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 9, 96, 0,
  0, 0, 0, 0, 0, 81, 49, 0, 0, 0, 90, 83, 65, 87, 50, 0,
  0, 67, 88, 68, 69, 52, 51, 0, 0, 32, 86, 70, 84, 82, 53, 0,
  0, 78, 66, 72, 71, 89, 54, 0, 0, 0, 77, 74, 85, 55, 56, 0,
  0, 44, 75, 73, 79, 48, 57, 0, 0, 46, 47, 76, 59, 80, 45, 0,
  0, 0, 39, 0, 91, 61, 0, 0, 0, 0, 13, 93, 0, 92, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0,
  0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0
);

begin
  -- low-pass filter the ps2_clock signal
  process(clock,reset)
  begin
    if(reset='1') then
      ps2_clock_filtered <= '1';
      last_value <= '0';
      fcount <= 0;
    elsif(rising_edge(clock)) then
      if(ps2_clock=last_value) then
        if(fcount=FILTER_CYCLES-1) then
          ps2_clock_filtered <= last_value;
        else
          fcount <= fcount+1;
        end if;
      else
        fcount <= 0;
      end if;
      last_value <= ps2_clock;
    end if;
  end process;

  process(clock,reset)
  begin
    if(reset='1') then

      bcount <= 0;
      break_code <= '0';
      reading_key <= '0';
      fifo_write <= '0';
      shift_reg <= (others=>'0');
      prev_clock <= '1';
      shift <= '0';

    elsif(rising_edge(clock)) then

      if(reading_key='0') then
        bcount <= 0;
        fifo_write <= '0';
        if(ps2_clock_filtered='0' and prev_clock='1') then
          reading_key <= '1';
        end if;
      else
        if(ps2_clock_filtered='0' and prev_clock='1') then
          if(bcount=9) then
            reading_key <= '0';
            if(shift_reg(7 downto 0)=X"F0") then
              break_code <= '1';
            else
              if(shift_reg(7 downto 0)=X"12") then
                shift <= not break_code;
              elsif(break_code='0' and fifo_in /= X"00") then
                fifo_write <= '1';
              end if;
              break_code <= '0';
            end if;
          else
            shift_reg <= ps2_data & shift_reg(8 downto 1);
            bcount <= bcount+1;
          end if;
        end if;
      end if;

      prev_clock <= ps2_clock_filtered;

    end if;
  end process;

  fifo_in <= conv_std_logic_vector(scancode(conv_integer(shift_reg(7 downto 0))),8) when shift='0' else conv_std_logic_vector(scancode_shift(conv_integer(shift_reg(7 downto 0))),8);
  process(clock,reset)
  begin
    if(reset='1') then
      head <= 0;
      tail <= 0;
      size <= 0;
    elsif(rising_edge(clock)) then

      if(fifo_write='1' and size /= FIFO_DEPTH and acknowledge='1' and size /= 0) then
        head <= head+1;
        fifo(tail) <= fifo_in(6 downto 0);
        tail <= tail+1;
      elsif(fifo_write='1' and size /= FIFO_DEPTH) then
        fifo(tail) <= fifo_in(6 downto 0);
        tail <= tail+1;
        size <= size+1;
      elsif(acknowledge='1' and size /= 0) then
        head <= head+1;
        size <= size-1;
      end if;

    end if;
  end process;

  output(8) <= '1' when size=0 else '0';
  output(7) <= '0';
  output(6 downto 0) <= fifo(head);

end a;
