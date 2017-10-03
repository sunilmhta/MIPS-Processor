library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Program_Counter is
  port (clk,reset,Last : in std_logic;
	  	addressALU : in std_logic_vector(31 downto 0);
	  	addressIR : out std_logic_vector(31 downto 0)
	 ) ;
end entity ; -- Program_Counter

architecture Behavioral of Program_Counter is

signal PC : std_logic_vector(31 downto 0);

begin
process(clk)
begin
if rising_edge(clk) then
	if reset = '1' then
		PC <= (others => '0');
	elsif Last ='1' then
		null;
	else
		PC <= addressALU;		
	end if ;
end if ;
end process;
addressIR <= PC;
end Behavioral;

