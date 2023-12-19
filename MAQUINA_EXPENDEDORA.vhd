library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MAQUINA_EXPENDEDORA is
  Port (
    CLK: IN STD_LOGIC;
    RESET: IN STD_LOGIC;
    BOTON: IN STD_LOGIC_VECTOR (3 downto 0); --Dinero que vamos introduciendo.
    CUENTA: IN STD_LOGIC; -- La pondremos a '1' cuando se retorne 1,40$ desde el counter.
    SELECC_PROD: IN STD_LOGIC_VECTOR (3 downto 0); 
    --VENDER: IN STD_LOGIC;                      
    LED_ERROR: OUT STD_LOGIC;
    LED_VENTA: OUT STD_LOGIC;
    LED_PROD: OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
                                              
     );
end MAQUINA_EXPENDEDORA;

architecture Behavioral of MAQUINA_EXPENDEDORA is
type STATES is (S0, --Estado de reposo/error. led error encendido
                S1, -- Metemos dinero. llega una pulsación de boton
                S2, -- Seleccionamos un producto
                S3  -- Seleccionado el producto e importe de 1.40$. LED VENTA.
               );
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
   
    nxtst_decoder: process (current_state, SELECC_PROD, BOTON)
    begin 
    	next_state<= current_state;
    	case current_state is
        
        	when S0=>
        	--Seleccionamos uno de los 4 productos ->
            	if SELECC_PROD = "0001" then
                	next_state<=S2; 
                elsif SELECC_PROD = "0010" then
                    next_state<=S2; 
                elsif SELECC_PROD = "0100" then
                    next_state<=S2; 
                elsif SELECC_PROD = "1000" then
                    next_state<=S2;
            --Pulsamos uno de los 4 botones para meter dinero ->
                elsif BOTON = "0001" then   
                    next_state<=S1;
                elsif BOTON = "0010" then   
                    next_state<=S1;  
                elsif BOTON = "0100" then   
                    next_state<=S1;  
                elsif BOTON = "1000" then   
                    next_state<=S1;
                end if;
            
            when S1=> 
             -- Si el importe esta bien, pasamos al estado de venta
                if CUENTA = '1' then
                
                    next_state<=S3;
                -- Seguimos metiendo dinero, seguimos en el mismo estado
                elsif BOTON = "0001" then   
                    next_state<=S1;
                elsif BOTON = "0010" then   
                    next_state<=S1;  
                elsif BOTON = "0100" then   
                    next_state<=S1;  
                elsif BOTON = "1000" then   
                    next_state<=S1;
                -- Habiendo metido dinero, seleccionamos producto
                elsif SELECC_PROD = "0001" then
                	next_state<=S2; 
                elsif SELECC_PROD = "0010" then
                    next_state<=S2; 
                elsif SELECC_PROD = "0100" then
                    next_state<=S2; 
                elsif SELECC_PROD = "1000" then
                    next_state<=S2;
                end if;
                
                  
             when S2 => 
             -- Si hay un producto selleccionado, y el importe esta bien, hacemos la venta
                if CUENTA = '1' then
                    if SELECC_PROD = "0001" then
                        next_state<=S3;
                    elsif SELECC_PROD = "0010" then
                       next_state<=S3;
                    elsif SELECC_PROD = "0100" then
                        next_state<=S3;
                    elsif SELECC_PROD = "1000" then                        
                    next_state<=S3;
                    end if;
                end if;  
             -- Metemos dinero habiendo seleccionado un producto previamente
                if BOTON = "0001" then   
                    next_state<=S1;
                elsif BOTON = "0010" then   
                    next_state<=S1;  
                elsif BOTON = "0100" then   
                    next_state<=S1;  
                elsif BOTON = "1000" then   
                    next_state<=S1;
                
               -- Cambiamos de producto
                elsif SELECC_PROD = "0001" then
                	next_state<=S2; 
                elsif SELECC_PROD = "0010" then
                    next_state<=S2; 
                elsif SELECC_PROD = "0100" then
                    next_state<=S2; 
                elsif SELECC_PROD = "1000" then
                    next_state<=S2;
                end if;
                                                  
              when S3=> 
              -- Se realiza la venta y pasamos al estado inicial
                --if VENDER = '1' then
                    --next_state<=S0;
                if SELECC_PROD = "0000" then -- Si no hay producto selecc -> volvemos a reposo
                	next_state<=S0;
               --Si estamos listos para venta y se mete mas dinero volvemos al estado inicial
                elsif BOTON = "0001" then   
                    next_state<=S0;
                elsif BOTON = "0010" then   
                    next_state<=S0;  
                elsif BOTON = "0100" then   
                    next_state<=S0;  
                elsif BOTON = "1000" then   
                    next_state<=S0;                	                        
                end if;                                                                                                         
            
            when others=>
            	next_state<=S0;
            
        end case;
    
    end process;
    
    output_decoder:process(current_state)
    begin        
    	case current_state is
        
        	when S0=>
            	LED_PROD <= "0000";
            	LED_ERROR <= '1';
            	LED_VENTA <='0';
                               
            when S1=>  
              
                if SELECC_PROD = "0001" then
                	LED_PROD <= "0001"; 
                elsif SELECC_PROD = "0010" then
                    LED_PROD <= "0010";  
                elsif SELECC_PROD = "0100" then
                    LED_PROD <= "0100"; 
                elsif SELECC_PROD = "1000" then
                    LED_PROD <= "1000"; 
                end if;         
          		         		
            	LED_VENTA <='0';
            	LED_ERROR <='1';
                
            when S2=>
            	if SELECC_PROD = "0001" then
                	LED_PROD <= "0001"; 
                elsif SELECC_PROD = "0010" then
                    LED_PROD <= "0010";  
                elsif SELECC_PROD = "0100" then
                    LED_PROD <= "0100"; 
                elsif SELECC_PROD = "1000" then
                    LED_PROD <= "1000"; 
                    end if;
            	LED_ERROR <='1';
            	LED_VENTA <='0';
            
            when S3=>
                    if SELECC_PROD = "0001" then
                        LED_PROD <= "0001"; 
                    elsif SELECC_PROD = "0010" then
                        LED_PROD <= "0010";  
                    elsif SELECC_PROD = "0100" then
                        LED_PROD <= "0100"; 
                    elsif SELECC_PROD = "1000" then
                        LED_PROD <= "1000"; 
                        end if;
            	
            	LED_VENTA<='1';
            	LED_ERROR<='0';
            	                                 	
            when others=>
            	LED_PROD <= "0000";
            	LED_ERROR <='1';
            	LED_VENTA <='0';
            	           	           
        end case;
    end process;
    
end Behavioral;
