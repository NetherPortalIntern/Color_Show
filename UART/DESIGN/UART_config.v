/*
---UART CONFIGURATION MODULE---

The module is connected to a configuration bus, which contains an address, data, ready and valid.
UART configuration variants:
   - PARITY: 00-NONE (default), 10-EVEN, 11-ODD
   - STOP: 0-1 BIT (default), 1-2 BITS
*/

`timescale 1 ns/1 ns

module UART_config
  #(`include "UART_width.v")
(
input clk,
input rst,

input  [WIDTH_CONFIG_ADDR-1:0]c_addr, // 01 - UART, 10 - VGA
input  c_valid,                       // 1 - bun, 0 - rau
input  [WIDTH_CONFIG_DATA-1:0]c_data, // configuratia
output c_ready,                       // 0 - liber, 1 - ocupat

output parity_config, // 0 - no parity, 1 - parity
output stopbit_config    // 0 - 1 bit, 1 - 2 bits
);

`include "UART_param.v"

reg [WIDTH_PARITY-1:0]parity_reg, parity_next;
reg stopbit_configs_reg, stopbit_configs_next;
reg c_ready_reg, c_ready_next;

always @(posedge clk, negedge rst) begin
	if(rst) begin
		parity_reg <= parity_config_NONE;
		stopbit_configs_reg <= stopbit_configS_1;
		c_ready_reg <= 1'b1;
	end
	else begin
		parity_reg <= parity_next;
		stopbit_configs_reg <= stopbit_configs_next;
		c_ready_reg <= c_ready_next;
	end
end

always @(*) begin
	parity_next = parity_reg;
	stopbit_configs_next = stopbit_configs_reg;
	c_ready_next = c_ready_reg;
	if(c_addr == 2'b01 && c_valid) begin
		case(c_data[6:2])
			5'b01000: begin
				parity_next = parity_config_NONE;
				c_ready_next = 1'b1;
			end
			5'b01001: begin
				parity_next = parity_config_ODD;
				c_ready_next = 1'b1;
			end
			5'b01010: begin
				parity_next = parity_config_EVEN;
				c_ready_next = 1'b1;
			end
			5'b10000: begin
				stopbit_configs_next = stopbit_configS_1;
				c_ready_next = 1'b1;
			end
			5'b10001: begin
				stopbit_configs_next = stopbit_configS_2;
				c_ready_next = 1'b1;
			end
			default:begin
		    c_ready_next = 1'b0;
			end
		endcase
	end
	else begin
		c_ready_next = 1'b0;
	end
end

assign parity_config = parity_reg;
assign stopbit_config = stopbit_configs_reg;
assign c_ready = c_ready_reg;

endmodule
