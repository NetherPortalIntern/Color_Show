library verilog;
use verilog.vl_types.all;
entity DB is
    port(
        clk             : in     vl_logic;
        btnHS           : in     vl_logic;
        btnVS           : in     vl_logic;
        btnDF_UART      : in     vl_logic;
        btnDF_VGA       : in     vl_logic;
        HS              : out    vl_logic;
        VS              : out    vl_logic;
        DF_UART         : out    vl_logic;
        DF_VGA          : out    vl_logic
    );
end DB;
