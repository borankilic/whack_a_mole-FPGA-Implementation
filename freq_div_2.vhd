library ieee;
use ieee.std_logic_1164.ALL;
use ieee.numeric_std.ALL;
library UNISIM;
use UNISIM.Vcomponents.ALL;
USE ieee.std_logic_arith.all;
USE ieee.std_logic_unsigned.all;


entity frequency_divider is
Port (
my_clk : in std_logic;
reset : in std_logic;
enable : in std_logic;
s : out std_logic
);
end frequency_divider;


architecture behavioral of frequency_divider is
signal count : integer range 0 to 3 := 0;

begin

process(my_clk,reset)
begin
if reset ='1' then
count<=0;
elsif rising_edge(my_clk) then
if enable ='1' then
if count = 3 then
count <=0;
else
count<= count+1;
end if;
end if;
else
count<=count;
end if;

end process;

s <='0' when count <3 else '1';

end behavioral;
