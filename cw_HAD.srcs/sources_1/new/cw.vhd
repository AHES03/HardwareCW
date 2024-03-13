----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/26/2024 04:45:33 PM
-- Design Name: 
-- Module Name: cw - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity cw is
    Port ( 
           A: in STD_LOGIC_VECTOR(5 downto 0);
           B: in STD_LOGIC_VECTOR(5 downto 0);
           OP : in STD_LOGIC_VECTOR(2 downto 0);
           S : out STD_LOGIC_VECTOR(5 downto 0);
           Cout : out STD_LOGIC;
           Overflow : out STD_LOGIC;
           flagOut : out STD_LOGIC
           );

end cw;

architecture Behavioral of cw is
    signal flagTemp, logic_temp: STD_LOGIC;
    signal logicalArray :STD_LOGIC_VECTOR(5 downto 0);
    signal flag: std_logic;
    signal MathsResult: STD_LOGIC_VECTOR(5 downto 0);
    signal LogicalResult: STD_LOGIC_VECTOR(5 downto 0);    
    signal carry: STD_LOGIC; 
    signal Temp: STD_LOGIC;
    signal Prop: STD_LOGIC;
    signal Gen: STD_LOGIC;
 function AnswerCheck(D: STD_LOGIC_VECTOR; E: STD_LOGIC_VECTOR; OP: STD_LOGIC_VECTOR)
 
        return STD_LOGIC_VECTOR is
        variable result: STD_LOGIC_VECTOR(5 downto 0); -- Assuming D and E are the same length
    begin
    
        for i in D'range loop
            result(i) := (D(i) and not OP(0)) or (OP(0) and E(i));
        end loop;

        return result;
    end function AnswerCheck;

        
    
begin
    process(a, b)
        variable logic_temp: std_logic;
        variable flagTemp: std_logic := '0'; 
    begin
    logicalArray <= not (a and b);
    for i in 0 to 5 loop
            logic_temp := '1' and logicalArray(i); 
            flagTemp := logic_temp or flagTemp;  
    end loop;
    flag <= flagTemp;
    for i in A'range loop
        LogicalResult(i) <= ( A(i) or B(i) or not(OP(1))) and 
        ((not(OP(1))or OP(2)) or ( A(i) and B(i))) 
        and (OP(1)or not(OP(2)) or (A(i) xor B(i)));  
    end loop;
    carry <= OP(1);
    for i in 0 to 5 loop
        Prop <= A(i) xor (OP(1) xor B(i));
        Gen <= A(i) and (OP(1) xor B(i));
        MathsResult(i) <= Prop xor Gen;
        Temp <= carry;
        carry <= Gen or (Prop and Temp);
    end loop;

    S <= AnswerCheck(LogicalResult,MathsResult,OP);
    Cout<= (not(OP(0))and(not(OP(1))and carry));
    Overflow<= (OP(0)and(OP(1)and carry));
        
        
        
    
    
 end process;
end Behavioral;