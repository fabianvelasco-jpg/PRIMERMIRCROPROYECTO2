library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity BCD_7seg is
    port (
        entradaBCD : in  std_logic_vector(3 downto 0);
        salida7seg : out std_logic_vector(6 downto 0)
    );
end BCD_7seg;

architecture decodificador of BCD_7seg is
begin
    process(entradaBCD)
    begin
        case entradaBCD is
            when "0000" => salida7seg <= "1000000"; 
            when "0001" => salida7seg <= "1111001"; 
            when "0010" => salida7seg <= "0100100"; 
            when "0011" => salida7seg <= "0110000"; 
            when "0100" => salida7seg <= "0011001"; 
            when "0101" => salida7seg <= "0010010"; 
            when "0110" => salida7seg <= "0000010"; 
            when "0111" => salida7seg <= "1111000"; 
            when "1000" => salida7seg <= "0000000"; 
            when "1001" => salida7seg <= "0010000"; 
            when others => salida7seg <= "1111111"; 
        end case;
    end process;
end architecture;