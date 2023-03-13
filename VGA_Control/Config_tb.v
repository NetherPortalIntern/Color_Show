`timescale 1 ns/10 ps 

module Config_tb
	#(`include "Width_Parameters.v");
	
	parameter CLK_PERIOD 	= 4;
	parameter RST_DURATION 	= 4;
	parameter WAIT 		    = 20;
	
	reg Clk;
	reg Rst;
	reg Valid;
	reg [CONFIG_WIDTH-1:0] Addr;
	reg [CONFIG_WIDTH-1:0] Data;
	wire Load_config;
	wire [PORCH_WIDTH-1:0]   H_front_porch;
	wire [PORCH_WIDTH-1:0]   H_back_porch;
	wire [PORCH_WIDTH-1:0]   V_front_porch;
	wire [PORCH_WIDTH-1:0]   V_back_porch;
	wire [REZ_MAX_WIDTH-1:0]  H_count_max;
	wire [REZ_WIDTH-1:0]  H_count_activ;
	wire [REZ_MAX_WIDTH-1:0]  V_count_max;
	wire [REZ_WIDTH-1:0]  V_count_activ;
	
	Config config1(	.Clk(Clk), 
					.Rst(Rst),
					.Valid(Valid),
					.Addr(Addr),
					.Data(Data),
					.Load_config(Load_config),
					.H_front_porch(H_front_porch),
					.H_back_porch(H_back_porch),
					.V_front_porch(V_front_porch),
					.V_back_porch(V_back_porch),
					.H_count_max(H_count_max),
					.H_count_activ(H_count_activ),
					.V_count_max(V_count_max),
					.V_count_activ(V_count_activ));	
				
	
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

	end
	
	initial
	begin
		Addr = 2'b00;
		Data = 2'b00;
		Valid = 0;
		
		#WAIT
		Addr = 2'b10;
		Data = 2'b11;
		Valid = 0;

		#WAIT		
		Addr = 2'b11;
		Data = 2'b10;
		Valid = 0;
		

		#WAIT
		Addr = 2'b10;
		Data = 2'b11;
		Valid = 1;
		
		#WAIT
		Addr = 2'b10;
		Data = 2'b01;
		Valid = 1;
		
		#WAIT
		Addr = 2'b10;
		Data = 2'b10;
		Valid = 1;
	end

	
endmodule
