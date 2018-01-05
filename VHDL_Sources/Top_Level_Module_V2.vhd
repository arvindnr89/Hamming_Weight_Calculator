----------------------------------------------------------------------------------
-- Create Date: 01/01/2018 07:05:00 AM
-- Design Name: 
-- Module Name: Top_Level_Module_V2 - Structural
-- Project Name: HW_calculator
-- Target Devices: xc7k160tfbg484-3
-- Tool Versions: Vivado 2016.2
-- Description: This is the top level module of the design that instantiates two 
-- modules : HW_Calculator_V2 and Position_Output_Module. 
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

entity Top_Level_Module_V2 is
	Port(RESET_IN           : in  STD_LOGIC;
	     CLK_IN             : in  STD_LOGIC;
	     DATA_IN            : in  STD_LOGIC_VECTOR(DATA_WIDTH - 1 downto 0);
	     START_PACKET_IN    : in  STD_LOGIC;
	     HAMMING_WEIGHT_OUT : out STD_LOGIC_VECTOR(HW_WEIGHT_WIDTH - 1 downto 0);
	     POSITION_VALID_OUT : out STD_LOGIC;
	     POSITION_OUT       : out STD_LOGIC_VECTOR(POS_WIDTH - 1 downto 0)
	    );
end entity Top_Level_Module_V2;

architecture Structural of Top_Level_Module_V2 is

	signal hw_weight  : std_logic_vector(HW_WEIGHT_WIDTH - 1 downto 0);
	signal pos_vector : std_logic_vector(POS_VECTOR_WIDTH - 1 downto 0);
	
begin
	
	hw_calc : entity work.HW_Calculator_V2
		port map(
			InitReset       => RESET_IN,
			CLK_IN          => CLK_IN,
			START_PACKET_IN => START_PACKET_IN,
			DATA_IN         => DATA_IN,
			HW_WEIGHT_OUT   => hw_weight,
			POS_OUT         => pos_vector
		);

	op : entity work.Position_Output_Module
		port map(
			InitReset       => RESET_IN,
			CLK_IN          => CLK_IN,
			START_PACKET_IN => START_PACKET_IN,
			POS_VECTOR_IN   => pos_vector,
			HW_WEIGHT_IN    => hw_weight,
			VALID_POS_OUT   => POSITION_VALID_OUT,
			POS_OUT         => POSITION_OUT,
			HW_WEIGHT_OUT   => HAMMING_WEIGHT_OUT
		);

end architecture Structural;
