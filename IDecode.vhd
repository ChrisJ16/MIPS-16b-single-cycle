library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity IDecode is
    Port ( clk : in std_logic;
           en : in std_logic;
           Instr : in std_logic_vector(12 downto 0);
           WD : in std_logic_vector(15 downto 0);
           RegWrite : in std_logic;
           RegDst : in std_logic;
           ExtOp : in std_logic;
           RD1 : out std_logic_vector(15 downto 0);
           RD2 : out std_logic_vector(15 downto 0);
           Ext_Imm : out std_logic_vector(15 downto 0);
           func : out std_logic_vector(2 downto 0);
           sa : out std_logic
         );
end IDecode;

architecture Behavioral of IDecode is
signal MuxOut : std_logic_vector(2 downto 0);
component RF is 
    Port ( clk : in std_logic;
        ra1: in std_logic_vector(2 downto 0); --Instr(12 downto 10)
        ra2: in std_logic_vector(2 downto 0); --Instr(9 downto 7)
        regwr: in std_logic;
        wa: in std_logic_vector(2 downto 0);
        wd: in std_logic_vector(15 downto 0);
        rd1: out std_logic_vector(15 downto 0);
        rd2: out std_logic_vector(15 downto 0));
end component;
signal Rd1out, Rd2out : std_logic_vector(15 downto 0);
begin
    --Instr(12 downto 10) RS
    --Instr(9 downto 7) RT
    --Instr(6 downto 4) RD
    
    with RegDst select --Iesire din MUX 
            MuxOut <= Instr(9 downto 7) when '0',
                    Instr(6 downto 4) when '1',
            (others => '0') when others;
     
    RF1: RF port map(clk, Instr(12 downto 10), Instr(9 downto 7), RegWrite, MuxOut, WD, Rd1out, Rd2out );
    
    extend: process(ExtOp)
    begin
        if ExtOp = '1' then
            Ext_Imm <= "000000000" & Instr(6 downto 0);
        else
            Ext_Imm <= "111111111" & Instr(6 downto 0);
        end if;
    end process;
    
    RD1 <= Rd1out;
    RD2 <= Rd2out;
    func <= Instr(2 downto 0); --function
    sa <= Instr(3); --shift amount
    
end Behavioral;
