library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity EDGEDTCTR is
 port (
 CLK : in std_logic;
 SYNC_IN : in std_logic;
 RESET: IN STD_LOGIC;
 EDGE : out std_logic

 );
end EDGEDTCTR;
architecture BEHAVIORAL of EDGEDTCTR is
 signal sreg : std_logic_vector(2 downto 0);
 
begin
 process (CLK, RESET)
 begin
 if(RESET='0') then
    sreg<="000";
 elsif rising_edge(CLK) then
 sreg <= sreg(1 downto 0) & SYNC_IN;
 end if;
 end process;

 EDGE <= '0' when RESET = '0'
        else '1' when sreg = "100"
        else '0';
end BEHAVIORAL;

 
 

