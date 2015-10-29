--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:    17:50:52 09/30/15
-- Design Name:    
-- Module Name:    test_osc - Behavioral
-- Project Name:   
-- Target Device:  
-- Tool versions:  
-- Description:
--
-- Dependencies:
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
--------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_SIGNED.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.all;
use IEEE.math_real.all;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity test_osc is
		Port(
		clk : in STD_LOGIC;
		param_cmd : in STD_LOGIC_VECTOR(7 downto 0);
		param_val : in STD_LOGIC_VECTOR(15 downto 0);

		outen : out STD_LOGIC;

		samp_clk : in STD_LOGIC;
		dout : out STD_LOGIC_VECTOR(15 downto 0)
		);
end test_osc;

architecture Behavioral of test_osc is

			signal note_val : STD_LOGIC_VECTOR(6 downto 0) := (others => '0');
			signal note_vel : STD_LOGIC_VECTOR(6 downto 0) := (others => '0');
			signal fcw		 : unsigned (15 downto 0) := (others => '0');
			signal phase	 : unsigned (15 downto 0) := (others => '0');


			-- The LUT for the Frequency Control Word
			-- FCW (Delta F) = Fout * 2^N / Fclock
			-- midi note number to frequency conversion:
			--f=(2^((m-69)/12)) * (440 Hz).
			-- So to get the increment value from the midi note
			-- FCW = 2^((m-69)/12) * 440 Hz * 2^N / Fclock
			-- Using N = 16 gives us a frequency step size of 0.7324 Hz which is nice

			--Generated with FreeMAT (MATLAB Equivalent)
			--m = linespace(0,127,128)
			--fcwlut = (2.^((m-69)/12) * 440 * 65536 / (48000));
			--printf('X"%04X",',fcwlut)

			type fcwlut_type is array (0 to 127) of unsigned (15 downto 0);
			signal fcwlut : fcwlut_type := (X"000B",X"000B",X"000C",X"000D",X"000E",X"000E",X"000F",X"0010",X"0011",X"0012",X"0013",X"0015",X"0016",X"0017",X"0019",X"001A",X"001C",X"001D",X"001F",X"0021",X"0023",X"0025",X"0027",X"002A",X"002C",X"002F",X"0032",X"0035",X"0038",X"003B",X"003F",X"0042",X"0046",X"004B",X"004F",X"0054",X"0059",X"005E",X"0064",X"006A",X"0070",X"0077",X"007E",X"0085",X"008D",X"0096",X"009F",X"00A8",X"00B2",X"00BD",X"00C8",X"00D4",X"00E1",X"00EE",X"00FC",X"010B",X"011B",X"012C",X"013E",X"0151",X"0165",X"017A",X"0190",X"01A8",X"01C2",X"01DC",X"01F9",X"0217",X"0237",X"0258",X"027C",X"02A2",X"02CA",X"02F4",X"0321",X"0351",X"0384",X"03B9",X"03F2",X"042E",X"046E",X"04B1",X"04F8",X"0544",X"0594",X"05E9",X"0643",X"06A3",X"0708",X"0773",X"07E4",X"085C",X"08DC",X"0962",X"09F1",X"0A89",X"0B29",X"0BD3",X"0C87",X"0D46",X"0E10",X"0EE6",X"0FC9",X"10B9",X"11B8",X"12C5",X"13E3",X"1512",X"1653",X"17A7",X"190F",X"1A8C",X"1C20",X"1DCD",X"1F92",X"2173",X"2370",X"258B",X"27C7",X"2A25",X"2CA6",X"2F4E",X"321E",X"3519",X"3841",X"3B9A",X"3F25",X"42E6");

			--This doesn't work probably due to bad math support in ieee packages?
			--gen_fcwlut:
			--for mf in 0 to 127 generate
			--			fcwlut(mf_ <= to_unsigned((integer(2**(real((mf-69)/12))) * 440 * 65536 / 48000), 16);
			--end generate gen_fcwlut;

			--Oscillato enable flag
			signal en : STD_LOGIC := '0';

begin
		
			outen <= en;

			--Data readin
			process(clk)
			begin
					if rising_edge(clk) then
							if param_cmd = "00000000" and param_val(6 downto 0) = note_val then
										--note off
										note_vel <= (others => '0');
										en <= '0';

							elsif param_cmd = "00000001" then
										--We are not playing a not and we got a note on
										note_val <= param_val(6 downto 0);
										note_vel <= param_val(13 downto 7);

										--get the FCW from the LUT
										fcw <= fcwlut(CONV_INTEGER(unsigned(param_val(6 downto 0))));

										en <= '1';

							end if;

						end if;

				end process;

				--Numerically controlled Oscillator
				process(samp_clk)
				begin
						if rising_edge(samp_clk) then
								if en = '1' then
										--increment accumulator
										phase <= phase + fcw;
										-- Output sawtooth. This is bad rounding btw
										dout <= STD_LOGIC_VECTOR(phase);
								else
										dout <="1000000000000000";
								end if;
						end if;
				end process;


end Behavioral;
