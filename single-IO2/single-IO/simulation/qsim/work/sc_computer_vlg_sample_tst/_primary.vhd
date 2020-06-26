library verilog;
use verilog.vl_types.all;
entity sc_computer_vlg_sample_tst is
    port(
        SW0             : in     vl_logic;
        SW1             : in     vl_logic;
        SW2             : in     vl_logic;
        SW3             : in     vl_logic;
        SW4             : in     vl_logic;
        SW5             : in     vl_logic;
        SW6             : in     vl_logic;
        SW7             : in     vl_logic;
        SW8             : in     vl_logic;
        SW9             : in     vl_logic;
        clk             : in     vl_logic;
        reset           : in     vl_logic;
        sampler_tx      : out    vl_logic
    );
end sc_computer_vlg_sample_tst;
