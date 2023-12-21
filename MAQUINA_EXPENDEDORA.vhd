library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity MAQUINA_EXPENDEDORA is
  Port (
    CLK: IN STD_LOGIC;
    RESET: IN STD_LOGIC;
    BOTON: IN STD_LOGIC_VECTOR (3 downto 0); --Dinero que vamos introduciendo.
    CUENTA: IN STD_LOGIC:='0'; -- La pondremos a '1' cuando se retorne 1,40$ desde el counter.
    SELECC_PROD: IN STD_LOGIC_VECTOR (3 downto 0); -- Seleccionar un producto
    REC_PROD : IN STD_LOGIC;                     
    LED_ERROR: OUT STD_LOGIC;
    LED_VENTA: OUT STD_LOGIC;
    LED_PROD: OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
    ESTADO0: OUT STD_LOGIC;
    ESTADO1: OUT STD_LOGIC;
    ESTADO2: OUT STD_LOGIC
    
                                              
     );
end MAQUINA_EXPENDEDORA;

architecture Behavioral of MAQUINA_EXPENDEDORA is
type STATES is (S0, --Estado de reposo/error. led error encendido
                S1, -- Seleccionamos un producto
                S2, -- Metemos dinero. llega una pulsación de boton
                S3  -- Seleccionado el producto e importe de 1.40$.SW para recoger producto. LED VENTA.
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
                	next_state<=S1; 
                elsif SELECC_PROD = "0010" then
                    next_state<=S1; 
                elsif SELECC_PROD = "0100" then
                    next_state<=S1; 
                elsif SELECC_PROD = "1000" then
                    next_state<=S1;
                    end if;                            
            
            when S1=> -- Estando con un producto seleccionado, introducimos dinero
                if SELECC_PROD = "0000" then
                    next_state<=S0;   
                end if;       
                if BOTON = "0001" then   
                    next_state<=S2;
                elsif BOTON = "0010" then   
                    next_state<=S2;  
                elsif BOTON = "0100" then   
                    next_state<=S2;  
                elsif BOTON = "1000" then   
                    next_state<=S2;
                end if;                
                                                 
             when S2 => 
             
                if CUENTA = '1' then
                -- Si  seguimos metiendo dinero estando todo bien, volvemos a reposo
                    if BOTON = "0001" then   
                        next_state<=S0;
                    elsif BOTON = "0010" then   
                        next_state<=S0;  
                    elsif BOTON = "0100" then   
                        next_state<=S0;  
                    elsif BOTON = "1000" then   
                        next_state<=S0;
                end if;                      
                end if; 
                
             if CUENTA='1' then            
                next_state<=S3;
             end if;
                               
                    
             -- No hemos llegado al 1,40
             if CUENTA='0' then
                if BOTON = "0001" then   
                    next_state<=S2;
                elsif BOTON = "0010" then   
                    next_state<=S2;  
                elsif BOTON = "0100" then   
                    next_state<=S2;  
                elsif BOTON = "1000" then   
                    next_state<=S2;                               
                end if;
                end if;
                                                  
              when S3=> 
                   if REC_PROD = '1' THEN 
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
            	ESTADO0<='1'; -- Estado reposo
            	ESTADO1<='0'; -- Estado producto seleccionado
            	ESTADO2<='0'; -- Estado meter dinero
                               
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
            	ESTADO0<='0';
            	ESTADO1<='1';
            	ESTADO2<='0';
                
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
            	ESTADO0<='0';
            	ESTADO1<='0';
            	ESTADO2<='1';
            
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
            	ESTADO0<='0';
            	ESTADO1<='0';
            	ESTADO2<='0';
            	                                 	
            when others=>
            	LED_PROD <= "0000";
            	LED_ERROR <='1';
            	LED_VENTA <='0';
            	ESTADO0<='0';
            	ESTADO1<='0';
            	ESTADO2<='0';
            	
            	           	           
        end case;
    end process;   
end Behavioral;
