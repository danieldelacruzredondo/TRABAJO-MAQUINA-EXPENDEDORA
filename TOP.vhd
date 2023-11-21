library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity TOP is
    Port ( 
    BTND: IN STD_LOGIC;
    BTNC: IN STD_LOGIC;
    BTNL: IN STD_LOGIC;
    BTNU: IN STD_LOGIC;
    CLK: IN std_logic;
    RESET: IN STD_LOGIC;
    DIGSEL: IN STD_LOGIC_VECTOR (13 to 15);   --Los tres displays de la derecha los
    DIGCTRL: OUT STD_LOGIC_VECTOR( 2 DOWNTO 0);  --activaremos mediante negacion de switches.
    SEGMENT1: OUT std_logic_vector (6 downto 0);
    SEGMENT2: OUT std_logic_vector (6 downto 0);
    SEGMENT3: OUT std_logic_vector (6 downto 0)
        
    );
end TOP;

architecture structural of TOP is

signal signal1: std_logic;
signal signal2: std_logic;
signal signal3: std_logic;
signal signal4: std_logic;
signal signal5: std_logic;
signal signal6: std_logic;
signal signal7: std_logic;
signal signal8: std_logic;
signal signcode: std_logic_vector (3 downto 0);
signal sigled1 : std_logic_vector (6 downto 0);
signal sigled2 : std_logic_vector (6 downto 0);
signal sigled3: std_logic_vector (6 downto 0);

component SYNCHRNZR PORT(
 CLK : in std_logic;
 ASYNC1_IN : in std_logic;
 ASYNC2_IN: in std_logic;
 ASYNC3_IN : in std_logic;
 ASYNC4_IN : in std_logic;
 SYNC_OUT1 : out std_logic;
 SYNC_OUT2 : out std_logic;
 SYNC_OUT3 : out std_logic;
 SYNC_OUT4 : out std_logic
);
end component;

component EDGEDTCTR  PORT(
CLK : in std_logic;
 SYNC_IN1 : in std_logic;
 SYNC_IN2 : in std_logic;
 SYNC_IN3 : in std_logic;
 SYNC_IN4 : in std_logic;
 EDGE1 : out std_logic;
 EDGE2 : out std_logic;
 EDGE3 : out std_logic;
 EDGE4 : out std_logic
);
end component;

component maquina_expendedora  PORT(
    CLK: IN STD_LOGIC;
    RESET: IN STD_LOGIC;
    BTNC_10: IN STD_LOGIC;
    BTNU_20: IN STD_LOGIC;
    BTNL_50: IN std_logic;
    BTND_100: IN STD_LOGIC;
    CODE: OUT STD_LOGIC_VECTOR (3 downto 0)
    --Asignamos un botón por cada moneda que podemos introducir.--
);
end component;

component decoder PORT(
code : IN std_logic_vector(3 DOWNTO 0);
segment1 : OUT std_logic_vector(6 DOWNTO 0);  --display mas a la derecha
segment2 : OUT STD_LOGIC_VECTOR (6 downto 0); --segundo display
segment3: OUT STD_LOGIC_VECTOR (6 DOWNTO 0)   --tercer display
);
end component;

begin

Inst_synchronizer: SYNCHRNZR PORT MAP (
 CLK=>clk,
 ASYNC1_IN => btnc,
 ASYNC2_IN => btnu,
 ASYNC3_IN => btnl,
 ASYNC4_IN => btnd,
 SYNC_OUT1 => signal1,
 SYNC_OUT2 => signal2,
 SYNC_OUT3 => signal3,
 SYNC_OUT4 => signal4
 
);

Inst_edge_detector: EDGEDTCTR PORT MAP (
 CLK => clk,
 SYNC_IN1 => signal1,
 SYNC_IN2 => signal2,
 SYNC_IN3 => signal3,
 SYNC_IN4 => signal4,
 EDGE1 => signal5,
 EDGE2 => signal6,
 EDGE3 => signal7,
 EDGE4 => signal8

);

Inst_maquina_expendedora: MAQUINA_EXPENDEDORA PORT MAP (
    CLK=>clk,
    RESET=>reset,
    BTNC_10=>signal5,
    BTNU_20=>signal6,
    BTNL_50=>signal7,
    BTND_100=>signal8,
    CODE=> signcode
);

Inst_decoder: decoder PORT MAP (
    code =>signcode,
    segment1 => sigled1, --display mas a la derecha
    SEGMENT2 => sigled2, --segundo display
    SEGMENT3 => sigled3  --tercer display
);

segment1<=sigled1;
SEGMENT2<=sigled2;
segment3<=sigled3;

digctrl<= not digsel;



end structural;
