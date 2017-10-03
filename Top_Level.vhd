----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    21:49:31 04/06/2016 
-- Design Name: 
-- Module Name:    Top_Level - Behavioral 
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
use work.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Top_Level is
	port( reset,clk: in std_logic;
		 end_signal: out std_logic
		);
end Top_Level;

architecture Behavioral of Top_Level is

	component ALU
			port (input1,input2 : in std_logic_vector(31 downto 0);
				Operation	  : in std_logic_vector(3 downto 0);
				ALU_Result    : out std_logic_vector(31 downto 0);
				AND_Input 	  : out std_logic
		    ) ;
	end component;	
	
	component ALU_Control
			port( ALUop: in std_logic_vector(1 downto 0);
				Operation: in std_logic_vector(5 downto 0);
				ALU_Selector: out std_logic_vector(3 downto 0)
			);
	end component;
	
	component Control_Unit
			port (
				clk,reset : in std_logic;
				Instruction : in std_logic_vector(31 downto 0);
				RegDest,Branch,MemRead,MemtoReg:out std_logic;
				MemWrite,ALUsrc,RegWrite,Last:out std_logic;
				ALUop : out std_logic_vector(1 downto 0)
		    );
	end component;

	component Data_Memory
		generic(Size: integer:= 50);
			port( clk,reset: in std_logic;
				dataAddress,datatoWrite: in std_logic_vector(31 downto 0);
				readData: out std_logic_vector(31 downto 0);
				writeFlag,readFlag: in std_logic
			);
	end component;
	
	component Instruction_Memory
		generic(size: integer:= 50);
			port( clk,reset: in std_logic;					
				Address: in std_logic_vector(31 downto 0);
				CurrentInstruction: out std_logic_vector(31 downto 0)
			);
	end component;
	
	component Mux
		generic(Size: integer:= 32);
			port(input1,input2:in std_logic_vector(Size - 1 downto 0);
				selector:in std_logic;
				outLine:out std_logic_vector(Size - 1 downto 0)
			);
	end component;
	
	component Program_Counter
			port (clk,reset,Last : in std_logic;
			  	addressALU : in std_logic_vector(31 downto 0);
			  	addressIR : out std_logic_vector(31 downto 0)
			) ;
	end component;
		
	component Register_File
			port (clk,reset : in std_logic;
				Reg_1,Reg_2,Reg_3 : in std_logic_vector(4 downto 0);
			    data_toWrite : in std_logic_vector(31 downto 0);
			    Reg_3_Flag  : in std_logic;
				data_reg_1,data_reg_2 : out std_logic_vector(31 downto 0)
			) ;
	end component;
	
	component Shift_Left2
			port( inData: in std_logic_vector(31 downto 0);
				outData: out std_logic_vector(31 downto 0)
			);
	end component;
	
	component Sign_Extend
			port(data16:in std_logic_vector(15 downto 0);
				data32:out std_logic_vector(31 downto 0)
			);
	end component;
	
	
	signal PCtoIR,PCfromALU: std_logic_vector(31 downto 0);
	signal PCplus4: std_logic_vector(31 downto 0);
	signal Instruction: std_logic_vector(31 downto 0);
	signal instOpcode: std_logic_vector(5 downto 0);
	signal addReg1: std_logic_vector(4 downto 0);
	signal addReg2: std_logic_vector(4 downto 0);
	signal addReg3: std_logic_vector(4 downto 0);
	signal instFunc: std_logic_vector(5 downto 0);
	signal instOffset: std_logic_vector(15 downto 0);
	signal Write_reg: std_logic_vector(4 downto 0);
	signal Read_data_1: std_logic_vector(31 downto 0);
	signal Read_data_2: std_logic_vector(31 downto 0);
	signal WriteDataReg: std_logic_vector(31 downto 0);
	signal PC_offset: std_logic_vector(31 downto 0);
	signal PC_offset_shifted: std_logic_vector(31 downto 0);
	signal PC_plus_offset: std_logic_vector(31 downto 0);
	signal Z_and_Branch: std_logic;
	signal Zero: std_logic;
	signal ALU_S: std_logic_vector(3 downto 0);
	signal ALU_b: std_logic_vector(31 downto 0);
	signal ALU_result: std_logic_vector(31 downto 0);
	signal ReadDataMem: std_logic_vector(31 downto 0);
	signal ALUop: std_logic_vector(1 downto 0);
	signal RegDst: std_logic;
	signal RegWrite: std_logic;
	signal Branch: std_logic;
	signal ALUSrc: std_logic;
	signal MemRead: std_logic;
	signal MemWrite: std_logic;
	signal MemtoReg: std_logic;
	signal final: std_logic;
	signal start: std_logic;
	
