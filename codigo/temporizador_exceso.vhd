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
    signal cuentaExtra : unsigned(9 downto 0);
begin
    process (relojExtra, resetExtra)
    begin
        if resetExtra = '1' then
            cuentaExtra <= (others => '0');
        elsif relojExtra'event and relojExtra = '1' then
            if sensorExtra = '1' and permisoCobro = '1' then
                cuentaExtra <= cuentaExtra + 1;
            elsif sensorExtra = '0' then
                cuentaExtra <= (others => '0');
            end if;
        end if;
    end process;
    
    unidadesExtra <= std_logic_vector(to_unsigned(to_integer(cuentaExtra) mod 10, 4));
    decenasExtra  <= std_logic_vector(to_unsigned((to_integer(cuentaExtra) / 10) mod 10, 4));
end architecture;