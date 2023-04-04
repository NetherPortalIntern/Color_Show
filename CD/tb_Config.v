`timescale 1 ns/1 ns

module tb_config;
	reg clk, rst;
	reg c_valid;
	reg [1:0]c_addr;
	reg [7:0]c_data;
	wire c_VGA_ready;
	wire c_UART_ready;
	wire [31:0]baudrate;
	wire [31:0]resolution;
	
	Config CLK_DIVIDER_CONFIG(.clk(clk), .rst(rst),
					.c_valid(c_valid), .c_addr(c_addr), .c_data(c_data), 
					.c_VGA_ready(c_VGA_ready), .c_UART_ready(c_UART_ready),
					.baudrate(baudrate), .resolution(resolution));	
					
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
		#16;
		c_addr = 2'b00;
		c_valid = 1'b1;
		
		#152;
		c_addr = 2'b01;
		c_data[4:2] = 3'b011;
		
		#72;
		c_valid = 1'b0;
		
		#37;
		c_addr = 2'b10;
		c_data[4:2] = 3'b101;
		c_valid = 1'b1;
		
		#72;
		c_valid = 1'b0;
		
		#740;
		c_addr = 2'b10;
		c_data[4:2] = 3'b000;
		c_valid = 1'b1;
		
		#7;
		c_valid = 1'b0;
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
	 #1000 $finish;
endmodule
