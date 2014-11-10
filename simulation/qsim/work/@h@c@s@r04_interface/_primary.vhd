library verilog;
use verilog.vl_types.all;
entity HCSR04_interface is
    port(
        clk             : in     vl_logic;
        n_rst           : in     vl_logic;
        echo_in         : in     vl_logic;
        trigger_out     : out    vl_logic;
        binary_distance : out    vl_logic_vector(11 downto 0)
    );
end HCSR04_interface;
