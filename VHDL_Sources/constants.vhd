package constants is
	constant MAX_POSITIONS    : natural := 31; -- Max Hamming Weight 
	constant DATA_WIDTH       : natural := 8; -- Input data width
	constant HW_WEIGHT_WIDTH  : natural := 5; -- 5 bits to represent the range 0 to 31
	constant POS_WIDTH        : natural := 10; -- 10 bits to represent the range 0 to 1023
	constant POS_VECTOR_WIDTH : natural := MAX_POSITIONS*POS_WIDTH; -- Max Positions : 31 (each of 10 width) = 310 bits

end package constants;

package body constants is

end package body constants;
