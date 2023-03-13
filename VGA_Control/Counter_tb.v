`timescale 1 ns/10 ps 

module Counter_tb
#(`include "Width_Parameters.v");

	parameter CLK_PERIOD     = 4;
	parameter RST_DURATION 	 = 4;
	parameter WAIT 		     = 20;
	
	reg 						Clk;
	reg 						Rst;
	reg   [REZ_WIDTH-1:0] 		Count_activ;
	reg   [REZ_MAX_WIDTH-1:0] 	Count_max;
	wire  						Counter_sync;
	wire  [REZ_MAX_WIDTH-1:0] 	CounterP;
	
	
	Counter counter(.Clk(Clk),
					.Rst(Rst),
					.Count_activ(Count_activ),
					.Count_max(Count_max), 
					.Counter_sync(Counter_sync),
					.CounterP(CounterP));
					
					
	initial 
	begin
		Clk = 1'b0;
		forever #(CLK_PERIOD/2) Clk = ~Clk;
	end
				
	initial
	begin
		Rst = 1'b1;
		#RST_DURATION 
		Rst = 1'b0;
	end
	
	
	initial
	begin
		Count_activ = 11'b00000000000;
		Count_max   = 12'b000000000000;
		
		#WAIT
		Count_activ = 11'b01010000000;  //640
		Count_max   = 12'b001100100000; // 800
		
		#WAIT
		Count_activ = 11'b10000000000;  //1024
		Count_max   = 12'b010010100000;   //1184
	end
	
	


	//$monitor ("[$monitor] time=%0T Count_activ=%d Count_max=%d Counter_sync=%d CounterP=%d", $time, Count_activ, Count_max, Counter_sync, CounterP);

	
endmodule

