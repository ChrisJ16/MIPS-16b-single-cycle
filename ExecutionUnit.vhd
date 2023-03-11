library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity ExecutionUnit is
    Port (  PCinc : in std_logic_vector (15 downto 0);
            RD1 : in std_logic_vector(15 downto 0);
            RD2 : in std_logic_vector(15 downto 0);
            Ext_Imm : in std_logic_vector(15 downto 0);
            func : in std_logic_vector(2 downto 0);
            sa : in std_logic;
            ALUSrc : in std_logic;
            ALUOp : in std_logic_vector(2 downto 0);
            BranchAdress : out std_logic_vector(15 downto 0);
            ALURes : out std_logic_vector(15 downto 0);
            Zero : out std_logic;
            LessThanZero : out std_logic
         );
end ExecutionUnit;

architecture Behavioral of ExecutionUnit is
signal AluIn2 : std_logic_vector(15 downto 0);
signal ALUCtrl : std_logic_vector(2 downto 0);
signal Aluresult : std_logic_vector(15 downto 0);
begin
    with ALUSrc select
        AluIn2 <= RD2 when '0',
                  Ext_Imm when '1',
        (others => 'X') when others;
    
    ALU_Control: process(ALUOp, func)
    begin 
        case ALUOp is 
            when "000" =>
                case func is
                    when "000" => ALUCtrl <= "000"; --ADD
                    when "001" => ALUCtrl <= "001"; --SUB
                    when "010" => ALUCtrl <= "010"; --SLL
                    when "011" => ALUCtrl <= "011"; --SRL
                    when "100" => ALUCtrl <= "100"; --AND
                    when "101" => ALUCtrl <= "101"; --OR
                    when "110" => ALUCtrl <= "110"; --XOR
                    when "111" => ALUCtrl <= "111"; --SLT set less than
                    when others => ALUCtrl <= (others => 'X');    
                end case;
            
            when "001" => ALUCtrl <= "000"; -- +
            when "010" => ALUCtrl <= "001"; -- -
            when "101" => ALUCtrl <= "100"; -- &
            when "110" => ALUCtrl <= "101"; -- |
            when others => ALUCtrl <= (others => 'X');
        end case;
    end process;

    ALU: process(ALUCtrl, RD1, ALUIn2, sa)
    begin
        case ALUCtrl is
            when "000" => Aluresult <= RD1 + ALUIn2;
            when "001" => Aluresult <= RD1 - ALUIn2;
            when "010" => --sa verific daca sa este activ pe 1, atunci se face shift
                if sa = '1' then 
                    Aluresult <= RD1(15 downto 1) & '0';
                end if;
            when "011" => 
                if sa = '1' then
                    Aluresult <= '0' & RD1(14 downto 0);
                end if;
            when "100" => Aluresult <= RD1 and ALUIn2;
            when "101" => Aluresult <= RD1 or ALUIn2;
            when "110" => Aluresult <= RD1 xor ALUIn2;
            when "111" => 
                if RD1 < ALUIn2 then
                    Aluresult <= "1111111111111111";
                else
                    Aluresult <= (others => '0');
                end if;
        end case;
    end process;
    
    ALURes <= Aluresult;
    Zero <= '1' when Aluresult = x"0000" else '0';
    LessThanZero <= '1' when AluResult < x"0000" else '0';
end Behavioral;
