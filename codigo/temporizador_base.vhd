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
    process (relojBase, resetBase)
    begin
        if resetBase = '1' then
            cuentaBase <= (others => '0');
            alarmaBase <= '0';
            premioBase <= '0';
            activaCobro <= '0';
            
        elsif relojBase'event and relojBase = '1' then
            if sensorBase = '1' then
                premioBase <= '0'; 
                if cuentaBase = 35 then
                    alarmaBase <= '1';       
                    activaCobro <= '1'; 
                else
                    cuentaBase <= cuentaBase + 1; 
                    alarmaBase <= '0';
                    activaCobro <= '0';
                end if;
            else
                if cuentaBase > 0 and cuentaBase < 35 then
                    premioBase <= '1'; 
                else
                    premioBase <= '0';
                end if;
                cuentaBase <= (others => '0');
                alarmaBase <= '0';
                activaCobro <= '0';
            end if;
        end if;
    end process;
    
    unidadesBase <= std_logic_vector(to_unsigned(to_integer(cuentaBase) mod 10, 4));
    decenasBase  <= std_logic_vector(to_unsigned((to_integer(cuentaBase) / 10) mod 10, 4));
end architecture;