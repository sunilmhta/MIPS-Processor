-- Company: 
-- Engineer: 
-- 
-- Create Date:    17:03:36 04/05/2016 
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
entity Register_File is
    port (clk,reset : in std_logic;
		Reg_1,Reg_2,Reg_3 : in std_logic_vector(4 downto 0);
	    data_toWrite : in std_logic_vector(31 downto 0);
	    Reg_3_Flag  : in std_logic;
		data_reg_1,data_reg_2 : out std_logic_vector(31 downto 0)
		) ;
end entity ; -- Register_File

architecture Behavioral of Register_File is

	type StorageRegister is array (0 to 31) of std_logic_vector(31 downto 0);
	signal registers : StorageRegister;
begin
process(clk)
	begin
		if rising_edge(clk) then
			if reset = '0' then
				for i in 0 to 31 loop
					registers(i) <=  X"00000000";
				end loop;
			elsif Reg_3_Flag = '1' then
				registers(to_integer(unsigned(Reg_3))) <= data_toWrite;
		    end if ;
		end if;
	end process ; -- identifier

data_reg_1 <= registers(to_integer(unsigned(Reg_1)));
data_reg_2 <= registers(to_integer(unsigned(Reg_2)));

end architecture ; -- Behavioral