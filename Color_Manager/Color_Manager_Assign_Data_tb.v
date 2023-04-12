`timescale 1 ns/1 ns
//The testbench for the Color_Manager's Assig_Data module.
module Color_Manager_Assign_Data_tb
#(`include "Color_Manager_Width_Parameters.v");

	parameter CLK_F     	 = 2;
	parameter RST_DURATION 	 = 4;
	parameter WAIT 		     = 10;
	
	reg Clk;
	reg Rst;
	reg [C_ADDR_WIDTH-1:0] C_Addr;
	reg [C_DATA_WIDTH-1:0] C_Data;
	reg 					 C_Valid;
	reg Vertical_Split;
	reg Horizontal_Split;
	reg VGA_Debugg;
	reg 						Counter_X_Valid;
	reg [COUNTER_WIDTH-1:0] 	Counter_X;
	reg 					 	Counter_Y_Valid;
	reg [COUNTER_WIDTH-1:0]	Counter_Y;
	wire 					  C_Rdy;
	wire [VGA_NOTIFICATION_WIDTH-1:0] VGA_Notification;
	wire 								VGA_Notification_Valid;
	wire [DATA_WIDTH-1:0]   Data_VGA;
	wire [BACKPORCH_WIDTH-1:0]  H_BackPorch;
	wire [FRONTPORCH_WIDTH-1:0] H_FrontPorch;
	wire [BACKPORCH_WIDTH-1:0]  V_BackPorch;
	wire [FRONTPORCH_WIDTH-1:0] V_FrontPorch;
	

	
	Color_Manager_Assign_Data assignCM(.Clk(Clk),
					.Rst(Rst),
					.C_Addr(C_Addr),
					.C_Data(C_Data),
					.C_Valid(C_Valid),
					.Vertical_Split(Vertical_Split),
					.Horizontal_Split(Horizontal_Split),
					.VGA_Debugg(VGA_Debugg),
					.Counter_X_Valid(Counter_X_Valid),
					.Counter_X(Counter_X),
					.Counter_Y_Valid(Counter_Y_Valid),
					.Counter_Y(Counter_Y),
					.C_Rdy(C_Rdy),
					.VGA_Notification(VGA_Notification),
					.VGA_Notification_Valid(VGA_Notification_Valid),
					.Data_VGA(Data_VGA),
					.H_BackPorch(H_BackPorch),
					.H_FrontPorch(H_FrontPorch),
					.V_BackPorch(V_BackPorch),
					.V_FrontPorch(V_FrontPorch));
					
					
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
		C_Addr=0;
		C_Data=0;
		C_Valid=0;
	
		Vertical_Split=0;
		Horizontal_Split=0;
		VGA_Debugg=0;
		Counter_X_Valid=0;
		Counter_X=0;
		Counter_Y_Valid=0;
		Counter_Y=0;
		
		#WAIT
		Counter_X_Valid=1;
		Counter_X=1;
		Counter_Y_Valid=1;
		Counter_Y=1;
		C_Addr=1000;
		C_Data=14'b00111111111111;
		C_Valid=1;
		
		#WAIT
		Horizontal_Split=1;
		Counter_X=10'b0011011111;
		Counter_Y=10'b1111000000;
		
		#WAIT
		C_Addr=1000;
		C_Data=14'b10111100011111;
		C_Valid=1;
		
		#WAIT
		C_Valid=0;
		
		
	end
	
endmodule