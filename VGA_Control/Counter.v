`timescale 1 ns/10 ps 
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
// Module Name:   Config  
// 	This module provides parameters for the other modules that forms the VGA_Control module.
//When the configuration bus has a new configuration for the VGA_Control, the registers containing information for 
//a specific resolution are changed according to https://web.mit.edu/6.111/www/s2004/NEWKIT/vga.shtml, 60Hz ones. 
//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
`define HIGH 1'b1
`define LOW 1'b0
module Counter
	#(`include "Width_Parameters.v")
	(input Clk,
	input Rst,
	input [REZ_WIDTH-1:0] Count_activ,
	input [REZ_MAX_WIDTH-1:0] Count_max,
	output  Counter_sync,
	output  [REZ_MAX_WIDTH-1:0] CounterP);

	reg								Sync_State_reg, Sync_State_nxt;	
	reg		[REZ_MAX_WIDTH-1:0]  	Count_reg, Count_nxt;
	
	always@(posedge Clk or negedge Rst)
	begin
		if(Rst == `LOW)
		begin
			Sync_State_reg	<= `LOW;
			Count_reg		<= `LOW;
		end
		else
		begin
			Sync_State_reg	<= Sync_State_nxt;
			Count_reg		<= Count_nxt;
		end
	end
	
	always@*
	begin
		Sync_State_nxt = Sync_State_reg;
		Count_nxt = Count_nxt;
		
		if(Count_reg < Count_max)
			Count_nxt = Count_reg+1;
		else
			Count_nxt = `LOW;
			
		if(Count_reg >= Count_max-Count_activ)
			Sync_State_nxt = `HIGH;
		else
			Sync_State_nxt = `LOW;
	end
	
	assign Counter_sync	= Sync_State_reg;
	assign CounterP		= Count_reg;
	
endmodule