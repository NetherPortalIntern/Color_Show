`timescale 1 ns/10 ps  
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
// Module Name:   Config  
// 	This module provides parameters for the other modules that forms the VGA_Control module.
//When the configuration bus has a new configuration for the VGA_Control, the registers containing information for 
//a specific resolution are changed according to https://web.mit.edu/6.111/www/s2004/NEWKIT/vga.shtml, 60Hz ones. 
//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
`define R6X4  2'b00
`define R8X6  2'b01
`define R10X7 2'b10
`define VGA_ADRESS 2'b10
`define ACTIVE 1'b1

module Config
	#(`include "Width_Parameters.v")
	(input Clk,
	input Rst,
	input Valid,
	input [CONFIG_WIDTH-1:0] Addr,
	input [CONFIG_WIDTH-1:0] Data,
	output Load_config,
	output [PORCH_WIDTH-1:0]  H_front_porch,
	output [PORCH_WIDTH-1:0]  H_back_porch,
	output [PORCH_WIDTH-1:0]  V_front_porch,
	output [PORCH_WIDTH-1:0]  V_back_porch,
	output [REZ_MAX_WIDTH-1:0]  H_count_max,
	output [PULSE_WIDTH-1:0]  H_sync_pulse,
	output [REZ_MAX_WIDTH-1:0]  V_count_max,
	output [PULSE_WIDTH-1:0]  V_sync_pulse);
		
	`include "Parameters.v"

	reg 							Load_reg, Load_nxt;
	reg		[PORCH_WIDTH-1:0]		H_Front_Porch_reg, H_Front_Porch_nxt;
	reg 	[PORCH_WIDTH-1:0]		V_Front_Porch_reg, V_Front_Porch_nxt;
	reg		[PORCH_WIDTH-1:0] 		H_Back_Porch_reg, H_Back_Porch_nxt;
	reg		[PORCH_WIDTH-1:0] 		V_Back_Porch_reg, V_Back_Porch_nxt;
	reg     [PULSE_WIDTH-1:0]  		H_Sync_Pulse_reg, H_Sync_Pulse_nxt;
	reg     [PULSE_WIDTH-1:0]  		V_Sync_Pulse_reg, V_Sync_Pulse_nxt;
	reg     [REZ_MAX_WIDTH-1:0] 	H_Count_Max_reg, H_Count_Max_nxt;
	reg     [REZ_MAX_WIDTH-1:0]  	V_Count_Max_reg, V_Count_Max_nxt;
	
	always@(posedge Clk or negedge Rst)
	begin
		if(Rst==0)
		begin
			Load_reg    		<= 1;
			H_Front_Porch_reg   <= H_Front_Porch_RD;
			V_Front_Porch_reg   <= V_Front_Porch_RD;
			H_Back_Porch_reg    <= H_Back_Porch_RD;
			V_Back_Porch_reg	<= V_Back_Porch_RD;
			H_Sync_Pulse_reg  	<= H_Sync_Pulse_RD;
			V_Sync_Pulse_reg  	<= V_Sync_Pulse_RD;
			H_Count_Max_reg 	<= H_Count_Max_RD;
			V_Count_Max_reg 	<= V_Count_Max_RD;
		end
		else
		begin
			Load_reg    		<= Load_nxt;
			H_Front_Porch_reg   <= H_Front_Porch_nxt;
			V_Front_Porch_reg   <= V_Front_Porch_nxt;
			H_Back_Porch_reg    <= H_Back_Porch_nxt;
			V_Back_Porch_reg	<= V_Back_Porch_nxt;
			H_Sync_Pulse_reg  	<= H_Sync_Pulse_nxt;
			V_Sync_Pulse_reg  	<= V_Sync_Pulse_nxt;
			H_Count_Max_reg 	<= H_Count_Max_nxt;
			V_Count_Max_reg 	<= V_Count_Max_nxt;
		end
	end
	
	always @*
	begin
		if(Addr ==`VGA_ADRESS && Valid == `ACTIVE)
		begin	
			case (Data)	
				`R6X4:
				begin
					//bring proper parameters and set de Load
					H_Front_Porch_nxt   <= H_Front_Porch_RD;
					V_Front_Porch_nxt   <= V_Front_Porch_RD;
					H_Back_Porch_nxt    <= H_Back_Porch_RD;
					V_Back_Porch_nxt	<= V_Back_Porch_RD;
					H_Sync_Pulse_nxt  	<= H_Sync_Pulse_RD;
					V_Sync_Pulse_nxt  	<= V_Sync_Pulse_RD;
					H_Count_Max_nxt 	<= H_Count_Max_RD;
					V_Count_Max_nxt 	<= V_Count_Max_RD;
					Load_nxt    		<= 1;
				end
				
				`R8X6:
				begin
					//bring proper parameters and set de Load 
					H_Front_Porch_nxt 	= H_Back_Porch_R8x6;
					V_Front_Porch_nxt	= V_Front_Porch_R8x6;
					H_Back_Porch_nxt	= H_Back_Porch_R8x6;
					V_Back_Porch_nxt 	= V_Back_Porch_R8x6;
					H_Sync_Pulse_nxt 	= H_Sync_Pulse_R8x6; 
					V_Sync_Pulse_nxt 	= V_Sync_Pulse_R8x6; 
					H_Count_Max_nxt 	= H_Count_Max_R8x6;
					V_Count_Max_nxt 	= V_Count_Max_R8x6;
					Load_nxt			= 1;
				end
		
				`R10X7:
				begin
					//bring proper parameters and set de Load
					H_Front_Porch_nxt 	= H_Back_Porch_R10x7;
					V_Front_Porch_nxt	= V_Front_Porch_R10x7;
					H_Back_Porch_nxt	= H_Back_Porch_R10x7;
					V_Back_Porch_nxt 	= V_Back_Porch_R10x7;
					H_Sync_Pulse_nxt 	= H_Sync_Pulse_R10x7; 
					V_Sync_Pulse_nxt 	= V_Sync_Pulse_R10x7; 
					H_Count_Max_nxt 	= H_Count_Max_R10x7;
					V_Count_Max_nxt 	= V_Count_Max_R10x7;
					Load_nxt			= 1;
				end	
			endcase
		end
		else
		begin
			H_Front_Porch_nxt   <= H_Front_Porch_reg;
			V_Front_Porch_nxt   <= V_Front_Porch_reg;
			H_Back_Porch_nxt    <= H_Back_Porch_reg;
			V_Back_Porch_nxt	<= V_Back_Porch_reg;
			H_Sync_Pulse_nxt  	<= H_Sync_Pulse_reg;
			V_Sync_Pulse_nxt  	<= V_Sync_Pulse_reg;
			H_Count_Max_nxt 	<= H_Count_Max_reg;
			V_Count_Max_nxt 	<= V_Count_Max_reg; 
			Load_nxt    		<= 0;
		end
		
		if(Load_reg == 1)
			Load_nxt = 0;
	end
	
	
	assign Load_config   = Load_reg;
	assign H_front_porch = H_Front_Porch_reg;
	assign H_back_porch  = H_Back_Porch_reg;
	assign V_front_porch = V_Front_Porch_reg;
	assign V_back_porch  = V_Back_Porch_reg;
	assign H_count_max   = H_Count_Max_reg;
	assign H_sync_pulse  = H_Sync_Pulse_reg;
	assign V_count_max   = V_Count_Max_reg;
	assign V_sync_pulse  = V_Sync_Pulse_reg;

	
	endmodule
