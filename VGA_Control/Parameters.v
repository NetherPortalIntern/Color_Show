	//Parameters are taken from https://web.mit.edu/6.111/www/s2004/NEWKIT/vga.shtml, for the 60Hz
	//The act
	
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
	
	//Parameters for count active, where active means the display zone+front porch+back porch
	//!!!!refacut
	parameter [REZ_WIDTH-1:0] H_Count_Active_RD    =  11'b01010000000;  //640
	parameter [REZ_WIDTH-1:0] V_Count_Active_RD    =  11'b00111100000;  //480
	parameter [REZ_WIDTH-1:0] H_Count_Active_R8x6  =  11'b01100100000;  //800
    parameter [REZ_WIDTH-1:0] V_Count_Active_R8x6  =  11'b01001011000;  //600
	parameter [REZ_WIDTH-1:0] H_Count_Active_R10x7 =  11'b10000000000;  //1024
	parameter [REZ_WIDTH-1:0] V_Count_Active_R10x7 =  11'b01100000000;  //768
	
	// Parameters for maximum counters, where maximum is the sum of the active+front porch+ back porch+ pulse width
    parameter [REZ_MAX_WIDTH-1:0] V_Count_Max_RD    =  12'b001000001100;   //524
    parameter [REZ_MAX_WIDTH-1:0] H_Count_Max_RD    =  12'b001100100000;   //800
    parameter [REZ_MAX_WIDTH-1:0] V_Count_Max_R8x6  =  12'b001001110100;   //628
    parameter [REZ_MAX_WIDTH-1:0] H_Count_Max_R8x6  =  12'b010000100000;   //1056
	parameter [REZ_MAX_WIDTH-1:0] V_Count_Max_R10x7 =  12'b001100100110;   //806
    parameter [REZ_MAX_WIDTH-1:0] H_Count_Max_R10x7 =  12'b010010100000;   //1184