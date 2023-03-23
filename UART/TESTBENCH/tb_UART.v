`timescale 1 ns/1 ns

module tb_UART;
	reg clk, rst;
	reg in;
	reg clkinVGA;
	reg c_valid;
	reg [1:0]c_addr;
	reg [7:0]c_data;
	wire c_ready;
  wire [3:0]error;
  wire ready_error;
  wire [7:0]out;
  wire ready_out;
	
	UART UART_INSTANCE(.clk(clk), .rst(rst),
					.in(in), .clkinVGA(clkinVGA),
					.c_valid(c_valid), .c_addr(c_addr),
					.c_data(c_data), .c_ready(c_ready),
					.error(error), .ready_error(ready_error),
					.out(out), .ready_out(ready_out)
					);	
	
	integer i;
	reg [15:0]x;
	
	initial begin
		in = 0;
		x = 0;
		c_addr = 0;
		c_data = 0;
		c_valid = 0;
		i = 0;
	
		write_data(16'b1111101110100111);
		write_data(16'b1111111010101010);
		write_data(16'b1111010101001111);
		write_data(16'b1111111111111110);
		write_data(16'b1111111000000000);
	end
	
	task write_data;
	  input [15:0] data;
	  begin
		  #($urandom_range(1,63));
	    for(i = 0; i < 16; i = i + 1) begin
	      in = data[i];
		    #64;
		  end
	  end
	endtask
	
	initial begin
		rst = 1'b1;
		#7;
		rst = 1'b0;
	end

	initial begin
    clk = 1'b1;
    forever begin
      #2;
      clk = !clk;
    end  
  end
  
	initial begin
    clkinVGA = 1'b1;
    forever begin
      #36;
      clkinVGA = !clkinVGA;
    end  
  end
  
  initial
	 #6000 $finish;
endmodule