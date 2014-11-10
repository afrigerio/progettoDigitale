library verilog;
use verilog.vl_types.all;
entity HCSR04_interface_vlg_sample_tst is
    port(
        clk             : in     vl_logic;
        echo_in         : in     vl_logic;
        n_rst           : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end HCSR04_interface_vlg_sample_tst;
