library verilog;
use verilog.vl_types.all;
entity HCSR04_interface_vlg_check_tst is
    port(
        binary_distance : in     vl_logic_vector(11 downto 0);
        trigger_out     : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end HCSR04_interface_vlg_check_tst;
