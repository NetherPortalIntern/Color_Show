`timescale 1 ns/10 ps 

module Config_tb
	#(`include "Width_Parameters.v");
	
	parameter CLK_F		 	= 2;
	parameter RST_DURATION 	= 4;
	parameter WAIT 		    = 7;
	
	reg Clk;
	reg Rst;
	reg Valid;
	reg [CONFIG_WIDTH-1:0] Addr;
	reg [CONFIG_WIDTH-1:0] Data;
	wire Load_config;
	wire [HL_MARGIN_WIDTH-1:0] 	H_left_margin;
	wire [HR_MARGIN_WIDTH-1:0] 	H_right_margin;
	wire [VL_MARGIN_WIDTH-1:0] 	V_left_margin;
	wire [VR_MARGIN_WIDTH-1:0] 	V_right_margin;
	wire [REZ_MAX_WIDTH-1:0] H_count_max;
	wire [PULSE_WIDTH-1:0]   H_sync_pulse;
	wire [REZ_MAX_WIDTH-1:0] V_count_max;
	wire [PULSE_WIDTH-1:0]   V_sync_pulse;
	
	
	Config config1(	.Clk(Clk), 
					.Rst(Rst),
					.Valid(Valid),
					.Addr(Addr),
					.Data(Data),
					.Load_config(Load_config),
					.H_left_margin(H_left_margin),
					.H_right_margin(H_right_margin),
					.V_left_margin(V_left_margin),
					.V_right_margin(V_right_margin),
					.H_count_max(H_count_max),
					.H_sync_pulse(H_sync_pulse),
					.V_count_max(V_count_max),
					.V_sync_pulse(V_sync_pulse));	
				
	
	initial 
	begin
		Clk = 1'b1;
		forever #CLK_F Clk = ~Clk;
	end
				
	initial
	begin
		Rst = 1'b0;
		#RST_DURATION 
		Rst = 1'b1;
	end
	
	initial
	begin
		//case for default config
		Addr = 2'b10;
		Data = 2'b00;
		Valid = 1;
		#(CLK_F*2);
		Valid = 0;

		#WAIT
		//case for 10x86 config		
		Addr = 2'b10;
		Data = 2'b10;
		Valid = 1;
		#(CLK_F*2)
		Valid = 0;
		
		#WAIT
		//invalid, expected to do nothing		
		Addr = 2'b10;
		Data = 2'b00;
		Valid = 0;
		#(CLK_F*2);
		Valid = 0;
		
		#WAIT
		//not the expected addres, expected to do nothing		
		Addr = 2'b00;
		Data = 2'b00;
		Valid = 1;
		#(CLK_F*2);
		Valid = 0;
		
		#WAIT
		//expected to reset to default, 6x4 config
		Rst = 1'b0;
		#RST_DURATION 
		Rst = 1'b1;
		
		#WAIT
		//case for 8x6 config		
		Addr = 2'b10;
		Data = 2'b01;
		Valid = 1;
		#(CLK_F*2);
		Valid = 0;
	end

	
endmodule
