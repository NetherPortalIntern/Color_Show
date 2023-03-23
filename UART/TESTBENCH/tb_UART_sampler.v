`timescale 1 ns/1 ns

module tb_UART_sampler;
  reg clk, rst;
  reg in;
  wire out, valid;
  	
	UART_sampler SAMPLER(
	.clk(clk), .rst(rst), 
	.in(in),
	.out(out), .valid(valid)
	);	
	
	reg [14:0]x;
	integer i = 0;
					
	localparam WAIT_2 = 2;
	localparam WAIT_4 = 4;
	localparam WAIT_8 = 8;
	
	initial begin
	  in = 1'b0;
	  x = 16'b1111111111111111;
	  #WAIT_8;
	  
	  x = 16'b000000000000000;
	  for(i = 0; i <= 15; i = i + 1) begin
	    in = x[i];
	    #WAIT_4;
	  end
	  
	  x = 16'b100001000000001;
	  for(i = 0; i <= 15; i = i + 1) begin
	    in = x[i];
	    #WAIT_4;
	  end
	  
	  x = 16'b010100101010101;
	  for(i = 0; i <= 15; i = i + 1) begin
	    in = x[i];
	    #WAIT_4;
	  end
	  
	  x = 16'b101111011111011;
	  for(i = 0; i <= 15; i = i + 1) begin
	    in = x[i];
	    #WAIT_4;
	  end
	  
	  x = 16'b111111111111111;
	  for(i = 0; i <= 15; i = i + 1) begin
	    in = x[i];
	    #WAIT_4;
	  end 		
	  
	  x = 16'b101111011111011;
	  for(i = 0; i <= 15; i = i + 1) begin
	    in = x[i];
	    #WAIT_4;
	  end
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
	 #440 $finish;
endmodule

