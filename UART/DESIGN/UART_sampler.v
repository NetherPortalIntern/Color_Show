/*
---UART SAMPLER MODULE---

The module is tasked with oversampling UART received data.
The module is formed from a 4-bit counter which takes 16 samples from the received data.
If the majority of the samples are the same then the output is validated.
*/

`timescale 1 ns/1 ns

module UART_sampler
#(`include "UART_width.v")
(
input clk,
input rst,

input in,

output out,
output valid
);

`include "UART_param.v"

reg [WIDTH_SAMPLING_DATA-1:0]nr_0_reg, nr_0_next;
reg [WIDTH_SAMPLING_DATA-1:0]nr_1_reg, nr_1_next;
reg [WIDTH_SAMPLING_DATA-1:0]val_reg, val_next;

reg [1:0]state_reg, state_next;

parameter START = 2'b00;
parameter SAMPLE = 2'b01;
parameter DONE = 2'b10;

reg out_reg, out_next;
reg valid_reg, valid_next;

always @(posedge clk or negedge rst) begin
	if(rst) begin
		nr_0_reg <= 0;
		nr_1_reg <= 0;
		val_reg <= 0;
		out_reg <= 1'b0;
		valid_reg <= 1'b0;
		state_reg <= SAMPLE;
	end
	else begin
		nr_0_reg <= nr_0_next;
		nr_1_reg <= nr_1_next;
		val_reg <= val_next;
		out_reg <= out_next;
		valid_reg <= valid_next;
		state_reg <= state_next;
	end
end

always @(*) begin
	nr_0_next = nr_0_reg;
	nr_1_next = nr_1_reg;
	val_next = val_reg;
	out_next = out_reg;
	valid_next = valid_reg;
	state_next = state_reg;
	
	case(state_reg)
	  SAMPLE: begin
	    if(val_reg==14) begin
	      valid_next = 1'b1;
	      if(nr_0_reg>=nr_1_reg) out_next = 1'b0;
	      else out_next = 1'b1;
	      state_next = DONE;
	    end
	    else begin
	      val_next = val_reg + 1;
	      if(val_reg>=SAMPLE_LIMIT_LOW && val_reg<=SAMPLE_LIMIT_HIGH - 1) begin
	        if(in) nr_1_next = nr_1_reg + 1;
	        else nr_0_next = nr_0_reg + 1;
	      end
	    end
	  end
	  DONE: begin
	    val_next = 0;
	    nr_0_next = 0;
	    nr_1_next = 0;
	    valid_next = 1'b0;
	    state_next = SAMPLE;
	  end
	endcase
end

assign out = out_reg;
assign valid = valid_reg;

endmodule