LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;
ENTITY decoder IS
PORT (
CLK: IN STD_LOGIC;
RESET: IN STD_LOGIC;
code : IN std_logic_vector(3 DOWNTO 0);
SELE_PROD : IN STD_LOGIC_VECTOR (3 downto 0);
venta_display: IN std_logic;  --Aqui entraria la variable de error o venta del counter o de la maquina de estados

anodo : OUT std_logic_vector(7 DOWNTO 0);
segment : OUT STD_LOGIC_VECTOR (6 downto 0);
DP: OUT STD_LOGIC

);
END ENTITY decoder;

ARCHITECTURE dataflow OF decoder IS
signal display_activation : std_logic_vector(2 DOWNTO 0); --para activar el display
signal refresh_count : std_logic_vector(20 DOWNTO 0) := (others => '0');
signal LED_BCD : std_logic_vector(3 DOWNTO 0);
--signal LED_ESTADOS : std_logic_vector(7 DOWNTO 4);
signal code_decimas : std_logic_vector(3 DOWNTO 0);
signal enable_anodo : std_logic_vector(7 DOWNTO 0);
signal displayed_numbers : std_logic_vector(31 DOWNTO 0); --para meter los 4 bits a cada display
BEGIN

--LED_ESTADOS era la señal que controlaba el error y la venta,
--pero al final no la he usado porque no me funcionaba,
--se podria implementar cambiando el codigo

display_activation <= refresh_count (20 DOWNTO 18);
enable_anodo <= "11111111";

process(clk, reset)  --divisor de reloj
BEGIN
    if (reset = '0') then
       refresh_count <= (others => '0');
       
   
    
        elsif (rising_edge(clk)) then
       refresh_count <= refresh_count + '1';
    end if;
    
end process;

process(code)  --para dirigir el valor de code a las entradas de los multiplexores
BEGIN
   if (code > "1001") then
      code_decimas <= code - x"A";  --En hexadecimal
      displayed_numbers(3 DOWNTO 0) <= "0000";
      displayed_numbers(7 DOWNTO 4) <= code_decimas;  
      displayed_numbers(11 DOWNTO 8) <= "0001";
      displayed_numbers(15 DOWNTO 12) <= "0000";
   else
      displayed_numbers(3 DOWNTO 0) <= "0000";
      displayed_numbers(7 DOWNTO 4) <= code;
      displayed_numbers(11 DOWNTO 8) <= "0000";
      displayed_numbers(15 DOWNTO 12) <= "0000";
   end if;
end process;

process(venta_display)  --CONTROL ESCRITURA DISPLAY DE LA IZQUIERDA
BEGIN
   if (venta_display = '1') then  --VENTA
      displayed_numbers(31 DOWNTO 28) <= "1100";
      displayed_numbers(27 DOWNTO 24) <= "0000";
      displayed_numbers(23 DOWNTO 20) <= "1110";
      displayed_numbers(19 DOWNTO 16) <= "1111";
   elsif (venta_display = '0') then  --SELECCION DE PRODUCTO (No se ha hecho el testbench con esto)
      if (SELE_PROD = "0001") then
         displayed_numbers(31 DOWNTO 28) <= "1101";
         displayed_numbers(27 DOWNTO 24) <= "1010";
         displayed_numbers(23 DOWNTO 20) <= "0100";
         displayed_numbers(19 DOWNTO 16) <= "1101";
      elsif (SELE_PROD = "0010") then
         displayed_numbers(31 DOWNTO 28) <= "1101";
         displayed_numbers(27 DOWNTO 24) <= "1010";
         displayed_numbers(23 DOWNTO 20) <= "0011";
         displayed_numbers(19 DOWNTO 16) <= "1101";
      elsif (SELE_PROD = "0100") then
         displayed_numbers(31 DOWNTO 28) <= "1101";
         displayed_numbers(27 DOWNTO 24) <= "1010";
         displayed_numbers(23 DOWNTO 20) <= "0010";
         displayed_numbers(19 DOWNTO 16) <= "1101";
      elsif (SELE_PROD = "1000") then
         displayed_numbers(31 DOWNTO 28) <= "1101";
         displayed_numbers(27 DOWNTO 24) <= "1010";
         displayed_numbers(23 DOWNTO 20) <= "0001";
         displayed_numbers(19 DOWNTO 16) <= "1101";
      elsif (SELE_PROD = "0000") then
         displayed_numbers(31 DOWNTO 28) <= "1100";
         displayed_numbers(27 DOWNTO 24) <= "1011";
         displayed_numbers(23 DOWNTO 20) <= "1110";
         displayed_numbers(19 DOWNTO 16) <= "1010";
   end if;
   end if;
