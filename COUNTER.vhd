library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;


entity COUNTER is Port ( 
    CLK: IN STD_LOGIC;
    RESET: IN STD_LOGIC;
    BTNC_10: IN STD_LOGIC;
    BTNU_20: IN STD_LOGIC;
    BTNL_50: IN STD_LOGIC;
    BTND_100: IN STD_LOGIC;
    DINERO_TOT: OUT STD_LOGIC_VECTOR (3 DOWNTO 0)-- Introducimos hasta un máximo de 1,50 que 
                                                 -- es lo que costarán las bebidas.
);
end COUNTER;

architecture Behavioral of COUNTER is
signal contador_aux: unsigned (4 downto 0):="00000";
begin
process(clk,reset)
begin
    if reset='0' then
        contador_aux<= "0000";
    elsif rising_edge(clk) then
        if BTNC_10 = '1' then
            contador_aux<=contador_aux + "0001";
            end if;
        if BTNU_20 = '1' then
            contador_aux<=contador_aux + "0010";
            end if;
        if BTNL_50 = '1' then
            contador_aux<=contador_aux + "0101";
            end if;
        if BTND_100 = '1' then
            contador_aux<=contador_aux + "1010";
            end if;


    end if;
    end process;
 with contador_aux select
 DINERO_TOT  <= "0000" when "00000",  -- 0C INTRODUCIDOS
                "0001" when "00001",  -- 10C INTRODUCIDOS
                "0010" when "00010",  -- 20C INTRODUCIDOS
                "0011" when "00011",  -- 30C INTRODUCIDOS
                "0100" when "00100",  -- 40C INTRODUCIDOS
                "0101" when "00101",  -- 50C INTRODUCIDOS
                "0110" when "00110",  -- 60C INTRODUCIDOS
                "0111" when "00111",  -- 70C INTRODUCIDOS
                "1000" when "01000",  -- 80C INTRODUCIDOS
                "1001" when "01001",  -- 90C INTRODUCIDOS
                "1010" when "01010",  -- 100C INTRODUCIDOS
                "1011" when "01011",  -- 110C INTRODUCIDOS
                "1100" when "01100",  -- 120C INTRODUCIDOS
                "1101" when "01101",  -- 130C INTRODUCIDOS
                "1110" when "01110",  -- 140C INTRODUCIDOS
                "1111" when others;
                                 
end Behavioral;
