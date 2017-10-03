----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:46:36 04/06/2016 
-- Design Name: 
-- Module Name:    Sign_Extend - Behavioral 
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

entity Sign_Extend is
	port(data16:in std_logic_vector(15 downto 0);
		data32:out std_logic_vector(31 downto 0)
	);
end Sign_Extend;

architecture Behavioral of Sign_Extend is
	signal temp: std_logic_vector(31 downto 0);
 begin
	process(data16)
	begin
		if(data16(15) = '0')then
			temp <= "0000000000000000"&data16;
		else
			temp <= "1111111111111111"&data16;
		end if;
		data32 <= temp;
	end process;
end Behavioral;

