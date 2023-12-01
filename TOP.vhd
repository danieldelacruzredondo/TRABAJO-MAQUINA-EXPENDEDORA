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
    DIGSEL: IN STD_LOGIC_VECTOR (13 to 15);   --Los tres displays de la derecha los
    DIGCTRL: OUT STD_LOGIC_VECTOR( 2 DOWNTO 0);  --activaremos mediante negacion de switches.
    ERROR: OUT STD_LOGIC;
    VENTA: OUT STD_LOGIC;
    LED_PROD: OUT STD_LOGIC_VECTOR (3 downto 0);
    SEGMENT1: OUT std_logic_vector (6 downto 0);
    SEGMENT2: OUT std_logic_vector (6 downto 0);
    SEGMENT3: OUT std_logic_vector (6 downto 0)
        
    );
end TOP;

architecture structural of TOP is

signal moneda: std_logic_vector (3 downto 0);
signal sync_sal : std_logic_vector (3 downto 0);
signal deb_sal : std_logic_vector (3 downto 0);
signal edge_sal : std_logic_vector (3 downto 0);
signal code: std_logic_vector (3 downto 0);


component SYNCHRNZR PORT(
 CLK : in std_logic;
 ASYNC_IN : in std_logic;
 RESET: IN STD_LOGIC;
 SYNC_OUT : out std_logic

);
end component;

component debouncer PORT(
        clk	: in std_logic;
	    btn_in	: in std_logic;
	    btn_out	: out std_logic

);
end component;

component EDGEDTCTR  PORT(
 CLK : in std_logic;
 SYNC_IN : in std_logic;
 RESET: IN STD_LOGIC;
 EDGE : out std_logic

);
end component;

component COUNTER  PORT(
    CLK: IN STD_LOGIC;
    RESET: IN STD_LOGIC;
    ERROR: IN STD_LOGIC;
    VENDER: IN STD_LOGIC;
    BTNC_10: IN STD_LOGIC;
    BTNU_20: IN STD_LOGIC;
    BTNL_50: IN STD_LOGIC;
    BTND_100: IN STD_LOGIC;
    DINERO_TOT: OUT STD_LOGIC_VECTOR (3 DOWNTO 0)

);
end component;

component maquina_expendedora  PORT(
    CLK: IN STD_LOGIC;
    RESET: IN STD_LOGIC;
    CONT: IN STD_LOGIC_VECTOR (3 downto 0);
    SELECC_PROD: IN STD_LOGIC_VECTOR (3 downto 0); 
    VENDER: OUT STD_LOGIC;                      
    ERROR: OUT STD_LOGIC;
    LED: OUT STD_LOGIC_VECTOR (3 DOWNTO 0)
    
);
end component;

--component decoder PORT(
--code : IN std_logic_vector(3 DOWNTO 0);
--segment1 : OUT std_logic_vector(6 DOWNTO 0);  --display mas a la derecha
--segment2 : OUT STD_LOGIC_VECTOR (6 downto 0); --segundo display
--segment3: OUT STD_LOGIC_VECTOR (6 DOWNTO 0)   --tercer display
--);
--end component;

begin

moneda(0)<=BTNC; --Boton asociado a introducir 10 cents
moneda(1)<=BTNU; --Boton asociado a introducir 20 cents
moneda(2)<=BTNL; --Boton asociado a introducir 50 cents
moneda(3)<=BTND; --Boton asociado a introducir 1 EURO

botones: for i in 0 to 3 generate

Inst_synchronizer: SYNCHRNZR PORT MAP (
 CLK =>clk,
 ASYNC_IN =>moneda(i),
 RESET =>RESET,
 SYNC_OUT =>sync_sal(i)

 
);

Inst_debouncer: debouncer PORT MAP (
        clk	=>clk,
	    btn_in=>sync_sal(i),
	    btn_out	=>deb_sal(i)
 
);


Inst_edge_detector: EDGEDTCTR PORT MAP (
    CLK =>clk,
    SYNC_IN =>deb_sal(i),
    RESET=>RESET,
    EDGE =>edge_sal(i)

);

end generate botones;

Inst_counter: counter PORT MAP(
    CLK => CLK,
    RESET => RESET,
    ERROR => error,
    VENDER => venta,
    BTNC_10 => edge_sal(0),
    BTNU_20=> edge_sal(1),
    BTNL_50=>edge_sal(2),
    BTND_100 => edge_sal(3),
    DINERO_TOT => code
);

Inst_maquina_expendedora: MAQUINA_EXPENDEDORA PORT MAP (
    CLK=>clk,
    RESET=>RESET,
    CONT=>code,
    SELECC_PROD => PRODUCTO,
    VENDER=>venta,                     
    ERROR=>error,
    LED=> LED_PROD    
);

--Inst_decoder: decoder PORT MAP (
    --code =>signcode,
    --segment1 => sigled1, --display mas a la derecha
    --SEGMENT2 => sigled2, --segundo display
    --SEGMENT3 => sigled3  --tercer display
--);



digctrl<= not digsel;

end structural;
