library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.constants.all;
use work.classio.all;
use std.textio.all;
use std.env.all;

entity Top_Level_Module_V2_TB is
end entity Top_Level_Module_V2_TB;

architecture RTL of Top_Level_Module_V2_TB is

	constant period : time := 10 ns;
	constant total_packets : natural := 100;
	
	signal clk       : std_logic                                      := '0';
	signal start_pkt : std_logic                                      := '0';
	signal hw_out    : STD_LOGIC_VECTOR(HW_WEIGHT_WIDTH - 1 downto 0) := (others => '0');
	signal pos_valid : STD_LOGIC                                      := '0';
	signal pos_out   : STD_LOGIC_VECTOR(POS_WIDTH - 1 downto 0)       := (others => '0');
	signal rst       : STD_LOGIC                                      := '0';
	signal bitdata   : std_logic_vector(7 downto 0)                   := (others => '0');
	signal finished  : std_logic                                      := '0';

begin
	uut : entity work.Top_Level_Module_V2
		port map(
			RESET_IN           => rst,
			CLK_IN             => clk,
			DATA_IN            => bitdata,
			START_PACKET_IN    => start_pkt,
			HAMMING_WEIGHT_OUT => hw_out,
			POSITION_VALID_OUT => pos_valid,
			POSITION_OUT       => pos_out
		);

	clkproc : process
	begin
		clk <= '0';
		wait for period / 2;
		clk <= '1';
		wait for period / 2;
	end process clkproc;

	feed_data : process(clk, rst)
		file in_byte_file  : TEXT open read_mode is "bitpos.txt";
		variable buff      : line;
		variable read_byte : std_logic_vector(7 downto 0);
	begin
		if rising_edge(clk) and rst = '0' then
			if (not (endfile(in_byte_file))) then
				read_vld(in_byte_file, read_byte);
				if (read_byte = "XXXXXXXX") then
					start_pkt <= '1';
					bitdata   <= (others => '0');
				else
					start_pkt <= '0';
					bitdata   <= read_byte;
				end if;

			else
				bitdata   <= (others => '0');
				start_pkt <= '0';
			end if;
		else
		end if;
	end process feed_data;

	verify_data : process(clk, rst)
		file in_pos_file                : TEXT open read_mode is "position.txt";
		file in_hw_file                 : TEXT open read_mode is "hw.txt";
		variable pos_buff               : line;
		variable hw_buff                : line;
		variable expected_pos           : natural := 0;
		variable actual_pos             : natural := 0;
		variable expected_hw            : natural := 0;
		variable actual_hw              : natural := 0;
		variable testPassed             : boolean := true;
		variable packet                 : natural := 0;
		variable verificationInProgress : boolean := false;
	begin
		if rising_edge(clk) and rst = '0' then
			if (pos_valid = '1') then
				readline(in_pos_file, pos_buff);
				read(pos_buff, expected_pos);
				actual_pos := TO_INTEGER(UNSIGNED(pos_out));
				actual_hw  := TO_INTEGER(UNSIGNED(hw_out));
				if (expected_pos /= actual_pos) then
					report "Pos Error! Packet: " & integer'image(packet) & " Expected Pos: " & integer'image(expected_pos) & " Actual Pos: " & integer'image(actual_pos);
					testPassed := false;
				elsif (expected_hw /= actual_hw) then
					report "HW Error! Packet: " & integer'image(packet) & " Expected HW: " & integer'image(expected_hw) & " Actual HW: " & integer'image(actual_hw);
					testPassed := false;
				elsif (verificationInProgress) then
					verificationInProgress := false;
					echo("Packet:: " & integer'image(packet - 1) & " Expeccted_HW:: " &  integer'image(expected_hw) & " Actual_HW:: " & integer'image(actual_hw) & "  !!Matched!!" & LF);
				end if;
			end if;

			if start_pkt = '1' then
				packet := packet + 1;
				if (packet > 1) then
					verificationInProgress := true;
					readline(in_hw_file, hw_buff);
					read(hw_buff, expected_hw);
				end if;
			end if;

			if (packet = total_packets + 2) then
				finished <= '1';
				if (testPassed) then
					report "Test Passed for 100 packets.";
				else
					report "Test Failed for 100 packets.";
				end if;
				stop(0);
			end if;

		end if;
	end process verify_data;
	
	stimulus : process
	begin
		rst <= '1';
		wait for 100 ns;
		rst <= '0';
		
		wait;
	end process stimulus;

end architecture RTL;
