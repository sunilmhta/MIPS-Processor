----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:40:11 04/06/2016 
-- Design Name: 
-- Module Name:    Shift_Left2 - Behavioral 
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

entity Shift_Left2 is
	port( inData: in std_logic_vector(31 downto 0);
			outData: out std_logic_vector(31 downto 0));
end Shift_Left2;

architecture Behavioral of Shift_Left2 is
begin
	outData<=inData(29 downto 0)&"00";
end Behavioral;

