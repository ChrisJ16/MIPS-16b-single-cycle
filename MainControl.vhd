library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;


entity MainControl is
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
end MainControl;

architecture Behavioral of MainControl is
begin
    process(opcode)
    begin
        case opcode is
            when "000" => --Operatii de tip R
                ALUOp <="000";
                RegDst <= '1'; 
                 ExtOp <= '0';
                ALUSrc <= '0';
                Branch <= '0';
                Jump   <= '0';
                MemWrite<='0';
                MemtoReg<='0';
                RegWrite<='1';
            when "001" => --addi
                ALUOp <="001";
                RegDst <= '0'; 
                 ExtOp <= '1';
                ALUSrc <= '1';
                Branch <= '0';
                Jump   <= '0';
                MemWrite<='0';
                MemtoReg<='0';
           when "011" => --sw
                ALUOp <="001";
                RegDst <= '0'; 
                 ExtOp <= '1';
                ALUSrc <= '1';
                Branch <= '0';
                Jump   <= '0';
                MemWrite<='1';
                MemtoReg<='0';
                RegWrite<='0';
            when "100" => --beq
                ALUOp <="010";
                RegDst <= '0'; 
                 ExtOp <= '1';
                ALUSrc <= '0';
                Branch <= '1';
                Jump   <= '0';
                MemWrite<='0';
                MemtoReg<='0';
                RegWrite<='0';
            when "101" => --bltz
                ALUOp <="010";
                RegDst <= '0'; 
                 ExtOp <= '1';
                ALUSrc <= '0';
                Branch <= '1';
                Jump   <= '0';
                MemWrite<='0';
                MemtoReg<='0';
                RegWrite<='0';
            when "110" => --andi
                ALUOp <="101";
                RegDst <= '0'; 
                 ExtOp <= '0';
                ALUSrc <= '1';
                Branch <= '0';
                Jump   <= '0';
                MemWrite<='0';
                MemtoReg<='0';
                RegWrite<='1';
           when "111" => --andi
                ALUOp <="000";
                RegDst <= '0'; 
                 ExtOp <= '0';
                ALUSrc <= '0';
                Branch <= '0';
                Jump   <= '1';
                MemWrite<='0';
                MemtoReg<='0';
                RegWrite<='0';
                     
            when others => RegDst <= '0';
        end case;
    end process;

end Behavioral;
