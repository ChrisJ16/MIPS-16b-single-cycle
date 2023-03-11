library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity test_env is
    Port ( clk : in std_logic;
           btn : in std_logic_vector(4 downto 0);
           sw : in std_logic_vector(15 downto 0);
           
           led : out std_logic_vector(15 downto 0);
           an: out std_logic_vector(3 downto 0);
           cat: out std_logic_vector(6 downto 0)           
          );
end test_env;

architecture Behavioral of test_env is
--componente
component MPG is
     Port (clk : in std_logic;
           input : in std_logic;
           en : out std_logic);
end component;

component SSD is
     Port (clk : in std_logic; --clock
           num16b: in std_logic_vector(15 downto 0);
           cat : out std_logic_vector (6 downto 0);
           an : out std_logic_vector (3 downto 0));
end component;

component IFetch is 
    Port (clk : in std_logic;
          reset : in std_logic;
          enable : in std_logic;
          branch_adress : in std_logic_vector(15 downto 0);
          jump_adress : in std_logic_vector(15 downto 0);
          jump : in std_logic;
          PCSrc : in std_logic;
          Instr : out std_logic_vector(15 downto 0);
          PCinc : out std_logic_vector(15 downto 0));
end component;

component Idecode is
     Port (clk : in std_logic;
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
           sa : out std_logic);
end component;

component ExecutionUnit is
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
end component;

component MainControl is 
    Port (OpCode : in std_logic_vector(2 downto 0);
          RegDst : out std_logic; --ok
          ExtOp : out std_logic; --ok
          ALUSrc : out std_logic; --ok
          Branch : out std_logic; --ok
          Jump : out std_logic; --ok
          ALUOp : out std_logic_vector(2 downto 0);
          MemWrite : out std_logic; --ok
          MemtoReg : out std_logic; --ok
          RegWrite : out std_logic --ok
         );
end component;

component MEM is 
     Port ( clk : in std_logic;
           en : in std_logic;
           ALURes : in std_logic_vector(15 downto 0);
           RD2 : in std_logic_vector(15 downto 0);
           MemWrite : in std_logic;
           MemData : out std_logic_vector(15 downto 0);
           ALUResOut : out std_logic_vector(15 downto 0)
         );
end component;
--end componente

--semnale
signal LessThanZero : std_logic;
signal Instruction, PCinc, RD1, RD2, WD, Ext_imm : std_logic_vector(15 downto 0);
signal JumpAdress, BranchAdress, ALURes, ALURes1, MemData : std_logic_vector(15 downto 0);
signal func : std_logic_vector(2 downto 0);
signal sa, zero : std_logic;
signal digits : std_logic_vector(15 downto 0);
signal en, reset, PCSrc : std_logic;
--main controls
signal RegDst, ExtOp, ALUSrc, Branch, Jump, MemWrite, MemtoReg, Regwrite : std_logic;
signal ALUOp : std_logic_vector(2 downto 0);
--end semnale
begin
    --buttons
    MPG1: MPG port map(clk, btn(0), en);
    MPG2: MPG port map(clk, btn(1), reset);
    --main units
    IFetch1: IFetch port map(clk,reset,en,BranchAdress,JumpAdress,Jump,PCSrc,Instruction, PCinc);
    IDecode1:IDecode port map(clk,en,Instruction(12 downto 0), WD, RegWrite, RegDst, ExtOp, RD1, RD2, Ext_imm, func, sa);
    MC1: MainControl port map(Instruction(15 downto 13), RegDst, ExtOp, ALUSrc, Branch, Jump, ALUOp, MemWrite, MemtoReg, RegWrite); 
    EX1:  ExecutionUnit port map(PCinc,RD1,RD2,Ext_imm,func,sa,ALUSrc,ALUOp,BranchAdress,ALURes,zero,LessThanZero);
    MEM1: MEM port map(clk,en,ALURes,RD2,MemWrite,MemData,ALURes1);
    
    --write back unit:
    with MemtoReg select
        WD <= MemData when '1',
            ALURes1 when '0',
           (others=> 'X') when others;
           
    --branch control
    PCSrc <= Zero and (Branch or LessThanZero);
    
    --jump adress
    JumpAdress <= PCinc(15 downto 13) & Instruction(12 downto 0);
   
   with sw(7 downto 5) select
   digits <= Instruction when "000",
             PCInc when "001",
             RD1 when "010",
             RD2 when "011",
             Ext_Imm when "100",
             ALURes when "101",
             MemData when  "110",
             WD when  "111",
             (others => 'X') when others;
    
    SSD1: SSD port map(clk, digits,cat,an);
    --main control on the leds
    led(10 downto 0) <= ALUOp & RegDst & ExtOp & ALUSrc & Branch & Jump & MemWrite & MemtoReg & RegWrite;

end Behavioral;
