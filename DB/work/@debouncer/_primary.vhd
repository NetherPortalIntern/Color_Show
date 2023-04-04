library verilog;
use verilog.vl_types.all;
entity Debouncer is
    generic(
        WIDTH           : integer := 4
    );
    port(
        clk             : in     vl_logic;
        button          : in     vl_logic;
        \signal\        : out    vl_logic
    );
end Debouncer;
