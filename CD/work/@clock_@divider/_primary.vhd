library verilog;
use verilog.vl_types.all;
entity Clock_Divider is
    generic(
        WIDTH_CONFIG_ADDR: integer := 4;
        WIDTH_CONFIG_DATA: integer := 8;
        WIDTH_UART_CLK_LIMIT: integer := 24;
        WIDTH_VGA_CLK_LIMIT: integer := 32;
        WIDTH_LED_MANAGER_CLK_LIMIT: integer := 32;
        WIDTH_DEBOUNCER_CLK_LIMIT: integer := 32;
        CLK_MAX_WIDTH   : integer := 32
    );
    port(
        clk             : in     vl_logic;
        rst             : in     vl_logic;
        clkinVGA        : in     vl_logic;
        c_addr          : in     vl_logic_vector;
        c_data          : in     vl_logic_vector;
        c_valid         : in     vl_logic;
        c_ready         : out    vl_logic;
        clk_VGA         : out    vl_logic;
        clk_UART        : out    vl_logic;
        clk_LM          : out    vl_logic;
        clk_DB          : out    vl_logic
    );
end Clock_Divider;
