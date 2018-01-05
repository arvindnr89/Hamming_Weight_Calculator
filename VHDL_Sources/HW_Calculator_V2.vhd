----------------------------------------------------------------------------------
-- Create Date: 01/01/2018 07:10:00 AM
-- Design Name: 
-- Module Name: HW_Calculator_V2 - RTL
-- Project Name: HW_calculator
-- Target Devices: xc7k160tfbg484-3
-- Tool Versions: Vivado 2016.2
-- Description: This module takes in the input data and outputs the hamming weight and a 
-- position vector. The width of the position vector is MAX_POSITIONS (which is 31 
-- since that is the max hamming weight) * POS_WIDTH (which is 10 bits wide to 
-- represent data from  0-1023). Hence the vector  is 310 bits wide. When a ‘1’ is 
-- detected the position is calculated and written to the lowest  10 bits of the position 
-- vector. The entire vector is then left shifted by 10 bits to make palace for the next 
-- position information. This way the position vector can hold a total of 31 position 
-- values (which corresponds to the max hamming weight per packet)
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

entity HW_Calculator_V2 is
	port(
		InitReset       : in  std_logic;
		CLK_IN          : in  std_logic;
		START_PACKET_IN : in  std_logic;
		DATA_IN         : in  std_logic_vector(DATA_WIDTH - 1 downto 0);
		HW_WEIGHT_OUT   : out std_logic_vector(HW_WEIGHT_WIDTH - 1 downto 0);
		POS_OUT         : out std_logic_vector(POS_VECTOR_WIDTH - 1 downto 0)
	);
end entity HW_Calculator_V2;

architecture RTL of HW_Calculator_V2 is
	signal byte : integer range 0 to 128;
begin
	hw_proc : process(CLK_IN) is
		variable count      : natural range 0 to 31                   := 0;
		variable pos        : unsigned(POS_WIDTH - 1 downto 0)        := (others => '0');
		variable pos_vector : unsigned(POS_VECTOR_WIDTH - 1 downto 0) := (others => '0');
	begin
		if rising_edge(CLK_IN) then
			if (InitReset = '1') OR (START_PACKET_IN = '1') then
				count      := 0;
				byte       <= 0;
				pos        := (others => '0');
				pos_vector := (others => '0');
			else
				for i in DATA_IN'range loop
					if DATA_IN(DATA_WIDTH - 1 - i) = '1' then
						count      := count + 1;
						pos        := (byte * 8) + to_unsigned(DATA_WIDTH - 1 - i, POS_WIDTH);
						pos_vector := shift_left(pos_vector, POS_WIDTH) + pos;
					end if;
				end loop;
				byte <= byte + 1;
			end if;
			POS_OUT       <= STD_LOGIC_VECTOR(pos_vector);
			HW_WEIGHT_OUT <= STD_LOGIC_VECTOR(to_unsigned(count, HW_WEIGHT_WIDTH));
		end if;
	end process hw_proc;

end architecture RTL;
