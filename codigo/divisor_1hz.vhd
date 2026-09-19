library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity divisor_1hz is
    port (reloj50Mhz, reset1 : in std_logic; reloj1hz : out std_logic);
end entity;

architecture logica of divisor_1hz is
    signal cuenta : integer range 0 to 24999999 := 0;
    signal estado : std_logic := '0';
begin
    process (reloj50Mhz, reset1)
    begin
        if reset1 = '1' then
            cuenta <= 0; estado <= '0';
        elsif reloj50Mhz'event and reloj50Mhz = '1' then
            if cuenta = 24999999 then
                estado <= not estado; cuenta <= 0;
            else
                cuenta <= cuenta + 1;
            end if;
        end if;
    end process;
    reloj1hz <= estado;
end architecture;