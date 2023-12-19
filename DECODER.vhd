LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.std_logic_arith.ALL;
USE ieee.std_logic_unsigned.ALL;

ENTITY decoder IS
PORT (

CLK: IN STD_LOGIC;
RESET: IN STD_LOGIC;
CODE : IN std_logic_vector(3 DOWNTO 0);
anodo : OUT std_logic_vector(2 DOWNTO 0);
segment : OUT STD_LOGIC_VECTOR (6 downto 0);
dt : OUT std_logic
);
END ENTITY decoder;


ARCHITECTURE dataflow OF decoder IS
signal display_activation : std_logic_vector(1 DOWNTO 0); --para activar el display
signal refresh_count : std_logic_vector(19 DOWNTO 0);
signal LED_BCD : std_logic_vector(3 DOWNTO 0);
signal displayed_numbers : std_logic_vector(11 DOWNTO 0); --para meter los 4 bits a cada display
BEGIN

process(LED_BCD)
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

process(clk, reset)
BEGIN
    if (reset='1') then
       refresh_count <= (others => '0');
    else if (rising_edge(clk)) then
       refresh_count <= refresh_count + 1;
    end if;
    end if;
end process;
display_activation <= refresh_count (19 DOWNTO 18);
LED_BCD <= code;

process(display_activation)
BEGIN
   case display_activation is
   when "00" =>
      anodo <= "011";
      dt<='1';
      LED_BCD <= displayed_numbers(11 DOWNTO 8);
   when "01" =>
      anodo <= "101";
      LED_BCD <= displayed_numbers(7 DOWNTO 4);
   when "10" =>
      anodo <= "110";
      LED_BCD <= displayed_numbers(3 DOWNTO 0);
   when "11" =>
      anodo<="111";
   end case;
end process;
END ARCHITECTURE dataflow;
