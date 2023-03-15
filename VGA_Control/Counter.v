`timescale 1 ns/10 ps 
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
// Module Name:   Config  
// 	This module provides parameters for the other modules that forms the VGA_Control module.
//When the configuration bus has a new configuration for the VGA_Control, the registers containing information for 
//a specific resolution are changed according to https://web.mit.edu/6.111/www/s2004/NEWKIT/vga.shtml, 60Hz ones. 
//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////

module Counter
	#(`include "Width_Parameters.v")
	(input Clk,
	input Rst,
	input [PULSE_WIDTH-1:0] Sync_pulse,
	input [REZ_MAX_WIDTH-1:0] Count_max,
	output  Counter_sync,
	output  [REZ_MAX_WIDTH-1:0] CounterP);

	reg							Sync_State_reg, Sync_State_nxt;	
	reg	[REZ_MAX_WIDTH-1:0]  	Count_reg, Count_nxt;
	
	always@(posedge Clk or negedge Rst)
	begin
		if(Rst == 0)
		begin
			Sync_State_reg	<= 0;
			Count_reg		<= 0;
		end
		else
		begin
			Sync_State_reg	<= Sync_State_nxt;
			Count_reg		<= Count_nxt;
		end
	end
	
	always@*
	begin
		Sync_State_nxt 	= Sync_State_reg;
		Count_nxt 		= Count_reg;
		
		if(Count_reg < Count_max)
		begin
			Count_nxt = Count_reg + 1;
			
			if(Count_reg > Sync_pulse)
				Sync_State_nxt = 1;
			else
				Sync_State_nxt = 0;
		end
		else
		begin 
			//end of the row or column
			Count_nxt 	   = 0;
			Sync_State_nxt = 0;
		end
	end
	
	assign Counter_sync	= Sync_State_reg;
	assign CounterP		= Count_reg;
	
endmodule