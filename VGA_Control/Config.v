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
`define HIGH 1'b1
`define LOW 1'b0

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
	output [REZ_WIDTH-1:0]  H_count_activ,
	output [REZ_MAX_WIDTH-1:0]  V_count_max,
	output [REZ_WIDTH-1:0]  V_count_activ);
		
	`include "Parameters.v"

	reg 							Load_reg, Load_nxt;
	reg		[PORCH_WIDTH-1:0]		H_Front_Porch_reg, H_Front_Porch_nxt;
	reg 	[PORCH_WIDTH-1:0]		V_Front_Porch_reg, V_Front_Porch_nxt;
	reg		[PORCH_WIDTH-1:0] 		H_Back_Porch_reg, H_Back_Porch_nxt;
	reg		[PORCH_WIDTH-1:0] 		V_Back_Porch_reg, V_Back_Porch_nxt;
	reg     [REZ_WIDTH-1:0]  		H_Count_Active_reg, H_Count_Active_nxt;
	reg     [REZ_WIDTH-1:0]  		V_Count_Active_reg, V_Count_Active_nxt;
	reg     [REZ_MAX_WIDTH-1:0] 	H_Count_Max_reg, H_Count_Max_nxt;
	reg     [REZ_MAX_WIDTH-1:0]  	V_Count_Max_reg, V_Count_Max_nxt;
	
	always@(posedge Clk or negedge Rst)
	begin
		if(Rst)
		begin
			Load_reg    		<= 0;
			H_Front_Porch_reg   <= H_Front_Porch_RD;
			V_Front_Porch_reg   <= V_Front_Porch_RD;
			H_Back_Porch_reg    <= H_Back_Porch_RD;
			V_Back_Porch_reg	<= V_Back_Porch_RD;
			H_Count_Active_reg  <= H_Count_Active_RD;
			V_Count_Active_reg  <= V_Count_Active_RD;
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
			H_Count_Active_reg  <= H_Count_Active_nxt;
			V_Count_Active_reg  <= V_Count_Active_nxt;
			H_Count_Max_reg 	<= H_Count_Max_nxt;
			V_Count_Max_reg 	<= V_Count_Max_nxt;
		end
	end
	
	always @*
	begin
		Load_nxt    		<= `LOW;
		H_Front_Porch_nxt   <= H_Front_Porch_reg;
		V_Front_Porch_nxt   <= V_Front_Porch_reg;
		H_Back_Porch_nxt    <= H_Back_Porch_reg;
		V_Back_Porch_nxt	<= V_Back_Porch_reg;
		H_Count_Active_nxt  <= H_Count_Active_reg;
		V_Count_Active_nxt  <= V_Count_Active_reg;
		H_Count_Max_nxt 	<= H_Count_Max_reg;
		V_Count_Max_nxt 	<= V_Count_Max_reg; 
		
		if(Addr ==`VGA_ADRESS && Valid == `ACTIVE)
		begin	
			case (Data)
				`R8X6:
				begin
					H_Front_Porch_nxt 	= H_Back_Porch_R8x6;
					V_Front_Porch_nxt	= V_Front_Porch_R8x6;
					H_Back_Porch_nxt	= H_Back_Porch_R8x6;
					V_Back_Porch_nxt 	= V_Back_Porch_R8x6;
					H_Count_Active_nxt 	= H_Count_Active_R8x6; //800 - lungime
					V_Count_Active_nxt 	= V_Count_Active_R8x6; //600 - latime
					H_Count_Max_nxt 	= H_Count_Max_R8x6;
					V_Count_Max_nxt 	= V_Count_Max_R8x6;
					Load_nxt			= `HIGH;
				end
		
				`R10X7:
				begin
					H_Front_Porch_nxt 	= H_Back_Porch_R10x7;
					V_Front_Porch_nxt	= V_Front_Porch_R10x7;
					H_Back_Porch_nxt	= H_Back_Porch_R10x7;
					V_Back_Porch_nxt 	= V_Back_Porch_R10x7;
					H_Count_Active_nxt 	= H_Count_Active_R10x7; //1024 - lungime
					V_Count_Active_nxt 	= V_Count_Active_R10x7; //768 - latime
					H_Count_Max_nxt 	= H_Count_Max_R10x7;
					V_Count_Max_nxt 	= V_Count_Max_R10x7;
					Load_nxt			= `HIGH;
				end	
				
				`R6X4:
				begin
					H_Front_Porch_reg   <= H_Front_Porch_RD;
					V_Front_Porch_reg   <= V_Front_Porch_RD;
					H_Back_Porch_reg    <= H_Back_Porch_RD;
					V_Back_Porch_reg	<= V_Back_Porch_RD;
					H_Count_Active_reg  <= H_Count_Active_RD;
					V_Count_Active_reg  <= V_Count_Active_RD;
					H_Count_Max_reg 	<= H_Count_Max_RD;
					V_Count_Max_reg 	<= V_Count_Max_RD;
					Load_reg    		<= `LOW;
				end
			endcase
		end
	end
	
	
	assign Load_config   = Load_reg;
	assign H_front_porch = H_Front_Porch_reg;
	assign H_back_porch  = H_Back_Porch_reg;
	assign V_front_porch = V_Front_Porch_reg;
	assign V_back_porch  = V_Back_Porch_reg;
	assign H_count_max   = H_Count_Max_reg;
	assign H_count_activ = H_Count_Active_reg;
	assign V_count_max   = V_Count_Max_reg;
	assign V_count_activ = V_Count_Active_reg;

	
	endmodule
