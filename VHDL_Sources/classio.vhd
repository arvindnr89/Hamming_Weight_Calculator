library IEEE;
use IEEE.std_logic_1164.all;
use STD.textio.all;
package classio is
	procedure read_vld(file f : text; v : out std_logic_vector);
	procedure write_vld(file f : text; v : in std_logic_vector);
	procedure echo (arg : in string);
end package classio;

package body classio is

	procedure read_vld(file f : text; v : out std_logic_vector) is
		variable buf : line;
		variable c   : character;
	begin
		readline(f, buf);               -- complete line is read into buffer buf
		for i in v'range loop
			read(buf, c);
			case c is
				when 'X'    => v(i) := 'X';
				when 'U'    => v(i) := 'U';
				when 'Z'    => v(i) := 'Z';
				when '0'    => v(i) := '0';
				when '1'    => v(i) := '1';
				when '-'    => v(i) := '-';
				when 'W'    => v(i) := 'W';
				when 'H'    => v(i) := 'H';
				when 'L'    => v(i) := 'L';
				when others => v(i) := '0';
			end case;
		end loop;
	end procedure read_vld;

	procedure write_vld(file f : text; v : in std_logic_vector) is
		variable buf : line;
		variable c   : character;
	begin
		for i in v'range loop
			case v(i) is
				when 'X'    => write(buf, 'X');
				when 'U'    => write(buf, 'U');
				when 'Z'    => write(buf, 'Z');
				when '0'    => write(buf, character'('0'));
				when '1'    => write(buf, character'('1'));
				when '-'    => write(buf, '-');
				when 'W'    => write(buf, 'W');
				when 'H'    => write(buf, 'H');
				when 'L'    => write(buf, 'L');
				when others => write(buf, character'('0'));
			end case;
		end loop;
		writeline(f, buf);
	end procedure write_vld;
	
	procedure echo (arg : in string) is
	begin
  		std.textio.write(std.textio.output, arg);
	end procedure echo;

end package body classio;
