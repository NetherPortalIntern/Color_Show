//Parameters are taken from https://web.mit.edu/6.111/www/s2004/NEWKIT/vga.shtml, for the 60Hz
	
	//Parameters for left margin, where left margin means front porch + sync pulse
	parameter [VL_MARGIN_WIDTH-1:0] V_Left_Margin_RD      =  4'b1101,   	//11+  2= 13
	parameter [VL_MARGIN_WIDTH-1:0] V_Left_Margin_R8x6    =  4'b0101,   	// 1+  4=  5
    parameter [VL_MARGIN_WIDTH-1:0] V_Left_Margin_R10x7   =  4'b1001,   	// 3+  6=  9
	
	parameter [HL_MARGIN_WIDTH-1:0] H_Left_Margin_RD      =  8'b01110000,   //16+ 96=112
    parameter [HL_MARGIN_WIDTH-1:0] H_Left_Margin_R8x6    =  8'b10101000,   //40+128=168
    parameter [HL_MARGIN_WIDTH-1:0] H_Left_Margin_R10x7   =  8'b10100000,   //24+136=160

	
	//Parameters for right margin, where right margin means maximum counters - back porch (or sync pulse + front porch + acive) 
	parameter [VR_MARGIN_WIDTH-1:0] V_Right_Margin_RD     =  10'b0111101101,   // 524- 31=755
	parameter [VR_MARGIN_WIDTH-1:0] V_Right_Margin_R8x6   =  10'b1001011101,	// 628- 23=605
    parameter [VR_MARGIN_WIDTH-1:0] V_Right_Margin_R10x7  =  10'b1100001001,   // 806- 29=777

	parameter [HR_MARGIN_WIDTH-1:0] H_Right_Margin_RD     =  11'b01011110000,   // 800- 48=752
    parameter [HR_MARGIN_WIDTH-1:0] H_Right_Margin_R8x6   =  11'b01111001000,   //1056- 88=968
    parameter [HR_MARGIN_WIDTH-1:0] H_Right_Margin_R10x7  =  11'b10010100000,   //1344-160=1184

	
	//Parameters for sync pulse, where the actual parameter is the sync pulse - 2
	parameter [PULSE_WIDTH-1:0] H_Sync_Pulse_RD    =  8'b01011110,  // 96-2=94
	parameter [PULSE_WIDTH-1:0] V_Sync_Pulse_RD    =  8'b00000000,  //  2-2=0
	parameter [PULSE_WIDTH-1:0] H_Sync_Pulse_R8x6  =  8'b01111110,  //128-2=126
    parameter [PULSE_WIDTH-1:0] V_Sync_Pulse_R8x6  =  8'b00000010,  //  4-2=2
	parameter [PULSE_WIDTH-1:0] H_Sync_Pulse_R10x7 =  8'b10000110,  //136-2=134
	parameter [PULSE_WIDTH-1:0] V_Sync_Pulse_R10x7 =  8'b00000100,  //  6-2=4
	
	// Parameters for maximum counters, where maximum is the sum of the active+front porch + back porch + sync pulse
    parameter [REZ_MAX_WIDTH-1:0] V_Count_Max_RD    =  12'b001000001100,   // 480+11+  2+ 31= 524
    parameter [REZ_MAX_WIDTH-1:0] H_Count_Max_RD    =  12'b001100100000,   // 640+16+ 96+ 48= 800
    parameter [REZ_MAX_WIDTH-1:0] V_Count_Max_R8x6  =  12'b001001110100,   // 600+ 1+  4+ 23= 628
    parameter [REZ_MAX_WIDTH-1:0] H_Count_Max_R8x6  =  12'b010000100000,   // 800+40+128+ 88=1056
	parameter [REZ_MAX_WIDTH-1:0] V_Count_Max_R10x7 =  12'b001100100110,   // 768+ 3+  6+ 29= 806
    parameter [REZ_MAX_WIDTH-1:0] H_Count_Max_R10x7 =  12'b101010000000    //1024+24+136+160=1344