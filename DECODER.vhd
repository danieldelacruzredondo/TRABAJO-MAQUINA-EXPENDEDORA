LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
ENTITY decoder IS
PORT (

code : IN std_logic_vector(3 DOWNTO 0);
segment1 : OUT std_logic_vector(6 DOWNTO 0);  --display mas a la derecha
segment2 : OUT STD_LOGIC_VECTOR (6 downto 0); --segundo display
segment3: OUT STD_LOGIC_VECTOR (6 DOWNTO 0)   --tercer display
);
END ENTITY decoder;
ARCHITECTURE dataflow OF decoder IS

signal signal1: std_logic_vector (6 downto 0);
signal signal2: std_logic_vector (6 downto 0);
signal signal3: std_logic_vector (6 downto 0);

BEGIN

WITH code SELECT
signal1<=  "0000001" WHEN "0000",
        "0000001" WHEN "0001",
        "0000001" WHEN "0010",
        "0000001" WHEN "0011",
        "0000001" WHEN "0100",
        "0000001" WHEN "0101",
        "0000001" WHEN "0110",
        "0000001" WHEN "0111",
        "0000001" WHEN "1000",
        "0000001" WHEN "1001",
        "0000001" WHEN "1010",
        "1111110" WHEN others;
        
WITH code select
signal2 <= "0000001" WHEN "0000",
        "1001111" WHEN "0001",
        "0010010" WHEN "0010",
        "0000110" WHEN "0011",
        "1001100" WHEN "0100",
        "0100100" WHEN "0101",
        "0100000" WHEN "0110",
        "0001111" WHEN "0111",
        "0000000" WHEN "1000",
        "0000100" WHEN "1001",
        "0000001" WHEN "1010",
        "1111110" WHEN others;
        
WITH code select
signal3 <= "1001111" WHEN "1010",
        "1111110" WHEN others;

segment1<=signal1;
segment2<=signal2;
segment3<=signal3;
          
END ARCHITECTURE dataflow;
