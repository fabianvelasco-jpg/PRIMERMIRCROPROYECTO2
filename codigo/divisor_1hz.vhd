library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity divisor_1hz is
    port (reloj50Mhz, reset1 : in std_logic; reloj1hz : out std_logic);
end entity;

architecture logica of divisor_1hz is
    signal cuenta : integer range 0 to 24999999 := 0;-- señales de ayuda para hacer cambios con la señaldel reloj de 50 millones
    signal estado : std_logic := '0';
begin
    process (reloj50Mhz, reset1) --process sensible a las señales de reloj de 50 millones y al resed
    begin
        if reset1 = '1' then							--primera evaluacion, toma el reset como primera condición, si está activo inmediantamente el estado será cero así como la cuenta
            cuenta <= 0; estado <= '0';										
        elsif reloj50Mhz'event and reloj50Mhz = '1' then -- cuenta 25 milones de flancos de subida (0.5 segundos) para negar el estado, y así otros 25 millloones para volver a que
																			-- sea el original, por lo que tendría dos estados diferenets durante 1 segundo, 0.5 segundos arriba y el otro 0.5 abajo
            if cuenta = 24999999 then
                estado <= not estado; cuenta <= 0;
            else
                cuenta <= cuenta + 1;
            end if;
        end if;
    end process;
    reloj1hz <= estado; -- se le asignaa el esatdo que ya es de 1hz al reloj
end architecture;