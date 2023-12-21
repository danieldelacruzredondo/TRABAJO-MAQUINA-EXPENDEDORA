LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
ENTITY decoder IS
PORT (
CLK: IN STD_LOGIC;
RESET: IN STD_LOGIC;
code : IN std_logic_vector(3 DOWNTO 0);
anodo : OUT std_logic_vector(7 DOWNTO 0);
segment : OUT STD_LOGIC_VECTOR (6 downto 0);
DP: OUT STD_LOGIC

);
END ENTITY decoder;

ARCHITECTURE dataflow OF decoder IS
signal display_activation : std_logic_vector(1 DOWNTO 0); --para activar el display
signal refresh_count : std_logic_vector(20 DOWNTO 0);
signal LED_BCD : std_logic_vector(3 DOWNTO 0);
signal code_decimas : std_logic_vector(3 DOWNTO 0);
signal enable_anodo : std_logic_vector(3 DOWNTO 0);
signal displayed_numbers : std_logic_vector(15 DOWNTO 0); --para meter los 4 bits a cada display
BEGIN

display_activation <= refresh_count (19 DOWNTO 18);--Cambio
enable_anodo <= "1111";

process(clk, reset)  --divisor de reloj
BEGIN
    if (reset = '0') then
       refresh_count <= (others => '0');
    else if (rising_edge(clk)) then
       refresh_count <= refresh_count + 1;
    end if;
    end if;
end process;

process(code)  --para dirigir el valor de code a las entradas de los multiplexores
BEGIN
   if (code > "1001") then  --HAY QUE AÑADIR EL VALOR (0) A LOS OTROS SEGMENTOS
      code_decimas <= code - x"A";  --En hexadecimal
      displayed_numbers(11 DOWNTO 8) <= code_decimas;  --PARA 12 DA 10, Y PARA 15 DA 12
      displayed_numbers(7 DOWNTO 4) <= "0001";
   else
      displayed_numbers(11 DOWNTO 8) <= code;
      displayed_numbers(7 DOWNTO 4) <= "0000";
   end if;
end process;

process(display_activation)  --mux
BEGIN
   case display_activation is
   when "00" =>
      LED_BCD <= displayed_numbers(15 DOWNTO 12);
      DP<='1';
      --anodo <= "0111";
   when "01" =>
      LED_BCD <= displayed_numbers(11 DOWNTO 8);
      DP<='1';
      --anodo <= "1011";
   when "10" =>
      LED_BCD <= displayed_numbers(7 DOWNTO 4);
      DP<='0';
      --anodo <= "1101";
   when "11" =>
      LED_BCD <= displayed_numbers(3 DOWNTO 0);
      DP<='1';
      --anodo <= "1110";
   when others =>
        DP<='1';
      report "Error";
   end case;
end process;

process(LED_BCD)  --decoder de 7 segmentos
BEGIN
    case LED_BCD is -- señal de decenas de centimo: de 0 a 9 hasta los 90 cents y de 0 a 4 hasta el 1.4$  
    WHEN "0000" => segment <= "0000001";
    WHEN "0001" => segment <= "1001111";
    WHEN "0010" => segment <= "0010010";
    WHEN "0011" => segment <= "0000110";
    WHEN "0100" => segment <= "1001100";
    WHEN "0101" => segment <= "0100100";
    WHEN "0110" => segment <= "0100000";
    WHEN "0111" => segment <= "0001111";
    WHEN "1000" => segment <= "0000000";
    WHEN "1001" => segment <= "0000100";
    WHEN others => segment <= "1111110";
    end case;
end process;

process(display_activation, enable_anodo) --activador y desactivador de anodos
BEGIN
   anodo <= "11111111";
  if enable_anodo(conv_integer(display_activation)) = '1' then
      anodo(conv_integer(display_activation)) <= '0';
   end if;
end process;  

END ARCHITECTURE dataflow;
