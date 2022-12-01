library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

-- LCD control system
-- Author unknown, for Duke ECE550

entity lcd is
  port
  (
    clock,reset,write_en : in std_logic;
    data : in std_logic_vector(7 downto 0);
    lcd_data : out std_logic_vector(7 downto 0);
    lcd_rw,lcd_en,lcd_rs,lcd_on,lcd_blon : out std_logic
  );
end lcd;

architecture a of lcd is
  type state_type is (A,B,C,D);
  signal state1,state2 : state_type;

  signal curbuf : std_logic_vector(8 downto 0);
  type line_type is array(0 to 15) of std_logic_vector(7 downto 0);
  signal line1,line2 : line_type;

  signal ptr : integer range 0 to 15;
  signal index : integer range 0 to 63;
  signal delay : integer range 0 to 262143;
  signal count : integer range 0 to 31;
  signal cstart,cdone,prestart,mstart : std_logic;
  signal printed_crlf,valid_char,buf_changed,buf_changed_ack : std_logic;
begin

  valid_char <= '1' when conv_integer(data) >= 32 and conv_integer(data) < 128 else '0';
  process(clock,reset)
  begin
    if(reset='1') then
      buf_changed <= '0';
      printed_crlf <= '0';
      ptr <= 0;

      for i in 0 to 15 loop
        line1(i) <= X"20";
        line2(i) <= X"20";
      end loop;

    elsif(rising_edge(clock)) then

      if(buf_changed_ack='1') then
        buf_changed <= '0';
      end if;

      if(write_en='1') then
        if(data = X"0D" or (ptr=0 and valid_char='1' and printed_crlf='0')) then
          for i in 0 to 15 loop
            line1(i) <= line2(i);
            line2(i) <= X"20";
            buf_changed <= '1';
          end loop;
          ptr <= 0;
        end if;

        if(data = X"0D") then
          printed_crlf <= '1';
        elsif(valid_char='1') then
          printed_crlf <= '0';
          line2(ptr) <= data;
          ptr <= ptr+1;
          buf_changed <= '1';
        end if;
      end if;
    end if;
  end process;

  process(index,line1,line2)
  begin
    if(index=0) then
      curbuf <= '0' & X"38";
    elsif(index=1) then
      curbuf <= '0' & X"0C";
    elsif(index=2) then
      curbuf <= '0' & X"01";
    elsif(index=3) then
      curbuf <= '0' & X"06";
    elsif(index=4) then
      curbuf <= '0' & X"80";
    elsif(index=21) then
      curbuf <= '0' & X"C0";
    elsif(index < 21) then
      curbuf <= '1' & line1(index-5);
    else
      curbuf <= '1' & line2(index-22);
    end if;
  end process;

  process(clock,reset)
  begin
    if(reset='1') then
      buf_changed_ack <= '0';
      index <= 0;
      state1 <= A;
      delay <= 0;
      cstart <= '0';
      lcd_data <= (others => '0');
      lcd_rs <= '0';
    elsif(rising_edge(clock)) then
      if(index <= 37) then
        buf_changed_ack <= '0';
        case state1 is
        when A =>
          lcd_data <= curbuf(7 downto 0);
          lcd_rs <= curbuf(8);
          cstart <= '1';
          state1 <= B;
        when B =>
          if(cdone='1') then
            cstart <= '0';
            state1 <= C;
          end if;
        when C =>
          if(delay < 262142) then
            delay <= delay+1;
          else
            delay <= 0;
            state1 <= D;
          end if;
        when D =>
          index <= index+1;
          state1 <= A;
        end case;
      elsif(buf_changed='1') then
        buf_changed_ack <= '1';
        index <= 0;
      end if;
    end if;
  end process;

  process(clock,reset)
  begin
    if(reset='1') then
      cdone <= '0';
      lcd_en <= '0';
      prestart <= '0';
      mstart <= '0';
      count <= 0;
      state2 <= A;
    elsif(rising_edge(clock)) then
      if(prestart='0' and cstart='1') then
        mstart <= '1';
        cdone <= '0';
      end if;
      prestart <= cstart;

      if(mstart='1') then
        case state2 is
          when A =>
            state2 <= B;
          when B =>
            lcd_en <= '1';
            state2 <= C;
          when C =>
            if(count<16) then
              count <= count+1;
            else
              state2 <= D;
            end if;
          when D =>
            lcd_en <= '0';
            mstart <= '0';
            cdone <= '1';
            count <= 0;
            state2 <= A;
        end case;
      end if;
    end if;
  end process;

  lcd_rw <= '0';
  lcd_blon <= '1';
  lcd_on <= '1';
end a;