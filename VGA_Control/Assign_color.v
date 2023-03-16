`timescale 1 ns/10 ps 
module Assign_color
	#(`include "Width_Parameters.v")
	(input Clk,
	input Rst,
	input  [DATA_WIDTH-1:0]     	Data,
	input  [REZ_MAX_WIDTH-1:0]  	Count_h,
	input  [REZ_MAX_WIDTH-1:0]  	Count_v,
	input  [HL_MARGIN_WIDTH-1:0] 	H_left_margin,
	input  [HR_MARGIN_WIDTH-1:0] 	H_right_margin,
	input  [VL_MARGIN_WIDTH-1:0] 	V_left_margin,
	input  [VR_MARGIN_WIDTH-1:0] 	V_right_margin,
	output [COLOR_WIDTH-1:0] 	Red,
	output [COLOR_WIDTH-1:0] 	Green,
	output [COLOR_WIDTH-1:0] 	Blue);
	
	reg   Active_reg, Active_nxt;
	/*reg H_active_reg, H_active_nxt;
	reg V_active_reg, V_active_nxt;*/

	
	always@(posedge Clk or negedge Rst)
	begin
		if(Rst == 0)
		begin
			Active_reg   <= 0;
			/*H_active_reg <= 0;
			V_active_reg <= 0;*/
			
		end
		else
		begin
			Active_reg   <= Active_nxt;
			/*H_active_reg <= H_active_nxt;
			V_active_reg <= V_active_nxt;*/
		end
	end
	
	always@*
	begin
		if(Count_h>=H_left_margin && Count_h<=H_right_margin && Count_v>=V_left_margin && Count_v<=V_right_margin)
			Active_nxt = 1;
		else
			Active_nxt = 0;	
	
		/*//testing the display region for the horizontal line
		if(Count_h>=H_left_margin && Count_h<=H_right_margin)
			H_active_nxt = 1;
		else
			H_active_nxt = 0;
		
		//testing the display region for the vertical column		
		if(Count_v>=V_left_margin && Count_v<=V_right_margin)
			V_active_nxt = 1;
		else
			V_active_nxt = 0;
			
		Active_nxt = H_active_reg && V_active_reg;*/
		
	end
		
	// Assign data if the counters are in the display region, else assign black
	assign Red   = Active_reg?Data[3:0] :4'b0000;
    assign Green = Active_reg?Data[7:4] :4'b0000;
    assign Blue  = Active_reg?Data[11:8]:4'b0000;
	
endmodule