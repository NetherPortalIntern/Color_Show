// TASK PENTRU TRIMISULDATELOR - primeste numarul pe 16 biti

// functie - !nu poti pune intarzieri => creeaza nr x cu random (poti sa creezi ponderi pentru AA5500FF si alte numere)

`timescale 1 ns/1 ns

module tb_UART_state;
	reg clk, rst;
	reg data, valid_data;
	wire [3:0]error;
	wire ready_error;
	wire [7:0]out;
	wire ready_out;
	reg [1:0]paritybit;
	reg stopbit;
	
	UART_state UART_STATE(.clk(clk), .rst(rst),
					.data(data), .valid_data(valid_data),
					.error(error), .ready_error(ready_error),
					.out(out), .ready_out(ready_out),
					.paritybit(paritybit), .stopbit(stopbit)
					);	
					
	localparam WAIT_2 = 2;
	localparam WAIT_4 = 4;
	localparam WAIT_8 = 8;
	localparam WAIT_16 = 16;
	
	integer i;
	reg [15:0]x;
	
	initial begin
		paritybit = 0;
		stopbit = 0;
		data = 1;
		x = 16'b1111111111111111;
		valid_data = 1;
		
		#($urandom_range(1,63));
		#WAIT_8;
		x = 16'b1111011101010011; // good trasmision
		for(i = 0; i < 16; i = i + 1) begin
	    data = x[i];
		  #WAIT_4;
		end
		
		#WAIT_8;
		x = 16'b1110011101010011; // wrong stop bit
		for(i = 0; i < 16; i = i + 1) begin
	    data = x[i];
		  #WAIT_4;
		end
		
		#WAIT_8;
		x = 16'b1111000000000011; // data = 0
		for(i = 0; i < 16; i = i + 1) begin
	    data = x[i];
		  #WAIT_4;
		end
		
		#WAIT_8;
		x = 16'b1111111111110011; // data = 255
		for(i = 0; i < 16; i = i + 1) begin
	    data = x[i];
		  #WAIT_4;
		end
		
		#WAIT_8;
		paritybit = 1;
		x = 16'b1110101011000011; // parity even - correct
		for(i = 0; i < 16; i = i + 1) begin
	    data = x[i];
		  #WAIT_4;
		end
		
		#WAIT_8;
		x = 16'b1110101011010011; // parity even - wrong
		for(i = 0; i < 16; i = i + 1) begin
	    data = x[i];
		  #WAIT_4;
		end
		
		#WAIT_8;
		paritybit = 2;
		x = 16'b1110101011010011; // parity odd - correct
		for(i = 0; i < 16; i = i + 1) begin
	    data = x[i];
		  #WAIT_4;
		end
		
		#WAIT_8;
		x = 16'b1110101011000011; // parity odd - wrong
		for(i = 0; i < 16; i = i + 1) begin
	    data = x[i];
		  #WAIT_4;
		end
		
		#WAIT_8;
		paritybit = 1;
		stopbit = 1;
		x = 16'b1110101011000011; // parity even - correct, 2 stop bits - correct
		for(i = 0; i < 16; i = i + 1) begin
	    data = x[i];
		  #WAIT_4;
		end
		
		#WAIT_8;
		x = 16'b1100101011000011; // parity even - correct, 2 stop bits - first bit wrong
		for(i = 0; i < 16; i = i + 1) begin
	    data = x[i];
		  #WAIT_4;
		end
		
		#WAIT_8;
		x = 16'b1010101011000011; // parity even - correct, 2 stop bits - second bit wrong
		for(i = 0; i < 16; i = i + 1) begin
	    data = x[i];
		  #WAIT_4;
		end
		
		#WAIT_8;
		x = 16'b1110101011010011; // parity even - wrong, 2 stop bits - correct
		for(i = 0; i < 16; i = i + 1) begin
	    data = x[i];
		  #WAIT_4;
		end
		
		#WAIT_8;
		x = 16'b1010101011010011; // parity even - wrong, 2 stop bits - wrong
		for(i = 0; i < 16; i = i + 1) begin
	    data = x[i];
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
	 #1000 $finish;
endmodule