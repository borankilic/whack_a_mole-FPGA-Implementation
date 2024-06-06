library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
 use IEEE.NUMERIC_STD.ALL;
entity random_gen is
    Port ( clk : in STD_LOGIC;
           reset : in STD_LOGIC;
           seed : in STD_LOGIC_VECTOR (6 downto 0);
           rand_out_loc : out STD_LOGIC_VECTOR (3 downto 0) ;
  rand_out_time : out STD_LOGIC_VECTOR (3 downto 0)
         );
end random_gen;

architecture Behavioral of random_gen is


signal ch_l_v : std_logic_vector( 3 downto 0):= "1100" ;
signal ch_t_v : std_logic_vector( 3 downto 0) :="1100" ;
signal is_initial: STD_LOGIC := '0';
signal rand_clk: integer range -800000000 to 800000000 := 0;

begin

    process (clk, reset)

    begin




if reset = '1' then 
is_initial <= '0';
rand_clk <= 0;
else
		 if rising_edge(clk) then
			 if rand_clk =  300000002 then
			  rand_clk<=0;
			 else
			  rand_clk<= rand_clk +1;
			 end if;
			 end if;
        if rising_edge(clk)  and rand_clk= 300000001 then





						ch_l_v ( 3 downto 1)<= ch_l_v ( 2 downto 0);
						ch_l_v(0)<= ch_l_v(3) xor ch_l_v(2);

						ch_t_v ( 3 downto 1)<= ch_t_v ( 2 downto 0);
						ch_t_v(0)<= ch_t_v(3) xor ch_t_v(2) ;

			end if;


         

   end if;
rand_out_time <= ch_t_v;
rand_out_loc <= ch_l_v;
 




    end process;


end behavioral;


