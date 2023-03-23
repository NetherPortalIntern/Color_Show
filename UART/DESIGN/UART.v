/*
---UART---

The module is formed by:
   - UART_CONFIGURATION: handles the configuration of the UART module parameters (STOPBITS and PARITYBIT)
   - UART_OVERSAMPLING: handles the oversampling of the asynchronous received data.
   - UART_STATE: checks the UART protocol and sends out errors and data.
*/

`timescale 1 ns/1 ns

module UART
#(`include "UART_width.v")
(
input clk,
input rst,

input clkinVGA,

input in,

input [WIDTH_CONFIG_ADDR-1:0]c_addr, // 01 - UART, 10 - VGA
input c_valid, // 1 - bun, 0 - rau
input [WIDTH_CONFIG_DATA-1:0]c_data, // configuratia
output c_ready, // 0 - liber, 1 - ocupat

output [WIDTH_ERROR-1:0]error,
output ready_error,

output [WIDTH_DATABITS-1:0]out,
output ready_out
);

`include "UART_param.v"

wire [WIDTH_PARITY-1:0]paritybit;
wire stopbit;

wire data;
wire valid_data;

UART_config UART_CONFIG(.clk(clkinVGA), .rst(rst),
					.c_valid(c_valid), .c_addr(c_addr),
					.c_data(c_data), .c_ready(c_ready),
					.paritybit(paritybit), .stopbit(stopbit));	

UART_state UART_STATE(.clk(clk), .rst(rst|c_ready),
					.data(data), .valid_data(valid_data),
					.error(error), .ready_error(ready_error),
					.out(out), .ready_out(ready_out),
					.paritybit(paritybit), .stopbit(stopbit));	
					
UART_sampler SAMPLER(.clk(clk), .rst(rst), .in(in),
	        .out(data), .valid(valid_data));
endmodule