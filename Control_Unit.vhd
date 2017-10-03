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

entity Control_Unit is
  port (
	clk,reset : in std_logic;
	Instruction : in std_logic_vector(31 downto 0);
	RegDest,Branch,MemRead,MemtoReg:out std_logic;
	MemWrite,ALUsrc,RegWrite,Last:out std_logic;
	ALUop : out std_logic_vector(1 downto 0)
  );
end entity ; -- Control_Unit

architecture Behavioral of Control_Unit is

	signal OpCode : std_logic_vector(5 downto 0);
begin
	OpCode <= Instruction(31 downto 26);
	process(clk , OpCode)
	begin
	if rising_edge(clk) then
		if reset = '1' then
			RegDest <= '0';
			Branch <= '0';
			MemRead <='0';
			MemtoReg <= '0';
			MemWrite <= '0';
			ALUsrc <= '0';
			RegWrite <='0';
			ALUop <= "00";
			Last <= '0';

		elsif OpCode = "000000" then ----------------------------R type Instructions
			RegDest <= '1';
			Branch <= '0';
			MemRead <= '0';
			MemtoReg <= '0';
			MemWrite <= '0';
			ALUsrc <= '0';
			RegWrite <='1'; 
			ALUop <= "10";
			Last <= '0';

		elsif OpCode = "100011" then ----------------------------lw instruction
			RegDest <= '0';
			Branch <= '0';
			MemRead <='1';   -------since it is load instruction
			MemtoReg <= '1';
			MemWrite <= '0'; -------reading and writing are not done simultaneously
			ALUsrc <= '1';   
			RegWrite <='1';
			ALUop <= "00";
			Last <= '0';

		elsif OpCode = "101011" then ----------------------------sw instruction
			RegDest <= '0';
			Branch <= '0';
			MemRead <='0';  --------writing and reading are not done simultaneously
			MemtoReg <= '0';
			MemWrite <= '1';--------since it is store instruction
			ALUsrc <= '1';
			RegWrite <='0';
			ALUop <= "00";
			Last <= '0';

		elsif OpCode = "000100" then-----------------------beq instruction [(o $s, $t, label)=>if ($s == $t) pc += i << 2]
			RegDest <= '0';
			Branch <= '1';
			MemRead <='0';
			MemtoReg <= '0';
			MemWrite <= '0';
			ALUsrc <= '0';
			RegWrite <='0';
			ALUop <= "00";
			Last <= '0';

		else ----------------------------------------------------Send an end signal
			RegDest <= '0';
			Branch <= '0';
			MemRead <='0';
			MemtoReg <= '0';
			MemWrite <= '1';
			ALUsrc <= '1';
			RegWrite <='0';
			ALUop <= "00";
			Last <= '1';
		end if ;
	end if ;
	end process ;
end architecture ; -- Behavioral

