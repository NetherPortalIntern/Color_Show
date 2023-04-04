
/*
---CLOCK DIVIDER CONFIGURATION MODULE---

The configuration resets the counters for the UART/VGA clock. The addresses are: 
  01 - UART
  10 - VGA
The maximum value of the counters for the the UART/VGA clock are sent though baudrate and resolution.
*/

`timescale 1 ns/1 ns

module Config
  #(`include "CD_params.v")
(input clk,
input rst,

input [WIDTH_CONFIG_ADDR-1:0]c_addr, // 01 - UART, 10 - VGA
input [WIDTH_CONFIG_DATA-1:0]c_data, // configuratia
input c_valid, // 1 - bun, 0 - rau
output c_VGA_ready, // 0 - liber, 1 - ocupat
output c_UART_ready, // 0 - liber, 1 - ocupat

output [WIDTH_UART_CLK_LIMIT-1:0]baudrate,
output [WIDTH_VGA_CLK_LIMIT-1:0]resolution
);

`include "CS_params.v"
`include "CLK_values.v"

reg [WIDTH_VGA_CLK_LIMIT-1:0] resolution_reg, resolution_next;
reg [WIDTH_UART_CLK_LIMIT-1:0] baudrate_reg, baudrate_next;
reg c_VGA_ready_reg, c_VGA_ready_next;
reg c_UART_ready_reg, c_UART_ready_next;

always @(posedge clk or posedge rst) begin
	if(rst) begin
		resolution_reg <= CLK_VGA_640x480;
		baudrate_reg <= CLK_BAUDRATE_9600;
		c_VGA_ready_reg <= 1'b0;
		c_UART_ready_reg <= 1'b0;
	end
	else begin
		resolution_reg <= resolution_next;
		baudrate_reg <= baudrate_next;
		c_VGA_ready_reg <= c_VGA_ready_next;
		c_UART_ready_reg <= c_UART_ready_next;
	end
end

always @(*) begin
	resolution_next = resolution_reg;
	baudrate_next = baudrate_reg;
	c_VGA_ready_next = c_VGA_ready_reg;
	c_UART_ready_next = c_UART_ready_reg;
	
	c_VGA_ready_next = 1'b0;
  c_UART_ready_next = 1'b0;
	if(c_valid) begin
	  if(c_addr == UART_BAUDRATE_ADDR) begin // UART BAUD config
	    case(c_data[4:2])
	      BAUDRATE_2400: baudrate_next = CLK_BAUDRATE_2400;
	      BAUDRATE_4800: baudrate_next = CLK_BAUDRATE_4800;
	      BAUDRATE_9600: baudrate_next = CLK_BAUDRATE_9600;
	      BAUDRATE_19200: baudrate_next = CLK_BAUDRATE_19200;
	      BAUDRATE_57600: baudrate_next = CLK_BAUDRATE_57600;
	      BAUDRATE_112000: baudrate_next = CLK_BAUDRATE_112000;
	    endcase
		  c_UART_ready_next = 1'b1;
	  end
	  else if(c_addr == VGA_RESOLUTION_ADDR) begin // VGA config
		  case(c_data[4:3])
	      VGA_640x480: resolution_next = CLK_VGA_640x480;
	      VGA_800x600: resolution_next = CLK_VGA_800x600;
	      VGA_1024x768: resolution_next = CLK_VGA_1024x768;
	    endcase
		  c_VGA_ready_next = 1'b1;
	  end
	end
end

assign resolution = resolution_reg;
assign baudrate = baudrate_reg;
assign c_VGA_ready = c_VGA_ready_reg;
assign c_UART_ready = c_UART_ready_reg;

endmodule
