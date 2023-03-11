library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MPG is
    Port ( 
           clk : in std_logic;
           input : in std_logic;
           en : out std_logic);
end MPG;

architecture Behavioral of MPG is
signal count : std_logic_vector(31 downto 0) := x"00000000";
signal Q1: std_logic;
signal Q2: std_logic;
signal Q3: std_logic;
begin
    en <= Q2 and (not Q3);
	
	process (clk) begin
		if clk'event and clk='1'then
			count <= count + 1;
		end if;
	end process;
	
    process(clk)
    begin
      if clk'event and clk='1' then
        if(count(15 downto 0) = "1111111111111111") then
            Q1 <= input;
        end if;
      end if;
    end process;
    
    process(clk)
    begin 
      if rising_edge(clk) then
        Q2<=Q1;
        Q3<=Q2;  
      end if;
    end process;
end Behavioral;
