	//Parameters are taken from https://web.mit.edu/6.111/www/s2004/NEWKIT/vga.shtml, for the 60Hz
	
	//Parameters for front porch
	parameter [PORCH_WIDTH-1:0] H_Front_Porch_RD      =  8'b00010000;   //16
	parameter [PORCH_WIDTH-1:0] V_Front_Porch_RD      =  8'b00001011;   //11
    parameter [PORCH_WIDTH-1:0] H_Front_Porch_R8x6    =  8'b00101000;   //40
	parameter [PORCH_WIDTH-1:0] V_Front_Porch_R8x6    =  8'b00000001;   //1
    parameter [PORCH_WIDTH-1:0] H_Front_Porch_R10x7   =  8'b00011000;   //24
    parameter [PORCH_WIDTH-1:0] V_Front_Porch_R10x7   =  8'b00000011;   //3
	
	//Parameters for back porch
	parameter [PORCH_WIDTH-1:0] H_Back_Porch_RD     =  8'b00110000;   //48
	parameter [PORCH_WIDTH-1:0] V_Back_Porch_RD     =  8'b00011111;   //31
    parameter [PORCH_WIDTH-1:0] H_Back_Porch_R8x6   =  8'b01011000;   //88
	parameter [PORCH_WIDTH-1:0] V_Back_Porch_R8x6   =  8'b00010111;	  //23
    parameter [PORCH_WIDTH-1:0] H_Back_Porch_R10x7  =  8'b10100000;   //160
    parameter [PORCH_WIDTH-1:0] V_Back_Porch_R10x7  =  8'b00011101;   //29
	
	//Parameters for sync pulse, where the actual parameter is the sync pulse - 2
	parameter [PULSE_WIDTH-1:0] H_Sync_Pulse_RD    =  8'b01011110;  //96-2=94
	parameter [PULSE_WIDTH-1:0] V_Sync_Pulse_RD    =  8'b00000000;  //2-2=0
	parameter [PULSE_WIDTH-1:0] H_Sync_Pulse_R8x6  =  8'b01111110;  //128-2=126
    parameter [PULSE_WIDTH-1:0] V_Sync_Pulse_R8x6  =  8'b00000010;  //4-2=2
	parameter [PULSE_WIDTH-1:0] H_Sync_Pulse_R10x7 =  8'b10000110;  //136-2=134
	parameter [PULSE_WIDTH-1:0] V_Sync_Pulse_R10x7 =  8'b00000100;  //6-2=4
	
	// Parameters for maximum counters, where maximum is the sum of the active+front porch+ back porch+ pulse width
    parameter [REZ_MAX_WIDTH-1:0] V_Count_Max_RD    =  12'b001000001100;   //524
    parameter [REZ_MAX_WIDTH-1:0] H_Count_Max_RD    =  12'b001100100000;   //800
    parameter [REZ_MAX_WIDTH-1:0] V_Count_Max_R8x6  =  12'b001001110100;   //628
    parameter [REZ_MAX_WIDTH-1:0] H_Count_Max_R8x6  =  12'b010000100000;   //1056
	parameter [REZ_MAX_WIDTH-1:0] V_Count_Max_R10x7 =  12'b001100100110;   //806
    parameter [REZ_MAX_WIDTH-1:0] H_Count_Max_R10x7 =  12'b010010100000;   //1184