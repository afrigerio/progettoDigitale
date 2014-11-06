library verilog;
use verilog.vl_types.all;
entity progetto is
    port(
        HEX0            : out    vl_logic_vector(6 downto 0);
        CLOCK_50        : in     vl_logic;
        KEY             : in     vl_logic_vector(0 downto 0);
        SW              : in     vl_logic_vector(17 downto 0);
        HEX1            : out    vl_logic_vector(6 downto 0);
        HEX2            : out    vl_logic_vector(6 downto 0);
        HEX3            : out    vl_logic_vector(6 downto 0)
    );
end progetto;
