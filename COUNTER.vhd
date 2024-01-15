library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;


entity COUNTER is Port ( 
    CLK: IN STD_LOGIC;
    RESET: IN STD_LOGIC;    
    BOTON: IN STD_LOGIC_VECTOR (3 DOWNTO 0);   
    REC_PROD: IN STD_LOGIC:='0'; -- Inicializamos la variable de recoger producto.
    DINERO_TOT: OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
    IMP_EXACTO: OUT STD_LOGIC -- Devuelve un '1' cuando llegamos al 1,40 y se lo pasamos a la FSM.
);
end COUNTER;

architecture Behavioral of COUNTER is

signal contador_aux: unsigned (4 downto 0):="00000";
signal contador_aux2: std_logic_vector (4 downto 0);
signal ven: std_logic:='0';-- Igualar a 0


begin
process(clk,reset)
begin
    if reset='0' then
        contador_aux<= "00000";   
        
    elsif rising_edge(clk) then
        if BOTON = "0001" then -- Sumamos 10 cents.
            contador_aux<=contador_aux + "00001";
            end if;
        if BOTON = "0010" then --Sumamos 20 cents.
            contador_aux<=contador_aux + "00010";
            end if;
        if BOTON = "0100" then -- Sumamos 50 cents.
            contador_aux<=contador_aux + "00101";
            end if;
        if BOTON = "1000" then --Sumamos 1 euro.
            contador_aux<=contador_aux + "01010";
            end if;
        if REC_PROD ='1' then   
            contador_aux<="00000";
            end if;


    end if;
    end process;
    contador_aux2<= STD_LOGIC_VECTOR(contador_aux);
    
    process(contador_aux2)
    begin
    
    if contador_aux2 = "01110" THEN 
                 ven<='1'; -- Pasamos un '1' a la FSM cuando lleguemos al 1,40$
    end if;   
    end process;   
        
               
    IMP_EXACTO<=ven;
    
 with contador_aux2 select
 
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
