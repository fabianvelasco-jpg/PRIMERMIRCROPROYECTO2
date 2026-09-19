library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

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
    
    component divisor_1hz is
        port (reloj50Mhz, reset1 : in std_logic; reloj1hz : out std_logic);
    end component;

    component temporizador_base is
        port (
            relojBase, resetBase, sensorBase : in std_logic;
            alarmaBase, premioBase, activaCobro : out std_logic;
            unidadesBase, decenasBase : out std_logic_vector(3 downto 0)
        );
    end component;

    component temporizador_exceso is
        port (
            relojExtra, resetExtra, sensorExtra, permisoCobro : in std_logic;
            unidadesExtra, decenasExtra : out std_logic_vector(3 downto 0)
        );
    end component;

    component BCD_7seg is
        port (
            entradaBCD : in std_logic_vector(3 downto 0);
            salida7seg : out std_logic_vector(6 downto 0)
        );
    end component;

    -- Cables de interconexión interna
    signal cableReloj1hz : std_logic;
    signal cableAviso    : std_logic;
    signal cableUni1     : std_logic_vector(3 downto 0);
    signal cableDec1     : std_logic_vector(3 downto 0);
    signal cableUni2     : std_logic_vector(3 downto 0);
    signal cableDec2     : std_logic_vector(3 downto 0);

begin
    
    U1: divisor_1hz port map (
        reloj50Mhz => relojTop,
        reset1     => resetTop,
        reloj1hz   => cableReloj1hz
    );

    U2: temporizador_base port map (
        relojBase    => cableReloj1hz,
        resetBase    => resetTop,
        sensorBase   => sensorTop,
        alarmaBase   => alarmaTop,
        premioBase   => premioTop,
        activaCobro  => cableAviso,
        unidadesBase => cableUni1,
        decenasBase  => cableDec1
    );

    U3: temporizador_exceso port map (
        relojExtra    => cableReloj1hz,
        resetExtra    => resetTop,
        sensorExtra   => sensorTop,
        permisoCobro  => cableAviso,
        unidadesExtra => cableUni2,
        decenasExtra  => cableDec2
    );

    U4: BCD_7seg port map (entradaBCD => cableUni1, salida7seg => dispBaseUni);
    U5: BCD_7seg port map (entradaBCD => cableDec1, salida7seg => dispBaseDec);
    
    U6: BCD_7seg port map (entradaBCD => cableUni2, salida7seg => dispExtraUni);
    U7: BCD_7seg port map (entradaBCD => cableDec2, salida7seg => dispExtraDec);

end architecture;