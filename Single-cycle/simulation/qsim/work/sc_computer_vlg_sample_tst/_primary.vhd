library verilog;
use verilog.vl_types.all;
entity sc_computer_vlg_sample_tst is
    port(
        clock           : in     vl_logic;
        mem_clk         : in     vl_logic;
        resetn          : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end sc_computer_vlg_sample_tst;
