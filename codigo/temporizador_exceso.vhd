library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity temporizador_exceso is
    port (
        relojExtra    : in  std_logic;
        resetExtra    : in  std_logic;
        sensorExtra   : in  std_logic;
        permisoCobro  : in  std_logic;
        unidadesExtra : out std_logic_vector(3 downto 0);
        decenasExtra  : out std_logic_vector(3 downto 0)
    );
end entity;

architecture comportamiento of temporizador_exceso is
    signal cuentaExtra : unsigned(6 downto 0);--señal para guardar la cuenta de exceso
begin
    process (relojExtra, resetExtra)--process sencible a señal de reloj de 1hz (relojextra = reloj de 1hz), y al resed que tambien es el mismo
    begin-- si es reset está activo la cuenta vueleve a cero
        if resetExtra = '0' then
            cuentaExtra <= (others => '0');
        elsif relojExtra'event and relojExtra = '1' then -- primero se evalua el flanco se subida rel reloj de 1hz, o sea cada segundo
            if sensorExtra = '1' and permisoCobro = '1' then  -- se evalua si se el puesto está ocupado y también si está activo la señal de alarma que viene desde el contador base
                cuentaExtra <= cuentaExtra + 1; --se le suma a la cuenta cada segundo despues de que todo lo anterior se cumpla, como un nuevo contador patra el exceso
            elsif sensorExtra = '0' then --si es puesto se desocupó entoinces vuelvo mi cuenta a cero, la sñeal de alarma ya se ha enviado desde el anteior contador entonces este solamente mandaría la cuenta
                cuentaExtra <= (others => '0');
            end if;
        end if;
    end process;
    -- al giual que el contador base este hacae operaciones primero con enterios ty despues vuelev esto a biranrio para mandarlo al decodificador
    unidadesExtra <= std_logic_vector(to_unsigned(to_integer(cuentaExtra) mod 10, 4));
    decenasExtra  <= std_logic_vector(to_unsigned((to_integer(cuentaExtra) / 10) mod 10, 4));
end architecture;