----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    00:13:09 04/04/2016 
-- Design Name: 
-- Module Name:    ALU_Control - Behavioral 
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

entity ALU_Control is
	port( ALUop: in std_logic_vector(1 downto 0);
			Operation: in std_logic_vector(5 downto 0);
			ALU_Selector: out std_logic_vector(3 downto 0));
end ALU_Control;

architecture Behavioral of ALU_Control is
	signal temp: std_logic_vector(3 downto 0);
begin
	process(ALUop, Operation)
	begin
	--================================================================
	--------------------lw or sw--------------------------------------
	--================================================================

		if(ALUop = "00")then 
			temp <= "0010";  				-------------------add

	--================================================================
	--------------------branch equal----------------------------------
	--================================================================

		elsif(ALUop = "01")then
			temp <= "0110";				   -------------------subtract
		elsif(ALUop = "10")then 

	--================================================================
	------------------------R type instructions-----------------------
	--================================================================

			if(Operation = "100000")then
				temp <= "0010"; 			------------------add
			elsif(Operation = "100010")then
				temp <= "0110"; 			------------------subtract
			elsif(Operation = "100100")then
				temp <= "0000";				------------------AND
			elsif(Operation = "100101")then
				temp <= "0001";				------------------OR
			elsif(Operation = "101010")then
				temp <= "0111";				------------------set on less than
			end if;
		end if;
		ALU_Selector<=temp;
	end process;
end Behavioral;

