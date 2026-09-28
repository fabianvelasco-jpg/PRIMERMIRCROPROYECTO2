library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity temporizador_base is
    port (
        relojBase    : in  std_logic;
        resetBase    : in  std_logic;
        sensorBase   : in  std_logic;
        alarmaBase   : out std_logic;
        premioBase   : out std_logic;
        activaCobro  : out std_logic;
        unidadesBase : out std_logic_vector(3 downto 0);
        decenasBase  : out std_logic_vector(3 downto 0)
    );
end entity;

architecture comportamiento of temporizador_base is
    signal cuentaBase : unsigned(5 downto 0); 
begin
    process (relojBase, resetBase) --proceso sencible a la señal de 1hz y al resed
    begin
	 --if que evalua si el botón de reset está activo, en siui caso vuleve todo a cero
        if resetBase = '1' then
            cuentaBase <= (others => '0');
            alarmaBase <= '0';
            premioBase <= '0';
            activaCobro <= '0';
            
        elsif relojBase'event and relojBase = '1' then --si no, evalua en cada falnco de subida del reloj de 1hz
            if sensorBase = '1' then -- evalua si está ocuopado el espacio
                premioBase <= '0';  --mantiene el led de felicitaciones en cero
                if cuentaBase = 35 then --a penaslleue a 35 se manda la alerta y la señal para que el contador de exceso se active
                    alarmaBase <= '1';       
                    activaCobro <= '1'; --manda alerta y señal de activación
                else
                    cuentaBase <= cuentaBase + 1; --en caso de que no hayán pasado los 35 solamente se sigue manteniendo la señal de alerta en cero así como el led de felicitaciones
                    alarmaBase <= '0'; 
                    activaCobro <= '0';
                end if;
            else -- si el puesto se desocupó en el tiempo impuestoi, entomces se manda el led de felicitaciones y se coloca todo el cero nuevamente
                if cuentaBase > 0 and cuentaBase < 35 then
                    premioBase <= '1'; 
                else
                    premioBase <= '0'; --se mantiene el led apagado i no ocurre lo planeado
                end if;
                cuentaBase <= (others => '0');-- vuelve todo a cero para volvre ea esperar la siguiente persona
                alarmaBase <= '0';
                activaCobro <= '0';
            end if;
        end if;
    end process;
    
    unidadesBase <= std_logic_vector(to_unsigned(to_integer(cuentaBase) mod 10, 4));
    decenasBase  <= std_logic_vector(to_unsigned((to_integer(cuentaBase) / 10) mod 10, 4));
end architecture;