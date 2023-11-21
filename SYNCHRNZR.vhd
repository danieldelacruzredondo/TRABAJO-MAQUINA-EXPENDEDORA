library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity SYNCHRNZR is
 port (
 CLK : in std_logic;
 ASYNC1_IN : in std_logic;
 ASYNC2_IN: in std_logic;
 ASYNC3_IN : in std_logic;
 ASYNC4_IN : in std_logic;
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
 process (CLK)
 begin
 if rising_edge(CLK) then
 sync_out1 <= sreg1(1);
 sreg1 <= sreg1(0) & async1_in;
 
 sync_out2 <= sreg2(1);
 sreg2 <= sreg2(0) & async2_in;
 
 sync_out3 <= sreg3(1);
 sreg3 <= sreg3(0) & async3_in;
 
 sync_out4 <= sreg4(1);
 sreg4 <= sreg4(0) & async4_in;
 
 end if;
 end process;
end BEHAVIORAL;
