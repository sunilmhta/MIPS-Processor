----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:13:36 04/04/2016 
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

entity Instruction_Memory is
	generic(size: integer:= 50);
	port( clk,reset: in std_logic;					
			Address: in std_logic_vector(31 downto 0);
			CurrentInstruction: out std_logic_vector(31 downto 0));
end Instruction_Memory;

architecture Behavioral of Instruction_Memory is
	type Instructions is array(0 to size-1) of std_logic_vector(31 downto 0);
	signal Instruction:Instructions;
begin
	process(clk)
	begin
		if rising_edge(clk) then
			if reset = '1' then
				for i in 0 to size - 1 loop
					Instruction(i)<= X"11111111";
				end loop;
			
----------------------------------More Instructions Here-----------------------------------------------------

			Instruction(0)   <= "10001100000000100000000000010100";
			Instruction(1)   <= "10001100000000110000000000010101";
			Instruction(2)   <= "10001100001001000000000000010110";
			Instruction(3)   <= "00000000100001010010100000100000";
			Instruction(4)	 <= "00000000001000100000100000100000";
			Instruction(5)   <= "00010000001000110000000000000001";
			Instruction(6)   <= "00100000000000000000000000000010";
			
--------------------------------------------------------------------------------------------------------------
---------------------Following Instruction is going out of the IR to Control Unit-----------------------------
--------------------------------------------------------------------------------------------------------------
			else
				CurrentInstruction<= Instruction(to_integer(unsigned(Address))); 
			end if ;
		end if ;
	end process;
end Behavioral;

