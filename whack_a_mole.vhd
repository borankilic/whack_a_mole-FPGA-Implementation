library ieee; use ieee.std_logic_1164.all;
USE ieee.std_logic_arith.all;
use ieee.numeric_std.all;
use ieee.std_logic_unsigned.all;

use work.drawing_package.all;

entity whack_a_mole is
port (
clk : in std_logic;
h_sync, v_sync : out std_logic;
VGA_R  : out std_logic_vector(2 downto 0);
VGA_G  : out std_logic_vector(2 downto 0);
VGA_B  : out std_logic_vector(1 downto 0);
switches: in std_logic_vector(6 downto 0);
SSEG_CA : out std_logic_vector(7 downto 0);
SSEG_AN : out std_logic_vector(3 downto 0);
buttons : in std_logic_vector(4 downto 0);
reset: in std_logic

);
end  whack_a_mole;



architecture game of whack_a_mole is


component frequency_divider is
Port (
my_clk : in std_logic;
reset : in std_logic;
enable : in std_logic;
s : out std_logic
);
end component;


component seven_complete is
Port (
clk: in std_logic ;
digit0: in std_logic_vector( 3 downto 0) ;
digit1: in std_logic_vector ( 3 downto 0);
SSEG_CA : out STD_LOGIC_VECTOR (7 downto 0);
SSEG_AN : out STD_LOGIC_VECTOR (3 downto 0)
);

end component;


component debouncer_circuit is
port(

buttons : in std_logic_vector ( 4 downto 0 ) ;
CLR : in STD_LOGIC:='0';
clk: in std_logic;
button_out : out std_logic_vector ( 4 downto 0 )
);


end component;

--  


component vga_driver is
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
curr_v : out integer range 0 to 640:=0);


end component;

component random_gen is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           seed : in STD_LOGIC_VECTOR (6 downto 0);
           rand_out_loc : out std_logic_vector( 3 downto 0) ;
  rand_out_time : out std_logic_vector( 3 downto 0)
         );
end component ;








-- procedure is here




constant max_score: integer := 10;
constant diff : integer range 1 to 3 :=1;
signal clk_vga : std_logic:='0';

signal frame_over : std_logic:='0';
signal spawn_clock : std_logic:='1';
signal set_red, set_green : std_logic_vector(2 downto 0):= (others => '0');
signal set_blue : std_logic_vector(1 downto 0):= (others => '0');
signal hp : integer range 0 to 2256:=0;
signal vp : integer range 0 to 1087:=0;
signal frame_count: integer:=0 ;

signal random_loc_v : std_logic_vector( 3 downto 0);
signal random_time_v : std_logic_vector( 3 downto 0);
signal random_loc_v_t : std_logic_vector( 3 downto 0);
signal random_time_v_t : std_logic_vector( 3 downto 0);
 -- mole location signals
signal random_loc_x : integer;
signal random_loc_y : integer;
signal random_time: integer;

--buttons
-- 0 to 4 : up down right left middle
signal button_c : std_logic_vector (4 downto 0);

-- score
signal score_0 : std_logic_vector (3 downto 0) := "0000";
signal score_1 : std_logic_vector (3 downto 0) := "0000";

-- game over signal


signal game_over : std_logic:='0';


--mole signals
signal mole_i    : integer range 0 to 4:= 0;
signal mole_j     : integer range 0 to 4:= 0;


signal cursor_i  : integer range 0 to 3:= 0;
signal cursor_j : integer range 0 to 3:= 0;
signal player_score  : integer range 0 to 15:= 0;

begin


freq_div: frequency_divider port map ( clk, reset ,'1', clk_vga);

-- seven segment display portmap
sev_seg : seven_complete port map( clk, score_0, score_1, SSEG_CA, SSEG_AN);


