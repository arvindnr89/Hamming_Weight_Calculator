----------------------------------------------------------------------------------
-- Create Date: 01/01/2018 07:30:00 AM
-- Design Name: 
-- Module Name: Position_Output_Module - Structural
-- Project Name: HW_calculator
-- Target Devices: xc7k160tfbg484-3
-- Tool Versions: Vivado 2016.2
-- Description: This module outputs the hamming weight and the positions of the 1’s 
-- in the data. The output positions are valid as long as the VALID_POSITION_OUT 
-- signal is asserted. 

-- 
-- Dependencies: None
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all;

entity Position_Output_Module is
	port(
		InitReset       : in  std_logic;
		CLK_IN          : in  std_logic;
		START_PACKET_IN : in  std_logic;
		POS_VECTOR_IN   : in  std_logic_vector(POS_VECTOR_WIDTH - 1 downto 0);
		HW_WEIGHT_IN    : in  std_logic_vector(HW_WEIGHT_WIDTH - 1 downto 0);
		VALID_POS_OUT   : out std_logic;
		POS_OUT         : out std_logic_vector(POS_WIDTH - 1 downto 0);
		HW_WEIGHT_OUT   : out std_logic_vector(HW_WEIGHT_WIDTH - 1 downto 0)
	);
end entity Position_Output_Module;

architecture RTL of Position_Output_Module is
	
	signal valid      : std_logic;
	signal hw_weight  : integer range 0 to 31;
	signal currentpos : integer range 0 to 31;
	signal totalpos   : integer range 0 to 31;
	signal pos        : unsigned(POS_WIDTH - 1 downto 0);
	signal pos_vector : unsigned(POS_VECTOR_WIDTH - 1 downto 0);
	signal hw_latched : std_logic_vector(HW_WEIGHT_WIDTH - 1 downto 0);
	
begin

	process(CLK_IN) is
		variable totalcount   : natural := 0;
	begin
		if rising_edge(CLK_IN) then
			if InitReset = '1' then
				pos_vector <= (others => '0');
				hw_weight  <= 0;
				pos        <= (others => '0');
				valid      <= '0';
				hw_latched <= (others => '0');
			elsif START_PACKET_IN = '1' then
				totalpos   <= TO_INTEGER(UNSIGNED(HW_WEIGHT_IN));
				currentpos <= 0;
				totalcount := TO_INTEGER(UNSIGNED(HW_WEIGHT_IN));
				--Get rid of all the leading 0's by shifting the pos vector to the left
				pos_vector <= shift_left(UNSIGNED(POS_VECTOR_IN), (POS_VECTOR_WIDTH - 1 - ((totalcount*POS_WIDTH) - 1)));
				hw_latched <= HW_WEIGHT_IN;
				if(totalcount > 0) then
					valid      <= '1';
				end if;
			else
				if (currentpos < totalpos - 1) then
					currentpos <= currentpos + 1;
					pos_vector <= shift_left(pos_vector, POS_WIDTH);
				else
					valid <= '0';
				end if;
			end if;
		end if;
	end process;

	HW_WEIGHT_OUT <= hw_latched;
	VALID_POS_OUT <= valid;
	POS_OUT       <= STD_LOGIC_VECTOR(pos_vector(POS_VECTOR_WIDTH - 1 downto POS_VECTOR_WIDTH - POS_WIDTH));

end architecture RTL;
