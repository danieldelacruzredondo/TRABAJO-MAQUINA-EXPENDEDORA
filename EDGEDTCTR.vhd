library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity EDGEDTCTR is
 port (
 
 CLK : in std_logic;
 SYNC_IN1 : in std_logic;
 SYNC_IN2 : in std_logic;
 SYNC_IN3 : in std_logic;
 SYNC_IN4 : in std_logic;
 RESET: IN STD_LOGIC;
 EDGE1 : out std_logic;
 EDGE2 : out std_logic;
 EDGE3 : out std_logic;
 EDGE4 : out std_logic

 );
end EDGEDTCTR;
architecture BEHAVIORAL of EDGEDTCTR is

 signal sreg1 : std_logic_vector(2 downto 0);
 signal sreg2 : std_logic_vector(2 downto 0);
 signal sreg3 : std_logic_vector(2 downto 0);
 signal sreg4 : std_logic_vector(2 downto 0);
 
begin
 process (CLK, RESET)
 begin
 if(RESET='0') then
    sreg1<="000";
    sreg2<="000";
    sreg3<="000";
    sreg4<="000";
 elsif rising_edge(CLK) then
 
 sreg1 <= sreg1(1 downto 0) & SYNC_IN1;
 sreg2 <= sreg2(1 downto 0) & SYNC_IN2;
 sreg3 <= sreg3(1 downto 0) & SYNC_IN3;
 sreg4 <= sreg4(1 downto 0) & SYNC_IN4;
 
 end if;
 end process;
 
 with sreg1 select
 EDGE1 <= '1' when "100",
          '0' when others;
 with sreg2 select       
 EDGE2 <=  '1' when "100",
           '0' when others;
            
 with sreg3 select
 EDGE3 <= '1' when "100",
          '0' when others;
 
 with sreg4 select    
 EDGE4 <= '1' when "100",
          '0' when others;
          
end BEHAVIORAL;
 
 

