`timescale 1 ns/1 ns

module DB
(
input clk,

input btnHS,
input btnVS,
input btnDF_UART,
input btnDF_VGA,

output HS,
output VS,
output DF_UART,
output DF_VGA
);

Debouncer DB_HS(.clk(clk), .button(btnHS), .signal(HS));	
Debouncer DB_VS(.clk(clk), .button(btnVS), .signal(VS));	
Debouncer DB_DF_UART(.clk(clk), .button(btnDF_UART), .signal(DF_UART));	
Debouncer DB_DF_VGA(.clk(clk), .button(btnDF_VGA), .signal(DF_VGA));	

endmodule