begin
	end_signal<=final;

	PC: Program_Counter port map(Last=>final, reset=> reset, clk=> clk, addressALU => PCfromALU, addressIR=> PCtoIR);
	IM: Instruction_Memory generic map(size=> 40) port map(reset=> reset, clk=> clk, Address=> PCtoIR, CurrentInstruction=> Instruction);

	ADD_1: ALU port map(input1=> PCtoIR, input2=> X"00000001", Operation=> "0010", ALU_Result=> PCplus4);

	instOpcode<=Instruction(31 downto 26); --Opcode of the Instruction
	addReg1<=Instruction(25 downto 21); -- Reg 1 address
	addReg2<=Instruction(20 downto 16); -- Reg 2 address
	addReg3<=Instruction(15 downto 11); -- Reg 3 address
	instOffset<=Instruction(15 downto 0); -- Offset
	instFunc<=Instruction(5 downto 0); -- Function in case of R instructions

	MUX_1: Mux generic map(Size=> 5) port map(input1=>addReg2, input2=> addReg3,selector=> RegDst,outLine=> Write_reg);

	REGS: Register_File port map(clk=> clk, reset=> reset, 
									Reg_1=> addReg1, Reg_2=> addReg2, Reg_3=> Write_reg, 
									data_toWrite=> WriteDataReg, Reg_3_Flag=> RegWrite, 
									data_reg_1=>Read_data_1, data_reg_2=>Read_data_2
								) ;  

	SE: Sign_Extend port map(data16=> instOffset, data32=> PC_offset);
	SL2: Shift_Left2 port map(inData=> PC_offset, outData=> PC_offset_shifted);

	Z_and_Branch<= Zero and Branch; -- AND gate

	ADD_2: ALU port map(input1=> PCplus4, input2=> PC_offset_shifted, Operation=> "0010", ALU_Result => PC_plus_offset);
	MUX_2: Mux generic map(Size=> 32) port map(input1=>PCplus4, input2=> PC_plus_offset,selector=> Z_and_Branch,outLine=> PCfromALU);
	ALU_CO: ALU_Control port map(ALUop=> ALUop, Operation=> instFunc, ALU_Selector=> ALU_S);
	MUX_3: Mux generic map(Size=> 32) port map(input1=> Read_data_2, input2=> PC_offset, selector=> ALUSrc,outLine=> ALU_b);
	ALU_1: ALU port map(input1=> Read_data_1, input2=> ALU_b, Operation=> ALU_S, ALU_Result=> ALU_result,AND_Input=> Zero);
	
	DM: Data_Memory generic map(Size=> 20) port map(clk=> clk, reset=> reset, dataAddress=> ALU_result, 
													datatoWrite=> Read_data_2,
													ReadData=> ReadDataMem, writeFlag=> MemWrite, readFlag=> MemRead
												) ;

	MUX_4: Mux generic map(Size=> 32) port map(input1=> ALU_result, input2=> ReadDataMem, selector=> MemtoReg,outLine=> WriteDataReg);

	CU: Control_Unit port map(clk=> clk,reset=> reset,
								Instruction => Instruction, RegDest=> RegDst, Branch=> Branch, 
								MemRead=> MemRead, MemtoReg=> MemtoReg, MemWrite=> MemWrite,
								ALUsrc=> ALUSrc, RegWrite=> RegWrite, Last=> final, ALUop=> ALUop
							) ;
end Behavioral;