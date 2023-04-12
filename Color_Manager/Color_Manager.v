`timescale 1 ns/1 ns 
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
// Module Name:   Color_Manager
// The top module for the configuration and VGA's color distribution.
//
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
module Color_Manager
#(`include "Color_Manager_Width_Parameters.v")
   (input Clk,
	input Rst,
	input Empty,
	input C_Rdy,
	input [UART_DATA_WIDTH-1:0] RXD_Data,
	input Vertical_Split,
	input Horizontal_Split,
	input VGA_Debugg,
	input HSync,
	input VSync,
	output [C_ADDR_WIDTH-1:0] C_Addr,
	output [C_DATA_WIDTH-1:0] C_Data,
	output C_Valid,
	output [CONFIG_STATUS_WIDTH-1:0] Config_Status,
	output [CONFIG_NOTIFICATION_WIDTH-1:0] Config_Notification,
	output Config_Notification_Valid,
	output [CONFIG_ERROR_WIDTH-1:0] Config_Error,
	output Error_Valid,
	output [VGA_NOTIFICATION_WIDTH-1:0] VGA_Notification,
	output 								VGA_Notification_Valid,
	output [DATA_WIDTH-1:0]   Data_VGA);
	

	wire [BACKPORCH_WIDTH-1:0]  H_BackPorch;
	wire [FRONTPORCH_WIDTH-1:0] H_FrontPorch;
	wire [BACKPORCH_WIDTH-1:0]  V_BackPorch;
	wire [FRONTPORCH_WIDTH-1:0] V_FrontPorch;
	wire						Counter_X_Valid;
	wire [COUNTER_WIDTH-1:0] 	Counter_X;
	wire 					 	Counter_Y_Valid;
	wire [COUNTER_WIDTH-1:0]	Counter_Y;
	wire 					    C_Rdy_Assign;
	
	Color_Manager_Config_Manager configCM(.Clk(Clk),
							.Rst(Rst),
							.Empty(Empty),
							.C_Rdy(C_Rdy & C_Rdy_Assign),
							.RXD_Data(RXD_Data),
							.C_Addr(C_Addr),
							.C_Data(C_Data),
							.C_Valid(C_Valid),
							.Config_Status(Config_Status),
							.Config_Notification(Config_Notification),
							.Config_Notification_Valid(Config_Notification_Valid),
							.Config_Error(Config_Error),
							.Error_Valid(Error_Valid));
							
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
						.C_Rdy(C_Rdy_Assign),
						.VGA_Notification(VGA_Notification),
						.VGA_Notification_Valid(VGA_Notification_Valid),
						.Data_VGA(Data_VGA),
						.H_BackPorch(H_BackPorch),
						.H_FrontPorch(H_FrontPorch),
						.V_BackPorch(V_BackPorch),
						.V_FrontPorch(V_FrontPorch));
					
							
	Color_Manager_Counter counterH(.Clk(Clk),
				 .Rst(Rst),
				 .BackPorch(H_BackPorch),
				 .FrontPorch(H_FrontPorch), 
				 .Sync(HSync),
				 .Counter_Valid(Counter_X_Valid),
				 .CounterP(Counter_X));
				 
	Color_Manager_Counter counterV(.Clk(Clk),
				 .Rst(Rst),
				 .BackPorch(V_BackPorch),
				 .FrontPorch(V_FrontPorch), 
				 .Sync(VSync),
				 .Counter_Valid(Counter_Y_Valid),
				 .CounterP(Counter_Y));
				 
	
endmodule