vga_comp : vga_driver port map (
clk_vga => clk_vga,
h_sync => h_sync,
v_sync => v_sync,
red => VGA_R,
green => VGA_G,
blue => VGA_B,
frame_over => frame_over,
curr_h => hp,
curr_v => vp,
red_input => set_red,
green_input  => set_green,
blue_input => set_blue);

rand_gen: random_gen port map(
clk=> clk,
reset=>reset,
seed=> switches,
rand_out_loc=>random_loc_v_t,
rand_out_time=>random_time_v_t);


button_circuit: debouncer_circuit port map (
buttons => buttons,
CLR=>reset,
clk =>clk_vga,
button_out => button_c
);

random_loc_v <= random_loc_v_t + switches (6 downto 3) + ('0'&switches(2 downto 0)); 
random_time_v <= random_loc_v_t + switches (6 downto 3) + ('0'&switches(2 downto 0)); 

with random_loc_v select
    random_loc_x <= 0 when "0000",
                   1 when "0001",
                   2 when "0010",
                   0 when "0011",
                   1 when "0100",
                   2 when "0101",
                   0 when "0110",
                   1 when "0111",
                   2 when "1000",
                   0 when "1001",
                   2 when "1010",
                   1 when "1011",
                   0 when "1100",
                   2 when "1101",
                   1 when "1110",
                   2 when "1111",
                   3 when others;




with random_loc_v select
    random_loc_y <= 0 when "0000",
                   0 when "0001",
                   0 when "0010",
                   1 when "0011",
                   1 when "0100",
                   1 when "0101",
                   2 when "0110",
                   2 when "0111",
                   2 when "1000",
                   0 when "1001",
                   2 when "1010",
                   1 when "1011",
                   0 when "1100",
                   2 when "1101",
                   1 when "1110",
                   2 when "1111",
                   3 when others;




with random_time_v select

random_time <= 60/diff when "0000",
 90/diff when "0001",
 120/diff when "0010",
 150/diff when "0011",
 180/diff when "0100",
 210/diff when "0101",
 240/diff when "0110",
 270/diff when "0111",
 300/diff when "1000",
 330/diff when "1001",
 170/diff when "1010",
 240/diff when "1011",
 130/diff when "1100",
 150/diff when "1101",
 300/diff when "1110",
 120/diff when "1111",
 0 when others;
 




draw_mole : process (clk_vga)
begin

if rising_edge(clk_vga) then

if mole_i = 0 and mole_j = 0 then


MoleDraw ( hp,vp,set_red,set_green,208,109);

elsif mole_i = 0 and mole_j=1 then

MoleDraw ( hp,vp,set_red,set_green, 368,109);

elsif mole_i = 0 and mole_j=2 then

MoleDraw ( hp,vp,set_red,set_green, 528,109);


elsif mole_i = 1 and mole_j=0 then


MoleDraw ( hp,vp,set_red,set_green, 208,269);

elsif mole_i = 1 and mole_j=1 then
MoleDraw ( hp,vp,set_red,set_green, 368,269);

elsif mole_i = 1 and mole_j=2 then

MoleDraw ( hp,vp,set_red,set_green, 528,269);

         
elsif mole_i = 2 and mole_j=0 then


MoleDraw ( hp,vp,set_red,set_green, 208,429);

elsif mole_i = 2 and mole_j=1 then

MoleDraw ( hp,vp,set_red,set_green, 368,429);

elsif mole_i = 2 and mole_j=2 then

MoleDraw ( hp,vp,set_red,set_green, 528,429);


else
set_red <= "000";
set_green <= "000";
end if;
end if ;


if rising_edge(clk_vga) then
--- sliding cursor animation maybe

