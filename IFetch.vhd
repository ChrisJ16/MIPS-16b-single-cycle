library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity IFetch is
    Port ( clk : in std_logic;
           reset : in std_logic;
           enable : in std_logic;
           branch_adress : in std_logic_vector(15 downto 0); 
           jump_adress : in std_logic_vector(15 downto 0);
           jump : in std_logic; -- semnalul de control pentru jump
           PCSrc : in std_logic; -- semnalul de control pentru branch
           Instr : out std_logic_vector(15 downto 0); --instructiunea ce se va executa pe ciclul de ceas curent
           PCinc : out std_logic_vector(15 downto 0) --adresa urmatoarei instructiuni de executat
         );
end IFetch;


architecture Behavioral of IFetch is
type MEMROM is array(0 to 15) of std_logic_vector(15 downto 0);
signal ROM : MEMROM := 
    (
       B"001_000_110_0000111",	-- addi $6, 7($0) 
	   B"001_000_001_0000001",	-- addi $1, 1($0)
	   B"001_011_001_0000000",	--addi $3, 0($1)
	   B"000_011_110_100_1_001",	-- sub $4, $3, $6
	   B"101_101_000_0000100",	-- bltz $4, $0, 9  
	   B"100_100_000_0000110",	--beq $4, $0, 6
	   B"001_000_101_0001010",	-- addi $5, 10($0)
	   B"011_000_101_0000000",	-- sw $5, 0($0)
	   B"111_0000000000001",		-- j 1
	   B"001_000_101_0001111",	-- addi $5, 15($0)
       B"011_000_101_0000000",	-- sw $5 , 0($0)
       --11: B"000_000_010_101_0_100"	H"0154"		11 : and $5, $0, $2
       B"110_000_101_0000000",	-- andi $5, 0($0)
       B"111_0000000000001",		-- j 1
       B"001_000_000_0000000",	-- addi $0, 0($0)
   
        others => X"0000");
signal pc : std_logic_vector(15 downto 0) := x"0000";
signal pcaux : std_logic_vector(15 downto 0) := x"0000";
signal MUX1 : std_logic_vector(15 downto 0) := x"0000"; --iesirea primului mux
signal MUX2 : std_logic_vector(15 downto 0) := x"0000"; --iesirea celui de-al doilea mux

begin

    process(clk)--PC Counter
    begin
        if rising_edge(clk) then
            if reset = '1' then   
                pc <= x"0000";
            else
                if enable = '1' then
                    pc <= MUX2;
                end if;
            end if;  
        end if;
    end process;
    
    process(pcSrc, branch_adress)--pentru primul MUX1
    begin
        if pcSrc = '1' then
            MUX1 <= branch_adress;
        else
            MUX1 <= pcaux;
        end if;            
    end process;
    
    process(jump, jump_adress)--pentru al doilea MUX2
    begin
        if jump = '1' then
            MUX2 <= jump_adress;
        else
            MUX2 <= MUX1;
        end if;
    end process;
   
    pcaux <= pc + x"0001"; -- "pc+4" urmatoarea instructiune
    
    pcinc <= pc; --adresa urmatoarei instructiuni
    Instr <= ROM(conv_integer(pc)); --adresa instr ce se va executa pe ciclul curent de ceas, folosim ultimii 5 cei mai nesimnificativi biti
end Behavioral;
