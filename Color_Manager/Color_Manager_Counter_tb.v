`timescale 1 ns/1 ns
//The testbench for the Color_Manager's Counter module.
module Color_Manager_Counter_tb
#(`include "Color_Manager_Width_Parameters.v");

	parameter CLK_F     	 = 2;
	parameter RST_DURATION 	 = 4;
	parameter WAIT 		     = 100;
	
	reg 						 	Clk;
	reg 						 	Rst;
	reg [BACKPORCH_WIDTH-1:0]  	BackPorch;
	reg [FRONTPORCH_WIDTH-1:0] 	FrontPorch;
	reg 						 	Sync;
	wire Counter_Valid;
	wire  [FRONTPORCH_WIDTH-1:0] 	CounterP;
	

	
	Color_Manager_Counter counterCM(.Clk(Clk),
					 .Rst(Rst),
					 .BackPorch(BackPorch),
					 .FrontPorch(FrontPorch), 
					 .Sync(Sync),
					 .Counter_Valid(Counter_Valid),
					 .CounterP(CounterP));
					
					
	initial 
	begin
		Clk = 1'b1;
		forever #CLK_F Clk = ~Clk;
	end
				
	initial
	begin
		Rst = 1'b1;
		#RST_DURATION 
		Rst = 1'b0;
	end
	
	
	initial
	begin
		BackPorch ='b1; //1
		FrontPorch ='b1000; //8
		Sync=1'b0;
		
		#WAIT
		Sync=1'b1;
		
		#WAIT
		Sync=1'b0;
		
		#WAIT
		Sync=1'b1;
		
		#WAIT
		Sync=1'b0;
		
		#WAIT
		Sync=1'b1;
		
		#WAIT
		Sync=1'b0;
		
		
	end
	
endmodule

