--***************************************
--*   Counter From 0 to 9 And Display	*
--*    In Scanning Seven Segment LED    *
--*  Filename : SEGMENT_COUNT_0_9.VHD 	*
--***************************************

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity SEGMENT_COUNT_0_9 is
    Port ( CLK      : in std_logic;
           RESET    : in std_logic;
		 POINTER  : out std_logic;
		 ENABLE   : out std_logic_vector(6 downto 1);
		 SEGMENT  : out std_logic_vector(6 downto 0));
end SEGMENT_COUNT_0_9;

architecture Behavioral of SEGMENT_COUNT_0_9 is
  signal COUNT_CLK : std_logic;
  signal DIVIDER   : std_logic_vector(24 downto 1);
  signal BCD       : std_logic_vector(3 downto 0);
  signal BCD1       : std_logic_vector(3 downto 0);
begin

--**************************
--*  Time Base Generation  *
--**************************

  process (CLK,RESET)

    begin
      if RESET    = '0' then
	    DIVIDER <= "000000000000000000000000";
	 elsif CLK'event and CLK = '1' then
	    DIVIDER <= DIVIDER + 1;
	 end if;

	 if DIVIDER(17)='1'
	 then ENABLE <= "111110";
	 else ENABLE <= "111101";
	 end if;					
  end process;
  COUNT_CLK <= DIVIDER(24);

--*************************
--*  Counter From 0 To 9  *
--*************************

  process (COUNT_CLK,RESET)

   begin
	if RESET   = '0' then 
	   BCD    <= "0000";
	   BCD1   <= "0000";
	elsif COUNT_CLK'event and COUNT_CLK = '1' then
	   if BCD  = "1001" then
	      BCD <= "0000";
	    if BCD1 = "0101" then
	       BCD1 <= "0000";
	    else
	       BCD1 <= BCD1 + 1;
	    end if;
	   else BCD <= BCD + 1;
	   end if;
	   end if;
  end process;



--**********************************
--*  BCD To Seven Segment Decoder  *
--**********************************
  process(DIVIDER(17))
  begin
  if DIVIDER(17)='1' then
  case BCD is
     when "0000"=>	SEGMENT <= "1000000"; 	-- 0
     when "0001"=>	SEGMENT <= "1111001";	-- 1
     when "0010"=>	SEGMENT <= "0100100";	-- 2
     when "0011"=>	SEGMENT <= "0110000";	-- 3
     when "0100"=>	SEGMENT <= "0011001";	-- 4
     when "0101"=>	SEGMENT <= "0010010";	-- 5
     when "0110"=>	SEGMENT <= "0000010";	-- 6
     when "0111"=>	SEGMENT <= "1111000";	-- 7
     when "1000"=>	SEGMENT <= "0000000";	-- 8
     when others=>	SEGMENT <= "1111111";
  end case;


  else
  case BCD1 is
     when "0000"=>	SEGMENT <= "1000000"; 	-- 0
     when "0001"=>	SEGMENT <= "1111001";	-- 1
     when "0010"=>	SEGMENT <= "0100100";	-- 2
     when "0011"=>	SEGMENT <= "0110000";	-- 3
     when "0100"=>	SEGMENT <= "0011001";	-- 4
     when "0101"=>	SEGMENT <= "0010010";	-- 5
     when others=>	SEGMENT <= "1111111";
  end case;	
     POINTER <= '1';
  end if;
  end process;
  
end Behavioral;