if cursor_i = 0 and cursor_j=0 then
if ((hp >= 203 and hp <= 213) and (vp >= 69 and vp <= 149)) or ((hp >= 168 and hp <= 248) and (vp >= 104 and vp <= 114)) then
set_blue <= "11";
else
set_blue <="00";
end if;
elsif cursor_i = 0 and cursor_j=1 then
if ((hp >=363  and hp <= 373) and (vp >= 69 and vp <= 149)) or ((hp >= 328 and hp <= 408) and (vp >= 104 and vp <= 114)) then
set_blue <= "11";
else
set_blue <="00";
end if;
elsif cursor_i = 0 and cursor_j=2 then
if ((hp >= 523 and hp <= 533) and (vp >= 69 and vp <= 149)) or ((hp >= 488 and hp <= 568) and (vp >= 104 and vp <= 114)) then
set_blue <= "11";
else
set_blue <="00";
end if;
elsif cursor_i = 1 and cursor_j=0 then
if ((hp >= 203 and hp <= 213) and (vp >= 229 and vp <= 309)) or ((hp >= 168 and hp <= 248) and (vp >= 264 and vp <= 274)) then
set_blue <= "11";
else
set_blue <="00";
end if;
elsif cursor_i = 1 and cursor_j=1 then
if ((hp >=363  and hp <= 373) and (vp >= 229 and vp <= 309)) or ((hp >= 328 and hp <= 408) and (vp >= 264 and vp <= 274)) then
set_blue <= "11";
else
set_blue <="00";
end if;
elsif cursor_i = 1 and cursor_j=2 then
if ((hp >= 523 and hp <= 533) and (vp >= 229 and vp <= 309)) or ((hp >= 488 and hp <= 568) and (vp >= 264 and vp <= 274)) then
set_blue <= "11";
else
set_blue <="00";
end if;
elsif cursor_i = 2 and cursor_j=0 then
if ((hp >= 203 and hp <= 213) and (vp >= 389 and vp <= 469)) or ((hp >= 168 and hp <= 248) and (vp >= 424 and vp <= 434)) then
set_blue <= "11";
else
set_blue <="00";
end if;
elsif cursor_i = 2 and cursor_j=1 then
if ((hp >=363  and hp <= 373) and (vp >= 389 and vp <= 469)) or ((hp >= 328 and hp <= 408) and (vp >= 424 and vp <= 434)) then
set_blue <= "11";
else
set_blue <="00";
end if;
elsif cursor_i = 2 and cursor_j=2 then
if ((hp >= 523 and hp <= 533) and (vp >= 389 and vp <= 469)) or ((hp >= 488 and hp <= 568) and (vp >= 424 and vp <= 434)) then
set_blue <= "11";
else
set_blue <="00";
end if;




else
set_blue <= "00";

end if;
end if;



end process;

