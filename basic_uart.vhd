----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date:    19:29:44 03/03/2014 
-- Design Name: 
-- Module Name:    basic_uart - Behavioral 
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


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.math_real.all;

entity basic_uart is
     generic (
         DIVISOR: natural  
   
     );
     port (
         clk       : in std_logic;                         
         reset     : in std_logic;                         
         rx_data   : out std_logic_vector(7 downto 0);     
         rx_enable : out std_logic;                        
         tx_data   : in std_logic_vector(7 downto 0);      
         tx_enable : in std_logic;                         
         tx_ready  : out std_logic;                        
         rx        : in std_logic;                --receception 
         tx        : out std_logic                --transmission
    );
end basic_uart;

architecture arch of basic_uart is
  constant COUNTER_BITS : natural := 10 ;
  type fsm_state_t is (idle, active); 
  type rx_state_t is
    record
       fsm_state : fsm_state_t;                          
       counter   : std_logic_vector(3 downto 0);         
       bits      : std_logic_vector(7 downto 0);        
       nbits     : std_logic_vector(3 downto 0);        
       enable    : std_logic;                           
     end record;
  type tx_state_t is
     record
       fsm_state : fsm_state_t;                          
       counter   : std_logic_vector(3 downto 0);         
       bits      : std_logic_vector(8 downto 0);         
       nbits     : std_logic_vector(3 downto 0);        
       ready     : std_logic;                           
     end record;
  
  signal rx_state,rx_state_next: rx_state_t;
  signal tx_state,tx_state_next: tx_state_t;
  signal sample: std_logic; 
  signal sample_counter: std_logic_vector(COUNTER_BITS-1 downto 0); 
  
begin

  
  sample_process: process (clk,reset) is
  begin
    if reset = '1' then
      sample_counter <= (others => '0');
      sample <= '0';
    elsif rising_edge(clk) then
      if sample_counter = DIVISOR-1 then
        sample <= '1';
        sample_counter <= (others => '0');
      else
        sample <= '0';
        sample_counter <= sample_counter + 1;
      end if;
    end if;
  end process;

  
  reg_process: process (clk,reset) is
  begin
    if reset = '1' then
      rx_state.fsm_state <= idle;
      rx_state.bits <= (others => '0');
      rx_state.nbits <= (others => '0');
      rx_state.enable <= '0';
      tx_state.fsm_state <= idle;
      tx_state.bits <= (others => '1');
      tx_state.nbits <= (others => '0');
      tx_state.ready <= '1';
    elsif rising_edge(clk) then
      rx_state <= rx_state_next;
      tx_state <= tx_state_next;
    end if;
  end process;
  
  
  rx_process: process (rx_state,sample,rx) is
  begin
    case rx_state.fsm_state is
    
    when idle =>
      rx_state_next.counter <= (others => '0');
      rx_state_next.bits <= (others => '0');
      rx_state_next.nbits <= (others => '0');
      rx_state_next.enable <= '0';
      if rx = '0' then
           
        rx_state_next.fsm_state <= active;
      else
           
        rx_state_next.fsm_state <= idle;
      end if;
      
    when active =>
      rx_state_next <= rx_state;
      if sample = '1' then
        if rx_state.counter = 8 then
         
          if rx_state.nbits = 9 then
            rx_state_next.fsm_state <= idle; 
            rx_state_next.enable <= rx; 
          else
            rx_state_next.bits <= rx & rx_state.bits(7 downto 1);
            rx_state_next.nbits <= rx_state.nbits + 1;
          end if;
        end if;
        rx_state_next.counter <= rx_state.counter + 1;
      end if;
      
    end case;
  end process;
  
  
  rx_output: process (rx_state) is
  begin
    rx_enable <= rx_state.enable;
    rx_data <= rx_state.bits;
  end process;
  
  
  tx_process: process (tx_state,sample,tx_enable,tx_data) is
  begin
    case tx_state.fsm_state is
    
    when idle =>
      if tx_enable = '1' then
        
        tx_state_next.bits <= tx_data & '0';      
        tx_state_next.nbits <= "0000" + 10;       
        tx_state_next.counter <= (others => '0');
        tx_state_next.fsm_state <= active;
        tx_state_next.ready <= '0';
      else
       
        tx_state_next.bits <= (others => '1');
        tx_state_next.nbits <= (others => '0');
        tx_state_next.counter <= (others => '0');
        tx_state_next.fsm_state <= idle;
        tx_state_next.ready <= '1';
      end if;
      
    when active =>
      tx_state_next <= tx_state;
      if sample = '1' then
        if tx_state.counter = 15 then
          
          if tx_state.nbits = 0 then
            
            tx_state_next.bits <= (others => '1');
            tx_state_next.nbits <= (others => '0');
            tx_state_next.counter <= (others => '0');
            tx_state_next.fsm_state <= idle;
            tx_state_next.ready <= '1';
          else
            tx_state_next.bits <= '1' & tx_state.bits(8 downto 1);
            tx_state_next.nbits <= tx_state.nbits - 1;
          end if;
        end if;
        tx_state_next.counter <= tx_state.counter + 1;
      end if;
      
    end case;
  end process;

  
  tx_output: process (tx_state) is
  begin
    tx_ready <= tx_state.ready;
    tx <= tx_state.bits(0);
  end process;

end arch;
