library verilog;
use verilog.vl_types.all;
entity RS232_vlg_sample_tst is
    port(
        binary_dist     : in     vl_logic_vector(11 downto 0);
        clk             : in     vl_logic;
        n_rst           : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end RS232_vlg_sample_tst;