--draw_cursor : process (clk_vga)
--begin
--
--if rising_edge(clk_vga) then
----- sliding cursor animation maybe
--
--if cursor_i = 0 and cursor_j=0 then
--if ((hp >= 203 and hp <= 213) and (vp >= 69 and vp <= 149)) or ((hp >= 168 and hp <= 248) and (vp >= 104 and vp <= 114)) then
--set_blue <= "11";
--else
--set_blue <="00";
--end if;
--elsif cursor_i = 0 and cursor_j=1 then
--if ((hp >=363  and hp <= 373) and (vp >= 69 and vp <= 149)) or ((hp >= 328 and hp <= 408) and (vp >= 104 and vp <= 114)) then
--set_blue <= "11";
--else
--set_blue <="00";
--end if;
--elsif cursor_i = 0 and cursor_j=2 then
--if ((hp >= 523 and hp <= 533) and (vp >= 69 and vp <= 149)) or ((hp >= 488 and hp <= 568) and (vp >= 104 and vp <= 114)) then
--set_blue <= "11";
--else
--set_blue <="00";
--end if;
--elsif cursor_i = 1 and cursor_j=0 then
--if ((hp >= 203 and hp <= 213) and (vp >= 229 and vp <= 309)) or ((hp >= 168 and hp <= 248) and (vp >= 264 and vp <= 274)) then
--set_blue <= "11";
--else
--set_blue <="00";
--end if;
--elsif cursor_i = 1 and cursor_j=1 then
--if ((hp >=363  and hp <= 373) and (vp >= 229 and vp <= 309)) or ((hp >= 328 and hp <= 408) and (vp >= 264 and vp <= 274)) then
--set_blue <= "11";
--else
--set_blue <="00";
--end if;
--elsif cursor_i = 1 and cursor_j=2 then
--if ((hp >= 523 and hp <= 533) and (vp >= 229 and vp <= 309)) or ((hp >= 488 and hp <= 568) and (vp >= 264 and vp <= 274)) then
--set_blue <= "11";
--else
--set_blue <="00";
--end if;
--elsif cursor_i = 2 and cursor_j=0 then
--if ((hp >= 203 and hp <= 213) and (vp >= 389 and vp <= 469)) or ((hp >= 168 and hp <= 248) and (vp >= 424 and vp <= 434)) then
--set_blue <= "11";
--else
--set_blue <="00";
--end if;
--elsif cursor_i = 2 and cursor_j=1 then
--if ((hp >=363  and hp <= 373) and (vp >= 389 and vp <= 469)) or ((hp >= 328 and hp <= 408) and (vp >= 424 and vp <= 434)) then
--set_blue <= "11";
--else
--set_blue <="00";
--end if;
--elsif cursor_i = 2 and cursor_j=2 then
--if ((hp >= 523 and hp <= 533) and (vp >= 389 and vp <= 469)) or ((hp >= 488 and hp <= 568) and (vp >= 424 and vp <= 434)) then
--set_blue <= "11";
--else
--set_blue <="00";
--end if;
--
--
--
--
--else
--set_blue <= "00";
--
--end if;
--end if;
--end process;





game_engine : process(clk_vga,reset)
variable random_time_t: integer;
begin

if reset ='1' then
cursor_i<=1;
cursor_j<=1;
score_0 <= "0000";
score_1 <= "0000";
game_over<='0';
mole_i<=3;
mole_j<=3;
frame_count<=0;

elsif rising_edge(clk_vga) then
	if game_over='0' then
	
		if frame_over ='1' then  
			frame_count<= frame_count+1;		
		elsif frame_count <= 179  then
			spawn_clock <= '1';
		elsif frame_count <= 359 and frame_count >= 179 then
			spawn_clock <= '0';
			if frame_count = 359 then 
				frame_count <= 0;
				end if;
		end if;
		
	  if spawn_clock'event and spawn_clock  = '1'  then
		mole_i<= random_loc_x ;
		mole_j <= random_loc_y;


		random_time_t := random_time;
	  end if;
	  
	  	if frame_count >= random_time_t then
			mole_i<= 3;
		   mole_j <=3;
			end if;
	end if;	
			

 






--buttons
-- 0 to 4 : up down right left middle
	if button_c(0) ='1' then
	  if cursor_i /= 0 then
		cursor_i <= cursor_i - 1;
		else
		cursor_i <= cursor_i;
      end if;
	elsif button_c(1)='1' then
		if cursor_i /= 2 then
			cursor_i <= cursor_i + 1;
	else
cursor_i <= cursor_i;
end if;

elsif button_c(2)='1' then
if cursor_j /= 2 then
cursor_j <= cursor_j + 1;
else
cursor_j <= cursor_j;
end if;

elsif button_c(3)='1' then
if cursor_j /= 0 then
cursor_j <= cursor_j - 1;
else
cursor_j <= cursor_j;
end if;



elsif (cursor_j = mole_j) and ( cursor_i= mole_i) and  (button_c(4)='1') then
mole_i<=3;
mole_j<=3;
if score_0 /= "1001"  then
score_0 <= score_0 +"0001";
else
score_1<= score_1 +"0001";
score_0 <= "0000";
game_over<='1';
end if;

end if;
end if;

end process;


end game;