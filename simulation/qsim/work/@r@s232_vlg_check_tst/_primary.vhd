library verilog;
use verilog.vl_types.all;
entity RS232_vlg_check_tst is
    port(
        tx              : in     vl_logic;
        sampler_rx      : in     vl_logic
    );
end RS232_vlg_check_tst;
