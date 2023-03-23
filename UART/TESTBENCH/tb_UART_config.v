`timescale 1 ns/1 ns

module tb_UART_config;
	reg clk, rst;
	reg c_valid;
	reg [1:0]c_addr;
	reg [7:0]c_data;
	wire c_ready;
	wire [1:0]paritybit;
	wire stopbit;
	
	UART_config UART_CONFIG(.clk(clk), .rst(rst),
					.c_valid(c_valid), .c_addr(c_addr),
					.c_data(c_data), .c_ready(c_ready),
					.paritybit(paritybit), .stopbit(stopbit));	
					
	localparam WAIT_2 = 2;
	localparam WAIT_4 = 4;
	localparam WAIT_8 = 8;
	localparam WAIT_16 = 16;
		
	initial begin
	  // begining
		c_addr = 2'b01;
		c_data = 8'b00000000;
		c_valid = 1'b0;
		
		// wrong adress
		#WAIT_16;
		c_addr = 2'b00;
		c_valid = 1'b1;
		
		// wrong adress
		#WAIT_4;
		c_addr = 2'b11;
		
		// wrong adress
		#WAIT_4;
		c_addr = 2'b10;
		
		// parity change
		#WAIT_4;
		c_addr = 2'b01;
		c_data = 8'b10100000;

		// parity change
		#WAIT_4;
		c_data = 8'b00100100;
		
		// parity change
		#WAIT_4;
		c_data = 8'b00101010;
		
		// no valid
		#WAIT_4;
		c_data = 8'b00100010;
		c_valid = 1'b0;
		
		// stop bit change
		#WAIT_4;
		c_data = 8'b11000100;
		c_valid = 1'b1;

		// stop bit change
		#WAIT_4;
		c_data = 8'b01000000;
		
		// no change
		#WAIT_4;
		c_data = 8'b00000000;
		
		// wrong adress
		#WAIT_4;
		c_addr = 2'b10;
		c_data = 8'b00100010;
	end
	
	initial begin
		rst = 1'b1;
		#WAIT_8;
		rst = 1'b0;
	end

	initial begin
    clk = 1'b1;
    forever begin
      #WAIT_2;
      clk = !clk;
    end  
  end
  
  initial
	 #70 $finish;
endmodule