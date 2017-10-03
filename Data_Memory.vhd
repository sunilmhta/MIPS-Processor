----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    18:40:22 04/05/2016 
-- Design Name: 
-- Module Name:    Data_Memory - Behavioral 
-- Project Name: 
-- Target Devices: 
-- Tool versions: 
-- Description: 
--
-- Dependencies: 
--
-- Revision: 
-- Revision 0.01 - File Created
-- Additional Comments: 
--
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Data_Memory is
	generic(Size: integer:= 50);
	port( clk,reset: in std_logic;
			dataAddress,datatoWrite: in std_logic_vector(31 downto 0);
			readData: out std_logic_vector(31 downto 0);
			writeFlag,readFlag: in std_logic
		);
end Data_Memory;

architecture Behavioral of Data_Memory is
	type arrayData is array(0 to Size-1) of std_logic_vector(31 downto 0);
	signal data:arrayData;
begin
	process(clk)
	begin
	if rising_edge(clk) then
		if(reset = '1') then              -- Add the data here
			for i in 0 to Size - 1 loop
				data(i)<= (others=> '0');
			end loop;

			data(0)  <= "00000000000000000000000000000101";
			data(1)  <= "00000000000000000000000000000010";
			data(2)  <= "00000000000000000000000000000000";
			data(3)  <= "00000000000000000000000000000000";
			data(4)  <= "00000000000000000000000000000000";
			data(5)  <= "00000000000000000000000000000011";
			data(6)  <= X"11111111";
			
		else
			if( writeFlag = '1') then
				data(to_integer(unsigned(dataAddress))) <= datatoWrite;
			elsif( readFlag = '1') then
				readData <= std_logic_vector(data(to_integer(unsigned(dataAddress)))); ----------------------------data(i)
			end if;
		end if;
	end if ;
	end process;
end Behavioral;

