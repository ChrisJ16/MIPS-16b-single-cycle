library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity MEM is --memoria RAM
    Port ( clk : in std_logic;
           en : in std_logic;
           ALURes : in std_logic_vector(15 downto 0);
           RD2 : in std_logic_vector(15 downto 0);
           MemWrite : in std_logic;
           MemData : out std_logic_vector(15 downto 0);
           ALUResOut : out std_logic_vector(15 downto 0)
         ); 
end MEM;

architecture Behavioral of MEM is
type MEMRAM is array(0 to 8) of std_logic_vector(15 downto 0); --128
signal RAMMEMORY : MEMRAM;
begin
    process(MemWrite)
    begin
        if rising_edge(clk) then
            if MemWrite = '1' then
                RAMMEMORY(conv_integer(ALURes(2 downto 0))) <= RD2; 
            end if;
        end if;
    end process;
    
    ALUResOut <= ALURes;
    MemData <= RAMMEMORY(conv_integer(ALURes(2 downto 0)));
end Behavioral;
