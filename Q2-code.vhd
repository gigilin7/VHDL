--**************************************************
--*    Scanning Keyboard And Display Key in DATA   *
--*      In Scanning Seven Segment  LED (1DIG)     *
--*      Filename : SEGMENT_KEYBOARD_1DIG.VHD      *
--************************************************

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
 
entity  SEGMENT_KEYBOARD_1DIG is
    Port ( CLK     : in std_logic;
           RESET   : in std_logic;
	      ROW     : in std_logic_vector(3 downto 0);
           COLUMN  : out std_logic_vector(3 downto 0);
           POINTER : out std_logic;
           ENABLE  : out std_logic_vector(6 downto 1);
		 SEGMENT : out std_logic_vector(6 downto 0));
end  SEGMENT_KEYBOARD_1DIG;

architecture Behavioral of  SEGMENT_KEYBOARD_1DIG is
  signal COUNT_CLK : std_logic;
  signal PRESS          : std_logic;
  signal PRESS_VALID    : std_logic;
  signal DEBOUNCE_CLK   : std_logic;
  signal DIVIDER        : std_logic_vector(13 downto 0);
  signal DEBOUNCE_COUNT : std_logic_vector(3 downto 0);
  signal SCAN_CODE      : std_logic_vector(3 downto 0);
  signal KEY_CODE       : std_logic_vector(3 downto 0);
  signal KEY_CODE1       : std_logic_vector(3 downto 0);
begin

--******************************
--*   Debounce CLK Generator   *
--******************************

  process(CLK,RESET)
    begin 
	 if RESET      = '0' then 
	    DIVIDER   <= "00000000000000";
	 elsif CLK'event and CLK = '1' then
	    DIVIDER   <= DIVIDER + 1;
	 end if;

	 if DIVIDER(7)='1'
	 then ENABLE <= "111110";
	 else ENABLE <= "111101";
	 end if;

  end process;
  DEBOUNCE_CLK <= DIVIDER(13);
  
--********************************
--*  Generate Scanning Key Code  *
--********************************
 
  process (CLK,RESET)
    begin
      if RESET      = '0' then 
	    SCAN_CODE <= "0000";
	 elsif CLK'event and CLK = '1' then
	    if PRESS   = '1' then
	       SCAN_CODE <= SCAN_CODE + 1;
	    end if;
	 end if;
  end process;

--***********************
--*  Scanning Keyboard  *
--***********************

  COLUMN <= "1110" when SCAN_CODE(3 downto 2) = "00" else
            "1101" when SCAN_CODE(3 downto 2) = "01" else
	       "1011" when SCAN_CODE(3 downto 2) = "10" else 
		  "0111";
  PRESS  <= ROW(0) when SCAN_CODE(1 downto 0) = "00" else
            ROW(1) when SCAN_CODE(1 downto 0) = "01" else
	       ROW(2) when SCAN_CODE(1 downto 0) = "10" else
		  ROW(3); 

--**********************
--*  Debounce Control  *
--**********************

  process(DEBOUNCE_CLK,PRESS,RESET)
    begin
      if RESET             = '0' then
	    DEBOUNCE_COUNT   <= "0000";
	 elsif PRESS          = '1' then
	    DEBOUNCE_COUNT   <= "0000";
	 elsif DEBOUNCE_CLK'event and DEBOUNCE_CLK = '1' then
	   if DEBOUNCE_COUNT <= "1110" then
	      DEBOUNCE_COUNT <= DEBOUNCE_COUNT + 1;
	   end if;
	 end if;
	 if DEBOUNCE_COUNT = "1101" then
	    PRESS_VALID   <= '1';
	 else
	    PRESS_VALID   <= '0';
	 end if;    
 end process; 

--***********************************************
--*  Fetch Pressed Key Code And Store In Buffer *
--***********************************************
 
  process (DEBOUNCE_CLK,RESET)

    begin
      if RESET     = '0' then
	    KEY_CODE <= "0000";
	    KEY_CODE1 <= "0000";
	 elsif DEBOUNCE_CLK'event and DEBOUNCE_CLK = '1' then 
	   if PRESS_VALID = '1' then
	   case SCAN_CODE is
     when "1010"=>	KEY_CODE1 <= "0001";
				KEY_CODE  <= "0000";
     when "1011"=>	KEY_CODE1 <= "0001"; 
				KEY_CODE  <= "0001";
     when "1100"=>	KEY_CODE1 <= "0001"; 
				KEY_CODE  <= "0010";
     when "1101"=>	KEY_CODE1 <= "0001"; 
				KEY_CODE  <= "0011";
     when "1110"=>	KEY_CODE1 <= "0001";
				KEY_CODE  <= "0100";
     when "1111"=>	KEY_CODE1 <= "0001"; 
				KEY_CODE  <= "0101";
	when others=>	KEY_CODE  <= SCAN_CODE;
			     KEY_CODE1 <= "0000";
  end case;	   
               
--           if SCAN_CODE="1010"
--		 then KEY_CODE1 <= "0001";
--		      KEY_CODE  <= "0000";
--	      elsif  SCAN_CODE="1011"
--		 then KEY_CODE1 <= "0001";
--		      KEY_CODE  <= "0001";
--		 elsif  SCAN_CODE="1100"
--		 then KEY_CODE1 <= "0001";
--		      KEY_CODE  <= "0010";
--		 elsif  SCAN_CODE="1101"
--		 then KEY_CODE1 <= "0001";
--		      KEY_CODE  <= "0011";
--		 elsif  SCAN_CODE="1110"
--		 then KEY_CODE1 <= "0001";
--		      KEY_CODE  <= "0100";
--		 elsif  SCAN_CODE="1111"
--		 then KEY_CODE1 <= "0001";
--		      KEY_CODE  <= "0101";
--	      else
--		 	 KEY_CODE  <= SCAN_CODE;
--			 KEY_CODE1 <= "0000";
--		 end if;

        end if;
      end if;
  end process;


--*************************
--*  Counter From 0 To 9  *
--*************************

  process (COUNT_CLK,RESET)

   begin
	if RESET   = '0' then 
	   KEY_CODE    <= "0000";
	   KEY_CODE1   <= "0000";
	elsif COUNT_CLK'event and COUNT_CLK = '1' then
	   if KEY_CODE  = "1001" then
	      KEY_CODE<= "0000";
		 KEY_CODE1 <= "0001";
	   else KEY_CODE <= KEY_CODE + 1;
	   end if;
--	    if KEY_CODE1 = "0101" then
--	       KEY_CODE1 <= "0000";
--	    else
--	       KEY_CODE1 <= KEY_CODE1 + 1;
--	    end if;
	   
	end if;
  end process;


--**********************************
--*  BCD To Seven Segment Decoder  *
--**********************************

   process(DIVIDER(7))
  begin
  if DIVIDER(7)='1' then
  case KEY_CODE is
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
  case KEY_CODE1 is
     when "0000"=>	SEGMENT <= "1000000"; 	-- 0
     when "0001"=>	SEGMENT <= "1111001";	-- 1
     when others=>	SEGMENT <= "1111111";
  end case;	
     POINTER <= '1';
--	ENABLE    <= "111110";
  end if;
  end process;
   

end Behavioral;

 