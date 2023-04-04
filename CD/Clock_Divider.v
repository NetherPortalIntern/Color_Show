/*
---CLOCK DIVIDER---

The module is formed by:
   - CLOCK DIVIDER CONFIGURATION MODULE: sets the limits for the counters
   -4 counters:
       -CLK VGA - clock for VGA and CM
       -CLK UART - clock for UART
       -CLK LM - clock for LM (1Hz)
       -CLK DB - clock for DB (20Hz)
*/

`timescale 1 ns/1 ns

module Clock_Divider
  #(`include "CD_params.v")
(
input clk,
input rst,

input clkinVGA,

input [WIDTH_CONFIG_ADDR-1:0]c_addr, // 01 - UART, 10 - VGA
input [WIDTH_CONFIG_DATA-1:0]c_data, // configuratia
input c_valid, // 1 - bun, 0 - rau
output c_ready, // 0 - liber, 1 - ocupat

output clk_VGA,
output clk_UART,
output clk_LM,
output clk_DB
);


`include "CLK_values.v"

wire c_VGA_ready;
wire c_UART_ready;
wire [WIDTH_UART_CLK_LIMIT-1:0]baudrate;
wire [WIDTH_VGA_CLK_LIMIT-1:0]resolution;

Counter #(.WIDTH(WIDTH_VGA_CLK_LIMIT)) CNT_VGA(.clk(clk), .rst(c_VGA_ready|rst), .limit(resolution), .clkout(clk_VGA));	
Counter #(.WIDTH(WIDTH_UART_CLK_LIMIT)) CNT_UART(.clk(clk), .rst(c_UART_ready|rst), .limit(baudrate), .clkout(clk_UART));	
Counter #(.WIDTH(WIDTH_LED_MANAGER_CLK_LIMIT)) CNT_LM(.clk(clk), .rst(rst), .limit(CLK_LED_MANAGER), .clkout(clk_LM));	
Counter #(.WIDTH(WIDTH_DEBOUNCER_CLK_LIMIT)) CNT_DB(.clk(clk), .rst(rst), .limit(CLK_DEBOUNCER), .clkout(clk_DB));	

Config CLOCK_DIVIDER_CONFIG(.clk(clkinVGA), .rst(rst),
					.c_valid(c_valid), .c_addr(c_addr), .c_data(c_data),
					.c_VGA_ready(c_VGA_ready), .c_UART_ready(c_UART_ready),
					.baudrate(baudrate), .resolution(resolution));		
			
assign c_ready = c_VGA_ready | c_UART_ready;
		
endmodule