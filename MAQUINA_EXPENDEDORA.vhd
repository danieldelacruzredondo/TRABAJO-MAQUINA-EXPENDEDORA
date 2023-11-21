library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MAQUINA_EXPENDEDORA is
  Port (
    CLK: IN STD_LOGIC;
    RESET: IN STD_LOGIC;
    BTNC_10: IN STD_LOGIC;
    BTNU_20: IN STD_LOGIC;
    BTNL_50: IN std_logic;
    BTND_100: IN STD_LOGIC;
    CODE: OUT STD_LOGIC_VECTOR (3 downto 0)
    --Asignamos un botón por cada moneda que podemos introducir.--
     );
end MAQUINA_EXPENDEDORA;

architecture Behavioral of MAQUINA_EXPENDEDORA is
type STATE_T is (S0_0c, S1_10c, S2_20c, S3_30c, S4_40c, S5_50c, s6_60c, s7_70c, S8_80C, S9_90c, S10_100c);
--Cada estado va de 10 centimos en 10 centimos, ya que es la moneda más pequeña que se puede meter--
signal state, nxt_state : STATE_T;
signal signalcode: std_logic_vector(3 downto 0);

begin
--variable contador: real :='0'
state_reg:process(CLK) 
    begin
    	if rising_edge(CLK) then
        	if RESET = '0' then
            	state<= S0_0c;
            else 
            	state<= nxt_state; --Igual para cada maquina de estados--
   			end if;
   		end if;
   end process;
   
nxtst_decoder: process (state, BTNC_10, BTNU_20, BTNL_50, BTND_100)
    begin 
    	nxt_state<= state;
    	case state is
    	
    	   when S0_0c =>
                if BTNC_10='1' then
                    nxt_state<= S1_10c;
                elsif BTNU_20='1' then
                    nxt_state<= S2_20c;
                elsif BTNL_50='1' then
                    nxt_state<=S5_50c;
                elsif BTND_100='1' then
                    nxt_state<=S10_100c;
                end if;
                
            when S1_10c =>
                if BTNC_10='1' then
                    nxt_state<= S2_20c;
                elsif BTNU_20='1' then
                    nxt_state<= S3_30c;
                elsif BTNL_50='1' then
                    nxt_state<=s6_60c;
                elsif BTND_100='1' then
                    nxt_state<=S0_0c; --Como nos hemos pasado del euro que podemos introducir, volvemos al estado inicial.
                end if;
            
             when S2_20c =>
                if BTNC_10='1' then
                    nxt_state<= S3_30c;
                elsif BTNU_20='1' then
                    nxt_state<= S4_40c;
                elsif BTNL_50='1' then
                    nxt_state<=s7_70c;
                elsif BTND_100='1' then
                    nxt_state<=S0_0c; --Como nos hemos pasado del euro que podemos introducir, volvemos al estado inicial.
                end if;
                
             when S3_30c =>
                if BTNC_10='1' then
                    nxt_state<= S4_40c;
                elsif BTNU_20='1' then
                    nxt_state<= S5_50c;
                elsif BTNL_50='1' then
                    nxt_state<=s8_80c;
                elsif BTND_100='1' then
                    nxt_state<=S0_0c; --Como nos hemos pasado del euro que podemos introducir, volvemos al estado inicial.
                end if;
             
              when S4_40c =>
                if BTNC_10='1' then
                    nxt_state<= S5_50c;
                elsif BTNU_20='1' then
                    nxt_state<= S6_60c;
                elsif BTNL_50='1' then
                    nxt_state<=s9_90c;
                elsif BTND_100='1' then
                    nxt_state<=S0_0c; --Como nos hemos pasado del euro que podemos introducir, volvemos al estado inicial.
                end if;
                
              when S5_50c =>
                if BTNC_10='1' then
                    nxt_state<= S6_60c;
                elsif BTNU_20='1' then
                    nxt_state<= S7_70c;
                elsif BTNL_50='1' then
                    nxt_state<=s9_90c;
                elsif BTND_100='1' then
                    nxt_state<=S0_0c; --Como nos hemos pasado del euro que podemos introducir, volvemos al estado inicial.
                end if;
                
              when S6_60c =>
                if BTNC_10='1' then
                    nxt_state<= S7_70c;
                elsif BTNU_20='1' then
                    nxt_state<= S8_80c;
                elsif BTNL_50='1' then
                    nxt_state<=s0_0c;
                elsif BTND_100='1' then
                    nxt_state<=S0_0c; --Como nos hemos pasado del euro que podemos introducir, volvemos al estado inicial.
                end if;
                
              when S7_70c =>
                if BTNC_10='1' then
                    nxt_state<= S8_80c;
                elsif BTNU_20='1' then
                    nxt_state<= S9_90c;
                elsif BTNL_50='1' then
                    nxt_state<=s0_0c;
                elsif BTND_100='1' then
                    nxt_state<=S0_0c; --Como nos hemos pasado del euro que podemos introducir, volvemos al estado inicial.
                end if;
                
              when S8_80c =>
                if BTNC_10='1' then
                    nxt_state<= S9_90c;
                elsif BTNU_20='1' then
                    nxt_state<= S10_100c;
                elsif BTNL_50='1' then
                    nxt_state<=s0_0c;
                elsif BTND_100='1' then
                    nxt_state<=S0_0c; --Como nos hemos pasado del euro que podemos introducir, volvemos al estado inicial.
                end if;
                
               when S9_90c =>
                if BTNC_10='1' then
                    nxt_state<= S10_100c;
                elsif BTNU_20='1' then
                    nxt_state<= S0_0c;
                elsif BTNL_50='1' then
                    nxt_state<=s0_0c;
                elsif BTND_100='1' then
                    nxt_state<=S0_0c; --Como nos hemos pasado del euro que podemos introducir, volvemos al estado inicial.
                end if;
                
               when S10_100c =>
                if BTNC_10='1' then
                    nxt_state<= S0_0c;
                elsif BTNU_20='1' then
                    nxt_state<= S0_0c;
                elsif BTNL_50='1' then
                    nxt_state<=s0_0c;
                elsif BTND_100='1' then
                    nxt_state<=S0_0c; --Como nos hemos pasado del euro que podemos introducir, volvemos al estado inicial.
                end if;                
            end case;   
  end process;  
      
  output_decoder:process(state)
  
   begin 
   case state is
        
        	when S0_0c =>
            	signalcode<= "0000" ;
                               
            when S1_10c =>
          		signalcode<= "0001";
                
            when S2_20c =>
                signalcode<="0010";
                
            when S3_30c =>
            	signalcode<= "0011";
                               
            when S4_40c =>
          		signalcode<= "0100";
                
            when S5_50c =>
                signalcode<="0101";
            
            when S6_60c =>
            	signalcode<= "0110";
                               
            when S7_70c =>
          		signalcode<= "0111";
                
            when S8_80c =>
                signalcode<="1000";
                
            when S9_90c =>
            	signalcode<= "1001" ;
                               
            when S10_100c =>
          		signalcode<= "1010";
                
            when others =>
                signalcode<= "0000";
            	           
        end case;
end process;
code<=signalcode;
end Behavioral;
