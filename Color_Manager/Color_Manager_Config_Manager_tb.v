`timescale 1 ns/1 ns 
//The testbench for the Color_Manager's Config_Manager module.
module Color_Manager_Config_Manager_tb
#(`include "Color_Manager_Width_Parameters.v");

	parameter CLK_F     	 = 2;
	parameter RST_DURATION 	 = 4;
	parameter CLOCK_CYCLE    = 4;
	parameter WAIT 		     = 20;
	parameter WAIT2 		 = 50;
	
	reg Clk;
	reg Rst;
	reg Empty;
	reg C_Rdy;
	reg [UART_DATA_WIDTH-1:0] RXD_Data;
	wire [C_ADDR_WIDTH-1:0] C_Addr;
	wire [C_DATA_WIDTH-1:0] C_Data;
	wire C_Valid;
	wire [CONFIG_STATUS_WIDTH-1:0] Config_Status;
	wire [CONFIG_NOTIFICATION_WIDTH-1:0] Config_Notification;
	wire Config_Notification_Valid;
	wire [CONFIG_ERROR_WIDTH-1:0] Config_Error;
	wire Error_Valid;
	
	Color_Manager_Config_Manager configCM(.Clk(Clk),
							.Rst(Rst),
							.Empty(Empty),
							.C_Rdy(C_Rdy),
							.RXD_Data(RXD_Data),
							.C_Addr(C_Addr),
							.C_Data(C_Data),
							.C_Valid(C_Valid),
							.Config_Status(Config_Status),
							.Config_Notification(Config_Notification),
							.Config_Notification_Valid(Config_Notification_Valid),
							.Config_Error(Config_Error),
							.Error_Valid(Error_Valid));
					
					
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
		Empty=1;
		C_Rdy=0;
		RXD_Data=8'b00000000;
		
		#WAIT
		Empty=0;
		RXD_Data=8'b10100011;
		
		#CLOCK_CYCLE
		Empty=1;
		
		#WAIT
		Empty=0;
		RXD_Data=8'b00000001;
		
		#CLOCK_CYCLE
		Empty=1;
		
		#WAIT
		C_Rdy=1;
		
		#WAIT2
		C_Rdy=0;
		Empty=0;
		RXD_Data=8'b10110001;
		
		#CLOCK_CYCLE
		Empty=1;
		C_Rdy=1;
		
		#WAIT
		Empty=0;
		RXD_Data=8'b00000001;
		
		#CLOCK_CYCLE
		Empty=1;
		
		#WAIT2
		C_Rdy=0;
		Empty=0;
		RXD_Data=8'b00001010;
		
		#CLOCK_CYCLE
		Empty=1;
		C_Rdy=1;
		
		#WAIT
		Empty=0;
		RXD_Data=8'b01011010;
		
		#CLOCK_CYCLE
		Empty=1;
		
	end
	
endmodule