`timescale 1 ns/1 ns
//The testbench for the Config module.
module VGA_Counter_tb
#(`include "VGA_Width_Parameters.v");

	parameter CLK_F     	 = 2;
	parameter RST_DURATION 	 = 4;
	parameter WAIT 		     = 72;
	
	reg 						Clk;
	reg 						Rst;
	reg   [PULSE_WIDTH-1:0] 	Sync_pulse;
	reg   [REZ_MAX_WIDTH-1:0] 	Count_max;
	wire  						Counter_sync;
	wire  [REZ_MAX_WIDTH-1:0] 	CounterP;
	
	
	VGA_Counter counter(.Clk(Clk),
					.Rst(Rst),
					.Sync_pulse(Sync_pulse),
					.Count_max(Count_max), 
					.Counter_sync(Counter_sync),
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
		Sync_pulse = 'b1; //1
		Count_max   = 12'b000000001000;//8
		
		#WAIT
		Sync_pulse = 8'b01011110;  //94
		Count_max   = 12'b001100100000; // 800
		
	end
	
endmodule

