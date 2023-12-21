library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity SYNCHRNZR is
 port (
 CLK : in std_logic;
 ASYNC_IN1 : in std_logic;
 ASYNC_IN2 : in std_logic;
 ASYNC_IN3 : in std_logic;
 ASYNC_IN4 : in std_logic;
 RESET: IN std_logic;
 SYNC_OUT1 : out std_logic;
 SYNC_OUT2 : out std_logic;
 SYNC_OUT3 : out std_logic;
 SYNC_OUT4 : out std_logic
 );
end SYNCHRNZR;

architecture BEHAVIORAL of SYNCHRNZR is

 signal sreg1 : std_logic_vector(1 downto 0);
 signal sreg2 : std_logic_vector(1 downto 0);
 signal sreg3 : std_logic_vector(1 downto 0);
 signal sreg4 : std_logic_vector(1 downto 0);
 
begin
 process (CLK, reset)
 begin
 if(reset='0') then
    sync_out1<= '0';
    sreg1 <="00";
    sync_out2<= '0';
    sreg2 <="00";
    sync_out3<= '0';
    sreg3 <="00";
    sync_out4<= '0';
    sreg4 <="00";
    
 elsif rising_edge(CLK) then
 
 sync_out1 <= sreg1(1);
 sreg1 <= sreg1(0) & async_in1;
 
 sync_out2 <= sreg2(1);
 sreg2 <= sreg2(0) & async_in2;
 
 sync_out3 <= sreg3(1);
 sreg3 <= sreg3(0) & async_in3;
 
 sync_out4 <= sreg4(1);
 sreg4 <= sreg4(0) & async_in4;
  
 end if;
 end process;
end BEHAVIORAL;

