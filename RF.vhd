library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity RF is
 Port ( clk : in std_logic;
        ra1: in std_logic_vector(2 downto 0);
        ra2: in std_logic_vector(2 downto 0);
        regwr: in std_logic;
        wa: in std_logic_vector(2 downto 0);
        wd: in std_logic_vector(15 downto 0);
        rd1: out std_logic_vector(15 downto 0);
        rd2: out std_logic_vector(15 downto 0));
end RF;

architecture Behavioral of RF is
--semnale
type MEMREG is array(0 to 15) of std_logic_vector(15 downto 0);
signal REG : MEMREG := (others => x"0000");
 --end semnale
begin
    scriere: process(clk)
    begin 
        if rising_edge(clk) then
            if regwr = '1' then
                REG(conv_integer(wa)) <= wd;
            end if;
        end if;
    end process;
    
    rd1 <= REG(conv_integer(ra1));
    rd2 <= REG(conv_integer(ra2));
    
end Behavioral;
