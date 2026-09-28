library IEEE;
library work;
use IEEE.STD_LOGIC_1164.ALL;
use work.paquete.ALL;

entity sistema_top is
    port (
        relojTop     : in  std_logic;
        resetTop     : in  std_logic;
        sensorTop    : in  std_logic;
        alarmaTop    : out std_logic;
        premioTop    : out std_logic;
        dispBaseUni  : out std_logic_vector(6 downto 0);
        dispBaseDec  : out std_logic_vector(6 downto 0);
        dispExtraUni : out std_logic_vector(6 downto 0);
        dispExtraDec : out std_logic_vector(6 downto 0)
    );
end entity;

architecture estructural of sistema_top is

    -- Cables de interconexión interna
    signal cableReloj1hz : std_logic;
    signal cableAviso    : std_logic;
    signal cableUni1     : std_logic_vector(3 downto 0);
    signal cableDec1     : std_logic_vector(3 downto 0);
    signal cableUni2     : std_logic_vector(3 downto 0);
    signal cableDec2     : std_logic_vector(3 downto 0);

begin
    --mapeo para el componente de la señal de 1hz de aquí tengo la señal de 1hz
    U1: divisor_1hz port map (
        reloj50Mhz => relojTop,
        reset1     => resetTop,
        reloj1hz   => cableReloj1hz
    );

    U2: temporizador_base port map ( --temporizador base, este es el que em cuenta de cero a 35 y activa el sigueinte contador (exceso)
        relojBase    => cableReloj1hz,
        resetBase    => resetTop,
        sensorBase   => sensorTop,
        alarmaBase   => alarmaTop,
        premioBase   => premioTop,
        activaCobro  => cableAviso,
        unidadesBase => cableUni1,
        decenasBase  => cableDec1
    );

    U3: temporizador_exceso port map ( --exceso, este es el que cueneta el exceso de la persona,con la activación del anterior cintador
        relojExtra    => cableReloj1hz,
        resetExtra    => resetTop,
        sensorExtra   => sensorTop,
        permisoCobro  => cableAviso,
        unidadesExtra => cableUni2,
        decenasExtra  => cableDec2
    );
    -- llamados al decodificador para los segundos de base y de exceso
    U4: BCD_7seg port map (entradaBCD => cableUni1, salida7seg => dispBaseUni);
    U5: BCD_7seg port map (entradaBCD => cableDec1, salida7seg => dispBaseDec);
    
    U6: BCD_7seg port map (entradaBCD => cableUni2, salida7seg => dispExtraUni);
    U7: BCD_7seg port map (entradaBCD => cableDec2, salida7seg => dispExtraDec);

end architecture;