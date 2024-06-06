library ieee;
use ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

entity vga_driver is
port (
clk_vga : in std_logic;
red_input : in std_logic_vector(2 downto 0);
green_input  : in std_logic_vector(2 downto 0);
blue_input : in std_logic_vector(1 downto 0);

h_sync : out std_logic;
v_sync : out std_logic;
red : out std_logic_vector(2 downto 0);
green : out std_logic_vector(2 downto 0);
blue : out std_logic_vector(1 downto 0);


frame_over : out std_logic;
curr_h : out integer range 0 to 800:=0;
curr_v : out integer range 0 to 640:=0

 
);


end vga_driver;


architecture behavioral of vga_driver is

signal h_p : integer range 0 to 800:=0;   --FP+PW+BP+Visible = 16 + 96 + 48 + 640 = 800
signal v_p : integer range 0 to 640:=0; --FP+PW+BP+Visible = 10 + 2 + 29 + 480 = 640
constant lin_width : integer range 0 to 20:=10;
 
begin


 
vga_process : process(clk_vga)

begin
if rising_edge(clk_vga) then

--Count up pixel position
if (h_p < 800) then

	frame_over <= '0';

	h_p <= h_p + 1;
else
h_p <= 0;  --Resetting


if (v_p < 521) then
v_p <= v_p + 1;
else
v_p <= 0;  --Reset position at end of frame

frame_over <= '1';

end if;
end if;


if ( h_p <704) then
h_sync <= '1';
else
h_sync <= '0';
end if;

if (v_p < 519) then
v_sync <= '1';
else
v_sync <= '0';
end if;
if  (h_p >= 0 and h_p < 48) or ( h_p>=688 and h_p<704) or  (v_p >= 0 and v_p < 29) or (v_p>=509 and v_p<519) then
red <= (others => '0');
green <= (others => '0');
blue <= (others => '0');


-- grid

else

if ((h_p >=123  and h_p < (123+lin_width) and v_p >= 29 and v_p<509) or (h_p >=283  and h_p < (283+lin_width) and v_p >= 29 and v_p<509) or (h_p >=443  and h_p < (443+lin_width) and v_p >= 29 and v_p<509) or (h_p >=603  and h_p < (603+lin_width) and v_p >= 29 and v_p<509)
or (h_p >=123  and h_p <613 and v_p >= 29 and v_p<34) or (h_p >=123  and h_p< 613 and v_p >= 184 and v_p<184+lin_width) or (h_p >=123  and h_p< 613 and v_p >= 344 and v_p<344+lin_width)  or (h_p >=123  and h_p< 613 and v_p >= 504 and v_p<509)) then
red <= (others => '1');
     green <= (others => '1');
     blue <= (others => '1');
--
--
-- if ((h_p >=128  and h_p < 128+lin_width )and ( or (h_p >= 283 and h_p < 273) or (h_p >= 443 and h_p < 453 )or (h_p >= 603 and h_p < 613 ) or
-- (v_p >= 29 and v_p < 39 ) or (v_p >= 184 and v_p < 194) or (v_p >= 344 and v_p < 354 ) or (v_p >= 504 and v_p < 514 ) then
-- red <= (others => '1');
-- green <= (others => '1');
-- blue <= (others => '1');
else
--Within the boarder other modules can write to the screen
red <= red_input;
green <= green_input;
blue <= blue_input;
end if;

end if;

end if;

end process;


curr_h <= h_p;
curr_v <= v_p;
 
end behavioral;

