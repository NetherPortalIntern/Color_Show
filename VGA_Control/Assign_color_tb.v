`timescale 1 ns/10 ps 
//The teshbench for the Assign_color module

module Assign_color_tb
#(`include "Width_Parameters.v");

	parameter CLK_F     	 = 2;
	parameter RST_DURATION 	 = 4;
	parameter WAIT 		     = 10;
	
	reg 						Clk;
	reg 						Rst;
	reg  [DATA_WIDTH-1:0]     	Data;
	reg  [REZ_MAX_WIDTH-1:0]  	Count_h;
	reg  [REZ_MAX_WIDTH-1:0]  	Count_v;
	reg  [HL_MARGIN_WIDTH-1:0] 	H_left_margin;
	reg  [HR_MARGIN_WIDTH-1:0] 	H_right_margin;
	reg  [VL_MARGIN_WIDTH-1:0] 	V_left_margin;
	reg  [VR_MARGIN_WIDTH-1:0] 	V_right_margin;
	wire [COLOR_WIDTH-1:0] 	Red;
	wire [COLOR_WIDTH-1:0] 	Green;
	wire [COLOR_WIDTH-1:0] 	Blue;
	
	
	Assign_color assgncolor(.Clk(Clk),
							.Rst(Rst),
							.Data(Data),
							.Count_h(Count_h),
							.Count_v(Count_v),
							.H_left_margin(H_left_margin),
							.H_right_margin(H_right_margin),
							.V_left_margin(V_left_margin),
							.V_right_margin(V_right_margin),
							.Red(Red),
							.Green(Green),
							.Blue(Blue));
					
					
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
		Data 			= 12'b101011111010;
		H_left_margin	= 8'b01110000;
		H_right_margin	= 11'b01011110000;
		V_left_margin	= 4'b1101;
		V_right_margin  = 10'b0111101101;
		
		//expecting black color
		Count_h			= 'b0;
		Count_v			= 'b0;
		

		#WAIT
		//expecting colors
		Count_h			= 8'b01110011;
		Count_v			= 4'b1111;
		
		#WAIT
		//not expecting colors
		Count_h			= 8'b01110011;
		Count_v			= 4'b0001;
		
		#WAIT
		//expecting colors
		Count_h			= 8'b01110000;
		Count_v			= 10'b0111101101;
		
	end
	
endmodule