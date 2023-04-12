`timescale 1 ns/1 ns 
/////////////////////////////////////////////////////////////////////////////////////////////////////////////////// 
// Module Name:   Assign_Data
// Manage the configuration bus with the user input given from UART and  saves the current configuration.
//		
//  1.Is Mode DEBUGG? Bypass everything.
//	2.Update resolution parameters
//	3.Saves the new color from Configuration Buss 
//	4. Test switches and Save New Quadran Config from Config Buss only if both split switches are not active.
//	5. Send VGA_Notifications 
//	6.Case with Current_Qudran_Config
//		6.1Testing X and Y for finding the current quadran and sending the correct color
//		
//////////////////////////////////////////////////////////////////////////////////////////////////////////////////
`define ACTIVE 1'b1

module Color_Manager_Assign_Data
	#(`include "Color_Manager_Width_Parameters.v",
	  `include "Color_Manager_Parameters.v",
	  `include "Color_Manager_Addr_Parameters.v")
	(input Clk,
	input Rst,
	input [C_ADDR_WIDTH-1:0] C_Addr,
	input [C_DATA_WIDTH-1:0] C_Data,
	input 					 C_Valid,
	input Vertical_Split,
	input Horizontal_Split,
	input VGA_Debugg,
	input 						Counter_X_Valid,
	input [COUNTER_WIDTH-1:0] 	Counter_X,
	input 					 	Counter_Y_Valid,
	input [COUNTER_WIDTH-1:0]	Counter_Y,
	output 					  C_Rdy,
	output [VGA_NOTIFICATION_WIDTH-1:0] VGA_Notification,
	output 								VGA_Notification_Valid,
	output [DATA_WIDTH-1:0]   Data_VGA,
	output [BACKPORCH_WIDTH-1:0]  H_BackPorch,
	output [FRONTPORCH_WIDTH-1:0] H_FrontPorch,
	output [BACKPORCH_WIDTH-1:0]  V_BackPorch,
	output [FRONTPORCH_WIDTH-1:0] V_FrontPorch);
	
	reg C_Rdy_reg, C_Rdy_nxt;
	
	reg	VGA_Notification_Valid_reg, VGA_Notification_Valid_nxt;
	reg [VGA_NOTIFICATION_WIDTH-1:0] VGA_Notification_reg, VGA_Notification_nxt;

	reg [DATA_WIDTH-1:0]   Data_VGA_reg, Data_VGA_nxt;
	reg [BACKPORCH_WIDTH-1:0]  H_BackPorch_reg, H_BackPorch_nxt;
	reg [FRONTPORCH_WIDTH-1:0] H_FrontPorch_reg, H_FrontPorch_nxt;
	reg [BACKPORCH_WIDTH-1:0]  V_BackPorch_reg, V_BackPorch_nxt;
	reg [FRONTPORCH_WIDTH-1:0] V_FrontPorch_reg, V_FrontPorch_nxt;
	
	reg [DATA_WIDTH-1:0] Left_UP_reg, Left_UP_nxt;
	reg [DATA_WIDTH-1:0] Left_DOWN_reg, Left_DOWN_nxt;
	reg [DATA_WIDTH-1:0] Right_UP_reg, Right_UP_nxt;
	reg [DATA_WIDTH-1:0] Right_DOWN_reg, Right_DOWN_nxt;
	
	reg [COUNTER_WIDTH-1:0] HalfX_reg, HalfX_nxt;
	reg [COUNTER_WIDTH-1:0] HalfY_reg, HalfY_nxt;
	
	reg [QUADRAN_WIDTH-1:0] Current_Qudran_Config_reg, Current_Qudran_Config_nxt;
	reg [QUADRAN_WIDTH-1:0] Previous_Qudran_Config_reg, Previous_Qudran_Config_nxt;
	

	
	always@(posedge Clk or negedge Rst)
	begin
		if(Rst)
		begin		
			C_Rdy_reg <= 1; 
			
			VGA_Notification_Valid_reg <= 0;
			VGA_Notification_reg   <= 0;
			
			Data_VGA_reg 	 <= 0; //black color
					
			Left_UP_reg 	<= 0;
			Left_DOWN_reg	<= 0;
			Right_UP_reg 	<= 0;
			Right_DOWN_reg  <= 0;
			
			Current_Qudran_Config_reg  <= STATE0SPLIT;
			Previous_Qudran_Config_reg <= STATE0SPLIT;
			
			//default
			H_BackPorch_reg  <= H_BackPorch_RD;
			H_FrontPorch_reg <= H_FrontPorch_RD;
			V_BackPorch_reg  <= V_BackPorch_RD;
			V_FrontPorch_reg <= V_FrontPorch_RD;
			HalfX_reg <= H_FrontPorch_RD>>1;
			HalfY_reg <= V_FrontPorch_RD>>1;

		
		end
		else
		begin
			C_Rdy_reg <= C_Rdy_nxt;
			
			VGA_Notification_Valid_reg <= VGA_Notification_Valid_nxt;
			VGA_Notification_reg   <= VGA_Notification_nxt;
			
			Data_VGA_reg 	 <= Data_VGA_nxt;
			H_BackPorch_reg  <= H_BackPorch_nxt;
			H_FrontPorch_reg <= H_FrontPorch_nxt;
			V_BackPorch_reg  <=  V_BackPorch_nxt;
			V_FrontPorch_reg <= V_FrontPorch_nxt;
		
			Left_UP_reg 	<= Left_UP_nxt;
			Left_DOWN_reg	<= Left_DOWN_nxt;
			Right_UP_reg 	<= Right_UP_nxt;
			Right_DOWN_reg  <= Right_DOWN_nxt;
		
			HalfX_reg <= HalfX_nxt;
			HalfY_reg <= HalfY_nxt;
			
			Current_Qudran_Config_reg  <= Current_Qudran_Config_nxt;
			Previous_Qudran_Config_reg <= Previous_Qudran_Config_nxt;
		end
	end
	
	
	always@*
	begin
		C_Rdy_nxt = 1;
		VGA_Notification_Valid_nxt  = 0;
		VGA_Notification_nxt    = VGA_Notification_reg;
		Data_VGA_nxt 	  = Data_VGA_reg;
		H_BackPorch_nxt   = H_BackPorch_reg;
		H_FrontPorch_nxt  = H_FrontPorch_reg;
		V_BackPorch_nxt   =  V_BackPorch_reg;
		V_FrontPorch_nxt  = V_FrontPorch_reg;
		Left_UP_nxt 	 = Left_UP_reg;
		Left_DOWN_nxt	 = Left_DOWN_reg;
		Right_UP_nxt 	 = Right_UP_reg;
		Right_DOWN_nxt   = Right_DOWN_reg;
		HalfX_nxt = HalfX_reg;
		HalfY_nxt = HalfY_reg;
		Current_Qudran_Config_nxt  = Current_Qudran_Config_reg;
		Previous_Qudran_Config_nxt = Previous_Qudran_Config_reg;
		
		//////////////////////////////////////////////////////////////////////////////////
		//1.When the VGA_Debugg switch activates is shows a standard configuration and bypass the whole module
		if(VGA_Debugg)
		begin
			if(Counter_X_Valid && Counter_Y_Valid)
			begin
				if(Counter_X < HalfX_reg && Counter_Y < HalfY_reg) //x < half and y < half
				begin
					Data_VGA_nxt=Left_UP_Debugg;
				end
				else
				begin
					if(Counter_X < HalfX_reg && Counter_Y >= HalfY_reg) // x < half and y > half
					begin
						Data_VGA_nxt=Left_DOWN_Debugg;
					end
					else
					begin
						if(Counter_X >= HalfX_reg && Counter_Y >= HalfY_reg) //x>half and y>half 
						begin
							Data_VGA_nxt=Right_DOWN_Debugg;
						end
						else
						begin
							if(Counter_X >= HalfX_reg && Counter_Y < HalfY_reg) // x > half and y < half
							begin
								Data_VGA_nxt=Right_UP_Debugg;
							end
						end
					end
				end
			end
		end
		else
		begin
			//////////////////////////////////////////////////////////////////////////////////////////////
			//2.When a new valid configuration comes, update parameters
			if(C_Addr == ADDR_VGA_CONFIG && C_Valid == `ACTIVE) 
			begin	
				case (C_Data[C_DATA_CONFIG_WIDTH-1:0])	
					R6X4:
					begin
						//bring proper parameters 
						H_BackPorch_nxt  = H_BackPorch_RD;
						H_FrontPorch_nxt = H_FrontPorch_RD;
						V_BackPorch_nxt  = V_BackPorch_RD;
						V_FrontPorch_nxt = V_FrontPorch_RD;
						HalfX_nxt = H_FrontPorch_RD>>1;
						HalfY_nxt = V_FrontPorch_RD>>1;
						
						C_Rdy_nxt = 0;
					end
					
					R8X6:
					begin
						//bring proper parameters
						H_BackPorch_nxt  = H_BackPorch_R8x6;
						H_FrontPorch_nxt = H_FrontPorch_R8x6;
						V_BackPorch_nxt  = V_BackPorch_R8x6;
						V_FrontPorch_nxt = V_FrontPorch_R8x6;
						HalfX_nxt = H_FrontPorch_R8x6>>1;
						HalfY_nxt = V_FrontPorch_R8x6>>1;
						
						C_Rdy_nxt = 0;
					end
			
					R10X7:
					begin
						//bring proper parameters 
						H_BackPorch_nxt  = H_BackPorch_R10x7;
						H_FrontPorch_nxt = H_FrontPorch_R10x7;
						V_BackPorch_nxt  = V_BackPorch_R10x7;
						V_FrontPorch_nxt = V_FrontPorch_R10x7;
						HalfX_nxt = H_FrontPorch_R10x7>>1;
						HalfY_nxt = V_FrontPorch_R10x7>>1;
						
						
						C_Rdy_nxt = 0;
					end	
				endcase
			end
			
			//////////////////////////////////////////////////////////////////////////////////////////////
			//3.When a new color comes, it will be saved in the dedicated register
			if(C_Addr == ADDR_VGA_COLOR && C_Valid == `ACTIVE) 
			begin
				case(C_Data[C_DATA_WIDTH-1:C_DATA_WIDTH-2]) //the first 2 bits are to identify the quadran
					QLEFTUP:
					begin
						Left_UP_nxt = C_Data[C_DATA_WIDTH-3:0];
					end					
					QRIGHTUP:
					begin
						Right_UP_nxt = C_Data[C_DATA_WIDTH-3:0]; 
					end
					QLEFTDOWN:
					begin
						Left_DOWN_nxt = C_Data[C_DATA_WIDTH-3:0]; 
					end
					QRIGHTDOWN:
					begin
						Right_DOWN_nxt = C_Data[C_DATA_WIDTH-3:0]; 
					end
				endcase
				
				C_Rdy_nxt = 0;
			end
			
			//////////////////////////////////////////////////////////////////////////////////////////////////////////
			//4. Test switches and Save New Quadran Config from Config Buss only if both split switches are not active 
			if(Horizontal_Split | Vertical_Split)
			begin
				Current_Qudran_Config_nxt = {Horizontal_Split,Vertical_Split};
				Previous_Qudran_Config_nxt = Current_Qudran_Config_reg;
			end
			else
			begin
				if((C_Addr == ADDR_VGA_QUADRAN) & (C_Valid == `ACTIVE)) 
				begin
					Current_Qudran_Config_nxt = C_Data[C_DATA_CONFIG_WIDTH-1:0];
					Previous_Qudran_Config_nxt = Current_Qudran_Config_reg;
					
					C_Rdy_nxt = 0;
				end
				
			end
			
			//////////////////////////////////////////////////////////////////////////////////////////////////////////
			//5.Send VGA_Notifications 
			//Verify split switches 
			if(Previous_Qudran_Config_reg != Current_Qudran_Config_reg)
			begin
				case(Current_Qudran_Config_reg)
					STATE0SPLIT:
					begin
						VGA_Notification_nxt = STATE0SPLIT_CHANGE;
					end
					STATE2VERTICAL_SPLIT:
					begin
						VGA_Notification_nxt = STATE2VERTICAL_CHANGE;
					end
					STATE2HORIZONTAL_SPLIT:
					begin
						VGA_Notification_nxt = STATE2HORIZONTAL_CHANGE;
					end
					STATE4SPLIT:
					begin
						VGA_Notification_nxt = STATE4SPLIT_CHANGE;
					end
				endcase
				
				VGA_Notification_Valid_nxt = 1;
			end
			
			//////////////////////////////////////////////////////////////////////////////////////////////
			//6.When the VGA_Debugg switch isn't activated, the colors from the user appears only in the active region
			//This is where the DATA_VGA recive values
			if(Counter_X_Valid && Counter_Y_Valid)
			begin
				case(Current_Qudran_Config_reg)
					STATE0SPLIT:
					begin
						Data_VGA_nxt=Left_UP_reg;
					end
					
					STATE2VERTICAL_SPLIT:
					begin
						if(Counter_X < HalfX_reg) //x < half 
						begin
							Data_VGA_nxt=Left_UP_reg;
						end
						else
						begin
							Data_VGA_nxt=Right_UP_reg;
						end
					end
					
					STATE2HORIZONTAL_SPLIT:
					begin
						if(Counter_Y < HalfY_reg) //y < half 
						begin
							Data_VGA_nxt=Left_UP_reg;
						end
						else
						begin
							Data_VGA_nxt=Left_DOWN_reg;
						end
					end
					
					STATE4SPLIT:
					begin
						if((Counter_X < HalfX_reg) && (Counter_Y < HalfY_reg)) //x < half and y < half
						begin
							Data_VGA_nxt=Left_UP_reg;
						end
						else
						begin
							if((Counter_X < HalfX_reg) && (Counter_Y >= HalfY_reg)) // x < half and y > half
							begin
								Data_VGA_nxt=Left_DOWN_reg;
							end
							else
							begin
								if((Counter_X >= HalfX_reg) && (Counter_Y < HalfY_reg)) //x>half and y<half 
								begin
									Data_VGA_nxt=Right_UP_reg;
								end
								else
								begin
									Data_VGA_nxt=Right_DOWN_reg;
								end
							end
						end
					end
				
				endcase
			end	
			

			
		end
	end
	
	assign C_Rdy = C_Rdy_reg;
	assign VGA_Notification_Valid = VGA_Notification_Valid_reg;
	assign VGA_Notification = VGA_Notification_reg;
	assign Data_VGA = Data_VGA_reg;
	assign H_BackPorch = H_BackPorch_reg;
	assign H_FrontPorch = H_FrontPorch_reg;
	assign V_BackPorch = V_BackPorch_reg;
	assign V_FrontPorch = V_FrontPorch_reg;
	
endmodule