library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MAQUINA_EXPENDEDORA is
  Port (
    CLK: IN STD_LOGIC;
    RESET: IN STD_LOGIC;
    CONT: IN STD_LOGIC_VECTOR (3 downto 0);
    SELECC_PROD: IN STD_LOGIC_VECTOR (3 downto 0); 
    VENDER: OUT STD_LOGIC;                      
    ERROR: OUT STD_LOGIC;
    LED: OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
                                              
     );
end MAQUINA_EXPENDEDORA;

architecture Behavioral of MAQUINA_EXPENDEDORA is
type STATES is (S0, --Estado de reposo
                S1, -- Producto 1 seleccionado
                S2, -- Producto 2 seleccionado
                S3, -- Producto 3 seleccionado
                S4, -- Producto 4 seleccionado
                S5, -- Contador = 1.4$ venta prod 1           
                S6, -- Contador = 1.4$ venta prod 2
                S7, -- Contador = 1.4$ venta prod 3
                S8, -- Contador = 1.4$ venta prod 4
                S9);
 signal current_state: STATES := S0;
 signal next_state: STATES;
begin
    
	state_reg:process(CLK) 
    begin
    	if rising_edge(CLK) then
        	if RESET = '0' then
            	current_state<= S0;
            else 
            	current_state <= next_state; --Igual para cada maquina de estados--
   			end if;
   		end if;
   end process;
   
    nxtst_decoder: process (current_state, SELECC_PROD, CONT)
    begin 
    	next_state<= current_state;
    	case current_state is
        
        	when S0=>
            	if SELECC_PROD = "0001" then
                	next_state<=S1; 
                elsif SELECC_PROD = "0010" then
                    next_state<=S2; 
                elsif SELECC_PROD = "0100" then
                    next_state<=S3; 
                elsif SELECC_PROD = "1000" then
                    next_state<=S4;
                --elsif SELECC_PROD = others then     Si se activan dos o mas switches a la vez
                   -- next_state<=S0;           
                end if;
            
            when S1=> 
                if CONT = "1110" then
                    next_state<=S5;
                end if;   
             when S2=> 
                if CONT<= "1110" then
                    next_state<=S6;  
                end if;
                   
              when S3=> 
                if CONT<= "1110" then
                    next_state<=S7;        
                end if;
                    
               when S4=> 
                if CONT<= "1110" then
                    next_state<=S8;
                end if;
                                                                          
            when others=>
            	next_state<=S0;
            
        end case;
    
    end process;
    
    output_decoder:process(current_state)
    begin        
    	case current_state is
        
        	when S0=>
            	LED<= "0000";
            	vender<='0';
            	error<='0';
                               
            when S1=>
          		LED<="0001";
          		vender<='0';
            	error<='0';
                
            when S2=>
            	LED<="0010";
            	vender<='0';
            	error<='0';
            
            when S3=>
            	LED<="0100";
            	vender<='0';
            	error<='0';
            	
            when S4=>
            	LED<="1000";
            	vender<='0';
            	error<='0';
            when S5=>
          		LED<="0001";
          		vender<='1';
            	error<='0';
                
            when S6=>
            	LED<="0010";
            	vender<='1';
            	error<='0';
            
            when S7=>
            	LED<="0100";
            	vender<='1';
            	error<='0';
            	
            when S8=>
            	LED<="1000";
            	vender<='1';
            	error<='0';
            	
            	
            when others=>
            	LED<= "0000";
            	error<='1';
            	vender<='0';            	           
        end case;
    end process;
    
end Behavioral;
