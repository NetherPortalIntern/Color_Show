`timescale 1 ns/1 ns

module tb_Counter;
  reg clk, rst;
  reg [31:0]limit;
  wire clkout;
	
	Counter cnt(
	.clk(clk), .rst(rst), 
	.limit(limit),
	.clkout(clkout)
	);	
	
	localparam WAIT_2 = 2;
	localparam WAIT_4 = 4;
	localparam WAIT_8 = 8;
	
	initial begin
	  limit = 0;
	  #16;
	  limit = 10;
	  
	  #50;
	  limit = 13;
	  
	  #81;
	  rst = 1;
	  limit = 7;
	  
	  #4;
	  rst = 0;
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
	 #200 $finish;
endmodule