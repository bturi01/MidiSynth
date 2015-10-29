--------------------------------------------------------------------------------
-- Company: 
-- Engineer:
--
-- Create Date:    14:19:33 10/14/15
-- Design Name:    
-- Module Name:    I2S_cntrl - Behavioral
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
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

---- Uncomment the following library declaration if instantiating
---- any Xilinx primitives in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity I2S_cntrl is
		generic (
				-- Sample width
				samp_width : integer :=16;

				-- (mclk_freq * 2^16) / CCLK = mclk_div;
				-- Default 48 khz fs, 50mhz system clk
				-- Desired mclk_freq of 12.288khz according to CS4344 datasheet
				-- (12.288e6 * 2^16) / 50e6 = 16106.12736
				-- This method over a standard divider gets up to 47.9996 khz vs.
				-- a straight up divider getting as close as 48.828 khz
				mclk_accum_inc : integer := 16106;

				-- subdivider from the mclk freqency
				-- Default fs 48khz and the mclkc 12.2880 khz so divide by 256
				lrck_div : integer := 256);
		
		port (
				-- Data imputs
				ldin : in STD_LOGIC_VECTOR ((samp_width-1) downto 0);
				rdin : in STD_LOGIC_VECTOR ((samp_width-1) downto 0);
				-- System clock (50 Mhz?)
				clk : in STD_LOGIC;

				reset : in STD_LOGIC;

				-- I2S bus output
				sdout : out STD_LOGIC;
				sclk : out STD_LOGIC;
				lrck : out STD_LOGIC; -- Also used as the sample clock for all sample generation functions
				mclk : out STD_LOGIC
				);

end I2S_cntrl;

architecture Behavioral of I2S_cntrl is

			signal mclk_accum : unsigned (15 downto 0);
			signal mclk_accum_d : unsigned (15 downto 0);

			signal mclk_d : STD_LOGIC; --Internal mclk dummy signal
			signal sclk_d : STD_LOGIC; --Internal sclk signal
			signal lrck_d : STD_LOGIC; --Internal lrclk signal

			-- Latches to keep data constant while transmitting
			signal ldin_d : STD_LOGIC_VECTOR ((samp_width-1) downto 0);
			signal rdin_d : STD_LOGIC_VECTOR ((samp_width-1) downto 0);


			-- divider counters
			signal sclk_accum : integer range 0 to lrck_div; --sclk divider
			signal lrck_accum : integer range 0 to lrck_div; --lrck divider

			-- Bit counter
			signal bit_cntr : integer range -1 to samp_width;

begin

		--DA PROCESS
		--I'm sure this is bad VHDL, it's all in this one process, but it makes sense to me so whatevs man
		process(clk)
		begin
			  if rising_edge(clk) then
			  		if reset = '1' then
							sdout <= '0';
							sclk <= '0';
							lrck <= '0';
							mclk <= '0';

							mclk_accum <= (others => '0');
							mclk_accum_d <= (others => '0');

							mclk_d <= '0';
							sclk_d <= '0';
							lrck_d <= '0';

							ldin_d <= (others => '0');
							rdin_d <= (others => '0');

							sclk_accum <= 0;
							lrck_accum <= 0;

							bit_cntr <= 0;
					else
							--generate mclk
							mclk_accum_d <= mclk_accum;
							mclk_accum <= mclk_accum + mclk_accum_inc*2;
							--Multiple mclk_accum_inc by two to get each half of the mclk period

							if mclk_accum < mclk_accum_d then
								mclk_d <= not mclk_d; --flip mclk
								mclk <= mclk_d;

								-- Since we're flipping mclk, we might as well do all the other clock stuff now
								if mclk_d = '1' then --gotta only do this on the rising edge of the mclk

										--Generate LRCK
										lrck_accum <= lrck_accum + 1;
										if lrck_accum <= ((lrck_div/2)-1) then --lrck_div divided by two to get both sides
										--Reset lrck_accum cause it to be OVERFLOWN
										lrck_accum <= 0;
										--When it overflows we flip lrck
										lrck_d <= not lrck_d;
										lrck <= lrck_d;

										--We also want to make SCLK start here, so we gonna do that now
										sclk_accum <= 2;

										--Also we are going to reset the bit_ctnr
										bit_cntr <= samp_width; --no -1 because the first sclk needs to be nothingness

										--And finally we need to latch the data inputs so they don't change on us
										-- only do this on the falling edge of the lrck
										if lrck_d = '0' then
											ldin_d <= ldin;
											rdin_d <= rdin;

										end if;

								end if;

								--Generate SCLK
								sclk_accum <= sclk_accum + 1;
								if sclk_accum = 1 then
										sclk <= '1';
								elsif sclk_accum > 2 then
										sclk_accum <= 0; -- reset accumulator
										sclk <= '0';

										-- We might as well shift the data while we're here

										if bit_cntr < samp_width and bit_cntr > -1 then
											if lrck_d = '0' then --Left channel sample
													sdout <= ldin_d(bit_cntr);
											else
													sdout <= rdin_d(bit_cntr);
											end if;
										else
												--otherwise we don't want to be putting any data on
												sdout <= '0';
										end if;

										--Control bit counter
										if bit_cntr >= 0 then
												--decrement bit_cntr
												bit_cntr <= bit_cntr - 1;
										end if;

									end if; --sclk_accum overflow
							end if; --mclk period (rising edge)
						end if; --mclk flip
					end if; --reset
				end if; --rising_edge (clk)
		end process;
		--and that should be it!
end Behavioral;
