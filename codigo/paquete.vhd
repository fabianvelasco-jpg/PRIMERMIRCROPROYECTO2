library IEEE;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_1164.ALL;
--paquete con mis componenetes de losarchivos para ahrorrarme lineas de codgio en el sistema top, contiene al divizor, el decodifiacdor, y los dos casos de temporizadores
package paquete is
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
end package;