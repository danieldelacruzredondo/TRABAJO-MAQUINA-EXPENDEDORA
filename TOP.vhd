library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TOP is
    Port ( 
    BTNC: IN STD_LOGIC;
    BTNU: IN STD_LOGIC;
    BTNL: IN STD_LOGIC;
    BTND: IN STD_LOGIC;    
    CLK: IN std_logic;
    RESET: IN STD_LOGIC;
    PRODUCTO: IN STD_LOGIC_VECTOR (3 downto 0);
    REC_PROD: IN STD_LOGIC;
    DIGSEL: out STD_LOGIC_VECTOR (7 downto 0);  
    ERROR: OUT STD_LOGIC;
    ESTADO0: OUT STD_LOGIC;
    ESTADO1: OUT STD_LOGIC;
    ESTADO2: OUT STD_LOGIC;
    VENTA: OUT STD_LOGIC;
    LED_PROD: OUT STD_LOGIC_VECTOR (15 downto 12);
    SEGMENT: OUT std_logic_vector (6 downto 0);
    DP: OUT STD_LOGIC
    
        
    );
end TOP;

architecture structural of TOP is

signal moneda: std_logic_vector (3 downto 0);

signal edge_salida : std_logic_vector (3 downto 0);
signal code: std_logic_vector (3 downto 0);
signal sigerr: std_logic;
signal sigven: std_logic;
signal importe_exacto: std_logic; -- Señal que relaciona el counter con la fsm

component GEST_INT PORT(
    BTNC: IN STD_LOGIC;
    BTNU: IN STD_LOGIC;
    BTNL: IN STD_LOGIC;
    BTND: IN STD_LOGIC;    
    CLK: IN std_logic;
    RESET: IN std_logic;
    EDGE_SAL: OUT STD_LOGIC_VECTOR(3 downto 0)
);
END COMPONENT;


component COUNTER  PORT(
    CLK: IN STD_LOGIC;
    RESET: IN STD_LOGIC;    
    BOTON: IN STD_LOGIC_VECTOR (3 DOWNTO 0);   
    DINERO_TOT: OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
    IMP_EXACTO: OUT STD_LOGIC
);
end component;

component maquina_expendedora  PORT(
    CLK: IN STD_LOGIC;
    RESET: IN STD_LOGIC;
    BOTON: IN STD_LOGIC_VECTOR (3 downto 0); --Dinero que vamos introduciendo.
    CUENTA: IN STD_LOGIC; -- La pondremos a '1' cuando se retorne 1,40$ desde el counter.
    SELECC_PROD: IN STD_LOGIC_VECTOR (3 downto 0);  
    REC_PROD: IN STD_LOGIC;                       
    LED_ERROR: OUT STD_LOGIC;
    LED_VENTA: OUT STD_LOGIC;
    LED_PROD: OUT STD_LOGIC_VECTOR (3 DOWNTO 0);
    ESTADO0: OUT STD_LOGIC;
    ESTADO1: OUT STD_LOGIC;
    ESTADO2: OUT STD_LOGIC
    
);
end component;

component decoder PORT(
CLK: IN STD_LOGIC;
RESET: IN STD_LOGIC;
code : IN std_logic_vector(3 DOWNTO 0);
anodo : OUT std_logic_vector(7 DOWNTO 0);
segment : OUT STD_LOGIC_VECTOR (6 downto 0);
DP: OUT STD_LOGIC


);
end component;

begin

Inst_GEST_INT: GEST_INT PORT MAP(
    BTNC=>BTNC,
    BTNU=>BTNU,
    BTNL=>BTNL,
    BTND=>BTND,   
    CLK=>clk,
    RESET=>reset,
    EDGE_SAL(0)=>edge_salida(0),
    EDGE_SAL(1)=>edge_salida(1),
    EDGE_SAL(2)=>edge_salida(2),
    EDGE_SAL(3)=>edge_salida(3)
);

Inst_counter: counter PORT MAP(
    CLK=>CLK,
    RESET=>RESET,  
     
    BOTON(0)=>edge_salida(0),
    BOTON(1)=>edge_salida(1),
    BOTON(2)=>edge_salida(2),
    BOTON(3)=>edge_salida(3),
    DINERO_TOT=>code, -- Señal que sale del counter para relacionarlo con el decoder
    IMP_EXACTO=>importe_exacto   
);

Inst_maquina_expendedora: MAQUINA_EXPENDEDORA PORT MAP (
    CLK=>CLK,
    RESET=>RESET,
    BOTON(0)=>edge_salida(0),
    BOTON(1)=>edge_salida(1),
    BOTON(2)=>edge_salida(2),
    BOTON(3)=>edge_salida(3),
    CUENTA=>importe_exacto,
    SELECC_PROD=>PRODUCTO,  
    REC_PROD=>REC_PROD,                      
    LED_ERROR => ERROR,
    LED_VENTA => VENTA,
    LED_PROD => LED_PROD,
    ESTADO0=> ESTADO0,
    ESTADO1=>ESTADO1,
    ESTADO2=>ESTADO2
       
);

Inst_decoder: decoder PORT MAP (
    CLK=>clk,
    RESET=>reset,
    CODE => code,
    anodo =>DIGSEL,
    segment =>SEGMENT,
    DP=>DP
   
);
    

end structural;
