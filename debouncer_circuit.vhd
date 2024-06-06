
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity CB4CE_HXILINX_freqdivider20 is
 
port (
    CEO  : out STD_LOGIC;
    Q0   : out STD_LOGIC;
    Q1   : out STD_LOGIC;
    Q2   : out STD_LOGIC;
    Q3   : out STD_LOGIC;
    TC   : out STD_LOGIC;
    C    : in STD_LOGIC;
    CE   : in STD_LOGIC;
    CLR  : in STD_LOGIC
    );
end CB4CE_HXILINX_freqdivider20;

architecture Behavioral of CB4CE_HXILINX_freqdivider20 is

  signal COUNT : STD_LOGIC_VECTOR(3 downto 0) := (others => '0');
  constant TERMINAL_COUNT : STD_LOGIC_VECTOR(3 downto 0) := (others => '1');
 
begin

process(C, CLR)
begin
  if (CLR='1') then
    COUNT <= (others => '0');
  elsif (C'event and C = '1') then
    if (CE='1') then
      COUNT <= COUNT+1;
    end if;
  end if;
end process;

TC   <= '1' when (COUNT = TERMINAL_COUNT) else '0';
CEO  <= '1' when ((COUNT = TERMINAL_COUNT) and CE='1') else '0';

Q3 <= COUNT(3);
Q2 <= COUNT(2);
Q1 <= COUNT(1);
Q0 <= COUNT(0);

end Behavioral;

----- CELL CB16CE_HXILINX_freqdivider20 -----


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity CB16CE_HXILINX_freqdivider20 is
port (
    CEO : out STD_LOGIC;
    Q   : out STD_LOGIC_VECTOR(15 downto 0);
    TC  : out STD_LOGIC;
    C   : in STD_LOGIC;
    CE  : in STD_LOGIC;
    CLR : in STD_LOGIC
    );
end CB16CE_HXILINX_freqdivider20;

architecture Behavioral of CB16CE_HXILINX_freqdivider20 is

  signal COUNT : STD_LOGIC_VECTOR(15 downto 0) := (others => '0');
  constant TERMINAL_COUNT : STD_LOGIC_VECTOR(15 downto 0) := (others => '1');
 
begin

process(C, CLR)
begin
  if (CLR='1') then
    COUNT <= (others => '0');
  elsif (C'event and C = '1') then
    if (CE='1') then
      COUNT <= COUNT+1;
    end if;
  end if;
end process;

TC  <= '1' when (COUNT = TERMINAL_COUNT) else '0';
CEO <= '1' when ((COUNT = TERMINAL_COUNT) and CE='1') else '0';
Q   <= COUNT;

end Behavioral;


library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
library UNISIM;
use UNISIM.Vcomponents.ALL;

entity freqdivider20 is
   port ( clk : in    std_logic;
          s   : out   std_logic);
end freqdivider20;

architecture BEHAVIORAL of freqdivider20 is
   attribute HU_SET     : string ;
   signal XLXN_2                : std_logic;
   signal XLXN_5                : std_logic;
   signal XLXI_1_CLR_openSignal : std_logic;
   signal XLXI_2_CLR_openSignal : std_logic;
   component CB16CE_HXILINX_freqdivider20
      port ( C   : in    std_logic;
             CE  : in    std_logic;
             CLR : in    std_logic;
             CEO : out   std_logic;
             Q   : out   std_logic_vector (15 downto 0);
             TC  : out   std_logic);
   end component;
   
   component CB4CE_HXILINX_freqdivider20
      port ( C   : in    std_logic;
             CE  : in    std_logic;
             CLR : in    std_logic;
             CEO : out   std_logic;
             Q0  : out   std_logic;
             Q1  : out   std_logic;
             Q2  : out   std_logic;
             Q3  : out   std_logic;
             TC  : out   std_logic);
   end component;
   
   attribute HU_SET of XLXI_1 : label is "XLXI_1_0";
   attribute HU_SET of XLXI_2 : label is "XLXI_2_1";
begin
   XLXN_5 <= '1';
   XLXI_1 : CB16CE_HXILINX_freqdivider20
      port map (C=>clk,
                CE=>XLXN_5,
                CLR=>XLXI_1_CLR_openSignal,
                CEO=>XLXN_2,
                Q=>open,
                TC=>open);
   
   XLXI_2 : CB4CE_HXILINX_freqdivider20
      port map (C=>clk,
                CE=>XLXN_2,
                CLR=>XLXI_2_CLR_openSignal,
                CEO=>s,
                Q0=>open,
                Q1=>open,
                Q2=>open,
                Q3=>open,
                TC=>open);
   
end BEHAVIORAL;



LIBRARY ieee; USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

entity debounce_button is
port (
D: in std_logic;
CLR : in STD_LOGIC:='0';
CE: in std_logic ;
clk: in std_logic;
O : out std_logic
);
end debounce_button;


architecture structural of debounce_button is
component FDCE
port (Q : out STD_LOGIC;
C : in STD_LOGIC;
CE : in STD_LOGIC;
CLR : in STD_LOGIC;
D :in STD_LOGIC );

end component;  



signal z: std_logic_vector (3 downto 0);

begin

u0: FDCE port map (Q=>z(0),C=>clk,CE=>CE, CLR=>CLR,D=>D);
u1: FDCE port map (Q=>z(1),C=>clk,CE=>CE, CLR=>CLR,D=>z(0));
u2: FDCE port map (Q=>z(2),C=>clk,CE=>CE, CLR=>CLR,D=>z(1));
u3: FDCE port map (Q=>z(3),C=>clk,CE=>CE, CLR=>CLR,D=>z(2));



O<=z(3) and z(2) and z(1) and z(0);

end structural;



library ieee;
use ieee.std_logic_1164.all;


entity EdgeDetector is
   port (
      clk      :in std_logic;
reset:    in std_logic;
      d        :in std_logic;
      edge     :out std_logic
   );
end EdgeDetector;
architecture behavioral of EdgeDetector is
   signal r1 :std_logic;
   signal r2 :std_logic;
begin
reg: process(clk)
begin
if reset='1' then
r1<='0';
r2<='0';
   elsif rising_edge(clk) then
      r1  <= d;
      r2  <= r1;
  end if;
end process;
edge <= (not r1) and (r2);
end behavioral;


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;

entity debouncer_circuit is
port(

buttons : in std_logic_vector ( 4 downto 0 ) ;
CLR : in STD_LOGIC:='0';
clk: in std_logic;
button_out : out std_logic_vector ( 4 downto 0 )
);


end debouncer_circuit;

architecture structural of debouncer_circuit is


component debounce_button is
port (
D: in std_logic;
CLR : in STD_LOGIC:='0';
CE: in std_logic ;
clk: in std_logic;
O : out std_logic
);
end component ;


component freqdivider20 is
   port ( clk : in    std_logic;
          s   : out   std_logic);
end component ;

component EdgeDetector is
   port (
      clk      :in std_logic;
reset:    in std_logic;
      d        :in std_logic;
      edge     :out std_logic
   );
end component ;

signal slowed : std_logic;
signal detectee: std_logic_vector (4 downto 0);



begin

freq_div: freqdivider20 port map ( clk, slowed);
u0:  debounce_button port map (buttons(0),CLR, slowed,clk, detectee(0));
u1:  debounce_button port map (buttons(1),CLR, slowed,clk, detectee(1));
u2:  debounce_button port map (buttons(2),CLR, slowed,clk, detectee(2));
u3:  debounce_button port map (buttons(3),CLR, slowed,clk, detectee(3));
u4:  debounce_button port map (buttons(4),CLR, slowed,clk, detectee(4));

e0 : EdgeDetector port map ( clk, CLR, detectee(0), button_out(0));
e1 : EdgeDetector port map ( clk, CLR, detectee(1), button_out(1));
e2 : EdgeDetector port map ( clk, CLR, detectee(2), button_out(2));
e3 : EdgeDetector port map ( clk, CLR, detectee(3), button_out(3));
e4 : EdgeDetector port map ( clk, CLR, detectee(4), button_out(4));







--u0: debounce_btnl port map ( D=>btnl , CLR=>CLR, clk=>clk, CE=>CE, O=>enable_parallel_load);
--u1: debounce_btnd port map ( D=>btnd , CLR=>CLR, clk=>clk, CE=>CE, O=>enable_down_count);
--u3: debounce_btnu port map ( D=>btnu , CLR=>CLR, clk=>clk, CE=>CE, O=>enable_up_count);


end structural; 


