----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:35:22 04/06/2016 
-- Design Name: 
-- Module Name:    Mux - Behavioral 
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
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Mux is
	generic(Size: integer:= 32);
	port(input1,input2:in std_logic_vector(Size - 1 downto 0);
			selector:in std_logic;
			outLine:out std_logic_vector(Size - 1 downto 0));
end Mux;

architecture Behavioral of Mux is
	signal temp: std_logic_vector(Size - 1 downto 0);
begin
	process(input1,input2,selector)
	begin
		if(selector = '0')then
			temp <= input1;
		else
			temp <= input2;
		end if;	
		outLine<=temp;
	end process;
end Behavioral;
