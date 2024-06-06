library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package drawing_package is
    procedure MoleDraw(
        signal hp : in integer;
        signal vp : in  integer;

        signal red : out STD_LOGIC_VECTOR ( 2 downto 0);
 signal green : out STD_LOGIC_VECTOR( 2 downto 0);
 constant mole_x: in integer;
 constant mole_y: in integer
 

 
    );
end drawing_package;

package body drawing_package is
   procedure MoleDraw(
        signal hp : in integer;
        signal vp : in  integer;
signal red : out STD_LOGIC_VECTOR ( 2 downto 0);
 signal green : out STD_LOGIC_VECTOR( 2 downto 0);
 constant  mole_x: in integer;
 constant mole_y: in integer

 
 
    ) is
    begin
       if (hp >= mole_x-40 and hp <= mole_x+40) and (vp >= mole_y-40 and vp <= mole_y+40) then

if  (( hp > mole_x-30 and hp< mole_x-10) or ( hp < mole_x+30 and hp> mole_x+10))and (vp<mole_y-10 and vp>mole_y-30) then
red<="000";
green<="000";

elsif ( hp > mole_x-30 and hp< mole_x+30)and (vp>mole_y+10 and vp<mole_y+30) then
  red<="111";
green<="000";

else

red <= "111";
green <= "100";
end if;
else

red <= "000";
green <= "000";
end if;

    end MoleDraw;
end drawing_package;

