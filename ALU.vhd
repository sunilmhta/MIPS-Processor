----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    16:34:36 04/05/2016 
-- Design Name: 
-- Module Name:    Instruction_Memory - Behavioral 
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
entity ALU is
  port (
	input1,input2 : in std_logic_vector(31 downto 0);
	Operation	  : in std_logic_vector(3 downto 0);
	ALU_Result    : out std_logic_vector(31 downto 0);
	AND_Input 	  : out std_logic
  ) ;
end entity ; -- ALU

architecture Behavioral of ALU is

	signal temp : std_logic_vector(31 downto 0);
begin
	process(input1,input2,Operation)
	begin
		if Operation="0000" then
			temp <= input1 AND input2;
		elsif Operation="0001" then
			temp <= input1 OR input2;
		elsif Operation="0010" then
			temp <= std_logic_vector(signed(input1)+signed(input2));
		elsif Operation="0110" then
			temp <= std_logic_vector(signed(input1)-signed(input2));
		elsif Operation="0111" then
			if (to_integer(unsigned(input1)) < to_integer(unsigned(input2))) then
				temp <= X"00000001";
			else
				temp <= X"00000000";
			end if ;
		elsif Operation="1100" then
			temp <= input1 NOR input2;
		else
			temp <= X"00000000";
		end if ;

		if temp = X"00000000" then
			AND_Input <= '1';
		else
			AND_Input <= '0';
		end if ;

		ALU_Result <= temp;
	end process;
end architecture ; -- Behavioral