--   if (error = '1') then  -- AQUI PONDRIAMOS EL ERROR SI AL FINAL LO QUEREMOS METER
--      displayed_numbers(31 DOWNTO 28) <= "0001";
--      displayed_numbers(27 DOWNTO 24) <= "0010";
--      displayed_numbers(23 DOWNTO 20) <= "0010";
--      displayed_numbers(19 DOWNTO 16) <= "0110";
--   end if;
end process;

process(display_activation)  --mux para la activacion de cada display
BEGIN
   case display_activation is
   when "000" =>
      LED_BCD <= displayed_numbers(3 DOWNTO 0);
      DP<='1';
      --anodo <= "1110";
   when "001" =>
      LED_BCD <= displayed_numbers(7 DOWNTO 4);
      DP<='1';
      --anodo <= "1101";
   when "010" =>
      LED_BCD <= displayed_numbers(11 DOWNTO 8);
      DP<='0';
      --anodo <= "1011";
   when "011" =>
      LED_BCD <= displayed_numbers(15 DOWNTO 12);
      DP<='1';
      --anodo <= "0111";
   when "100" =>
      LED_BCD <= displayed_numbers(19 DOWNTO 16);
      DP<='1';
   when "101" =>
      LED_BCD <= displayed_numbers(23 DOWNTO 20);
      DP<='0';
   when "110" =>
      LED_BCD <= displayed_numbers(27 DOWNTO 24);
      DP<='1';
   when "111" =>
      LED_BCD <= displayed_numbers(31 DOWNTO 28);
      DP<='1';
   when others =>
      DP<='1';
      report "Error";
   end case;
end process;

process(LED_BCD)  --decoder de 7 segmentos
BEGIN
    case LED_BCD is -- señal de decenas de centimo: de 0 a 9 hasta los 90 cents y de 0 a 4 hasta el 1.4$  
    WHEN "0000" => segment <= "0000001";  -- 0
    WHEN "0001" => segment <= "1001111";  -- 1
    WHEN "0010" => segment <= "0010010";  -- 2
    WHEN "0011" => segment <= "0000110";  -- 3
    WHEN "0100" => segment <= "1001100";  -- 4
    WHEN "0101" => segment <= "0100100";  -- 5
    WHEN "0110" => segment <= "0100000";  -- 6
    WHEN "0111" => segment <= "0001111";  -- 7
    WHEN "1000" => segment <= "0000000";  -- 8
    WHEN "1001" => segment <= "0000100";  -- 9
    WHEN "1010" => segment <= "0011000";  -- P
    WHEN "1011" => segment <= "0110000";  -- E
    WHEN "1100" => segment <= "0100100";  -- S
    WHEN "1101" => segment <= "1111110";  -- -
    WHEN "1110" => segment <= "1110001";  -- l
    WHEN "1111" => segment <= "1000010";  -- d
    WHEN others => segment <= "1001001";  -- H sin -
    end case;
end process;

--process(LED_ESTADOS)  --Poniendo este case entran 2 valores a segment dando como resultado X
--BEGIN
--    case LED_ESTADOS is
--    WHEN "1010" => segment <= "0110000";  -- E
--    WHEN "1011" => segment <= "1111010";  -- r
--    WHEN "1100" => segment <= "0100100";  -- S
--    WHEN "1101" => segment <= "1100010";  -- o
--    WHEN "1110" => segment <= "1111001";  -- l
--    WHEN "1111" => segment <= "1000010";  -- d
--    WHEN "0110" => segment <= "1111111";  -- apagado
--    WHEN others => segment <= "1111110";  -- -
--    end case;
--end process;

process(display_activation, enable_anodo) --activador y desactivador de anodos
BEGIN
   anodo <= "11111111";
  if enable_anodo(conv_integer(display_activation)) = '1' then
      anodo(conv_integer(display_activation)) <= '0';
   end if;
end process;  

END ARCHITECTURE dataflow;
