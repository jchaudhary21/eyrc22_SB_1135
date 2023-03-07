
module SB_1135_intergratedCode (

//  Global clock 
    input clk ,
    
//  Line Sensor I/O ports 
    input  adc_data ,
	output adc_chip_select ,
	output adc_address ,
	output adc_clk ,
	
//  Color Sensor I/O port 
	input colour_freq,
	output red_led,
	output blue_led,
	output s2,
	output s3,
	output green_led ,
    output LEFT_SERVO ,
    output GRIPPER_SERVO,

//  Wheel Pin  
    output RW_F ,   // RIGHT WHEEL FRONT 
    output RW_B ,   // RIGHT WHEEL BACK 
    output LW_F ,   // LEFT WHEEL FRONT 
    output LW_B ,   // LEFT WHEEL BACK 


// Led to indicate status  
    output LEDL ,
    output LEDC ,
    output LEDR ,


// Leds which are used as bit to show which case is high  
    output BIT0 ,
    output BIT1 ,
    output BIT2 ,
    output BIT3 
    
) ;



//                       ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~  COLOR SENSOR STARTS FROM HERE ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~


reg temp_col_freq;

reg [50:0] act_freq_cnt1 = 0;
reg [50:0] cnt_freq_str1 = 0;
reg [50:0] act_freq_cnt2 = 0;
reg [50:0] cnt_freq_str2 = 0;
reg [50:0] act_freq_cnt3 = 0;
reg [50:0] cnt_freq_str3 = 0;
reg [50:0] act_freq_cnt4 = 0;
reg [50:0] cnt_freq_str4 = 0;

reg [50:0] new_act_freq_cnt1 = 0;
reg [50:0] new_act_freq_cnt2 = 0;
reg [50:0] new_act_freq_cnt3 = 0;
reg [50:0] new_act_freq_cnt4 = 0;

reg [50:0] sum = 0;
reg [50:0] avg = 0;

reg s2f = 0;
reg s3f = 0;
assign s2 = s2f;
assign s3 = s3f;

reg rled=0;
reg gled=0;
reg bled=0;
assign red_led = rled;
assign green_led =gled;
assign blue_led = bled;

reg [50:0] COUNT_RED = 0;
reg [50:0] COUNT_GREEN = 0;
reg [50:0] COUNT_BLUE = 0;

reg [50:0] count_1 = 0;
reg [50:0] count_2 = 0;
reg [50:0] count_3 = 0;
reg [50:0] count_4 = 0;
reg [50:0] final_val1 = 0;
reg [50:0] final_val2 = 0;
reg [50:0] final_val3 = 0;
reg [50:0] final_val4 = 0;
reg [50:0] check_counter1r = 0;
reg [50:0] check_counter2r = 0;
reg [50:0] check_counter3r = 0;
reg [50:0] check_counter4r = 0;
reg [50:0] check_counter1g = 0;
reg [50:0] check_counter2g = 0;
reg [50:0] check_counter3g = 0;
reg [50:0] check_counter4g = 0;
reg [50:0] check_counter1b = 0;
reg [50:0] check_counter2b = 0;
reg [50:0] check_counter3b = 0;
reg [50:0] check_counter4b = 0;


reg [50:0] red_delay       = 0;
reg [50:0] blue_delay      = 0;
reg [50:0] green_delay     = 0;
reg [50:0] global_count    = 0;
reg [25:0] count_servo_mov = 0;



always @ (posedge clk )
begin


// starting global count for generating 16 sample values for each filter and checking there occurances wrt to the given range of each colour
if (global_count <5000000 ) begin
	if (s2f ==0 & s3f == 0 ) begin
		if (count_1 < 78125)begin
			temp_col_freq <= colour_freq;
			if (colour_freq)
				cnt_freq_str1 <= cnt_freq_str1 + 1;
			else if (temp_col_freq) begin
				act_freq_cnt1 <= cnt_freq_str1;
				cnt_freq_str1 <= 0;
			end
			count_1 = count_1+1;
		end
		else begin
				count_1 = 0;
				s2f = 1;
				s3f = 1;
				new_act_freq_cnt1 = new_act_freq_cnt1 + act_freq_cnt1;
				final_val1 = new_act_freq_cnt1;
							if (2000 < act_freq_cnt1 &  3000 > act_freq_cnt1)begin
					check_counter1r = check_counter1r+1;end
			if (2800 < act_freq_cnt1 &  4000 > act_freq_cnt1)begin
					check_counter1g = check_counter1g+1;	end
			if (6500 < act_freq_cnt1 &  10000 > act_freq_cnt1)begin
					check_counter1b = check_counter1b+1;	end
			end

	end
	
		if (s2f ==1 & s3f == 1 ) begin
		if (count_2 < 78125)begin
			temp_col_freq <= colour_freq;
			if (colour_freq)
				cnt_freq_str2 <= cnt_freq_str2 + 1;
			else if (temp_col_freq) begin
				act_freq_cnt2 <= cnt_freq_str2;
				cnt_freq_str2 <= 0;
			end
			count_2 = count_2+1;
		end
		else begin
				count_2 = 0;
				s2f = 1;
				s3f = 0;
				new_act_freq_cnt2 = new_act_freq_cnt2 + act_freq_cnt2;
				final_val2 = new_act_freq_cnt2;
				if (8000 < act_freq_cnt2 &  10200 > act_freq_cnt2)begin
					check_counter2r = check_counter2r+1;end
			if (2000 < act_freq_cnt2 & 3200 > act_freq_cnt2)begin
					check_counter2g = check_counter2g+1;	end
			if (5500 < act_freq_cnt2 &  7800 > act_freq_cnt2)begin
					check_counter2b = check_counter2b+1;	end
		end
	end
	
	if (s2f ==1 & s3f == 0 ) begin
		if (count_3 < 78125)begin
			temp_col_freq <= colour_freq;
			if (colour_freq)
				cnt_freq_str3 <= cnt_freq_str3 + 1;
			else if (temp_col_freq) begin
				act_freq_cnt3 <= cnt_freq_str3;
				cnt_freq_str3 <= 0;
			end
			count_3 = count_3+1;
		end
		else begin
				count_3 = 0;
				s2f = 0;
				s3f = 1;
				new_act_freq_cnt3 = new_act_freq_cnt3 + act_freq_cnt3;
				final_val3 = new_act_freq_cnt3;
			if (5800 < act_freq_cnt3 &  7000 > act_freq_cnt3)begin
					check_counter3r = check_counter3r+1;end
			if (4500 < act_freq_cnt3 &  5500 > act_freq_cnt3)begin
					check_counter3g = check_counter3g+1;	end
			if (2000 < act_freq_cnt3 &  3900 > act_freq_cnt3)begin
					check_counter3b = check_counter3b+1;	end
			end
	end
	
	if (s2f ==0 & s3f == 1 ) begin
		if (count_4 < 78125)begin
			temp_col_freq <= colour_freq;
			if (colour_freq)
				cnt_freq_str4 <= cnt_freq_str4 + 1;
			else if (temp_col_freq) begin
				act_freq_cnt4 <= cnt_freq_str4;
				cnt_freq_str4 <= 0;

			end
			count_4 = count_4+1;
		end
		else begin
				count_4 = 0;
				s2f = 0;
				s3f = 0;
				new_act_freq_cnt4 = new_act_freq_cnt4 + act_freq_cnt4;
				final_val4 = new_act_freq_cnt4;
			if (1300 < act_freq_cnt4 &  2200 > act_freq_cnt4)begin
					check_counter4r = check_counter4r+1;end
			if (1300 < act_freq_cnt4 &  1500 > act_freq_cnt4)begin
					check_counter4g = check_counter4g+1;	end
			if (800 < act_freq_cnt4 &  1300 > act_freq_cnt4)begin
					check_counter4b = check_counter4b+1;	end
			end
	end
	global_count = global_count +1 ;
end
else begin
sum = (final_val1 >> 4)+(final_val2 >> 4)+(final_val3 >> 4)+(final_val4 >> 4);
avg = sum >> 2;
COUNT_RED = check_counter1r+check_counter2r+check_counter3r+check_counter4r;
COUNT_GREEN = check_counter1g+check_counter2g+check_counter3g+check_counter4g;
COUNT_BLUE = check_counter1b+check_counter2b+check_counter3b+check_counter4b;

global_count = 0 ;
new_act_freq_cnt1 = 0;
new_act_freq_cnt2= 0;
new_act_freq_cnt3= 0;
new_act_freq_cnt4= 0;
check_counter1b = 0;
check_counter2b = 0;
check_counter3b = 0;
check_counter4b = 0;
check_counter1r = 0;
check_counter2r = 0;
check_counter3r = 0;
check_counter4r = 0;
check_counter1g = 0;
check_counter2g = 0;
check_counter3g = 0;
check_counter4g = 0;

end
end


//                       ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~  COLOR SENSOR END HERE ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 



//                       ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~  PATH PLANNING STARTS FROM HERE ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 

/////////////// ____ MAP STORE IN LIST _______  //////////////
	
localparam 
				north        = 3'b000 ,        
				east         = 3'b001 ,   
				south        = 3'b010 ,   
				west         = 3'b011 ,   
                northeast    = 3'b100 ,                    // local param to define various terms 
				southwest    = 3'b100 ,                
				no_direction = 3'b111 ,   
				
				straight     =  4'b1000 , 
				left         =  4'b1001 , 
			    right        =  4'b1010 , 
			    dgr_180_R    =  4'b1011 , 
				dgr_180_L    =  4'b1100 ; 

				
reg [10:0]  inf = 100 ;                                // infinity taken as 100 
				

reg [10:0] adjacent_nodes[25:0][3:0] ;
reg [10:0] path_of_adjacent_nodes[25:0][3:0] ;        // array to store maps parameters 
reg [10:0] final_heading [25:0][3:0] ;     
reg [10:0] turn_to_reach [25:0][3:0] ;	
reg [10:0] turns_map [6:0][6:0]  ;
	
 
reg flag_initalize_map  = 1 ;                         // flag to initialize map one time 
	          

always @ ( posedge clk )
begin

	if (flag_initalize_map == 1 )
	begin
	
	// node 0 : 
	
	adjacent_nodes         [0][0] = 1            ; adjacent_nodes         [0][1] = 26           ; adjacent_nodes         [0][2] = 26           ; adjacent_nodes         [0][3] = 26;
    path_of_adjacent_nodes [0][0] = 3            ; path_of_adjacent_nodes [0][1] = inf          ; path_of_adjacent_nodes [0][2] = inf          ; path_of_adjacent_nodes [0][3] = inf ;
	final_heading          [0][0] = east         ; final_heading          [0][1] = no_direction ; final_heading          [0][2] = no_direction ; final_heading          [0][3] = no_direction ; 
	turn_to_reach          [0][0] = south        ; turn_to_reach          [0][1] = no_direction ; turn_to_reach          [0][2] = no_direction ; turn_to_reach          [0][3] = no_direction ; 

   // node 1 : 
	
	adjacent_nodes         [1][0] = 0             ; adjacent_nodes         [1][1] = 2            ; adjacent_nodes         [1][2] = 13           ; adjacent_nodes         [1][3] = 26;
    path_of_adjacent_nodes [1][0] = 3             ; path_of_adjacent_nodes [1][1] = 3            ; path_of_adjacent_nodes [1][2] = 3            ; path_of_adjacent_nodes [1][3] = inf ;
	final_heading          [1][0] = north         ; final_heading          [1][1] = south        ; final_heading          [1][2] = east         ; final_heading          [1][3] = no_direction ; 
	turn_to_reach          [1][0] = west          ; turn_to_reach          [1][1] = south        ; turn_to_reach          [1][2] = east         ; turn_to_reach          [1][3] = no_direction ; 

	// node 2 : 
	
	adjacent_nodes         [2][0] = 1             ; adjacent_nodes         [2][1] = 3            ; adjacent_nodes         [2][2] = 5            ; adjacent_nodes         [2][3] = 26;
    path_of_adjacent_nodes [2][0] = 3             ; path_of_adjacent_nodes [2][1] = 1            ; path_of_adjacent_nodes [2][2] = 3            ; path_of_adjacent_nodes [2][3] = inf ;
	final_heading          [2][0] = north         ; final_heading          [2][1] = east         ; final_heading          [2][2] = south        ; final_heading          [2][3] = no_direction ; 
	turn_to_reach          [2][0] = north         ; turn_to_reach          [2][1] = east         ; turn_to_reach          [2][2] = south        ; turn_to_reach          [2][3] = no_direction ; 

	// node 3 : 
	
	adjacent_nodes         [3][0] = 2             ; adjacent_nodes         [3][1] = 26           ; adjacent_nodes         [3][2] = 26           ; adjacent_nodes         [3][3] = 26;
    path_of_adjacent_nodes [3][0] = 1             ; path_of_adjacent_nodes [3][1] = inf          ; path_of_adjacent_nodes [3][2] = inf          ; path_of_adjacent_nodes [3][3] = inf ;
	final_heading          [3][0] = west          ; final_heading          [3][1] = no_direction ; final_heading          [3][2] = no_direction ; final_heading          [3][3] = no_direction ; 
	turn_to_reach          [3][0] = west          ; turn_to_reach          [3][1] = no_direction ; turn_to_reach          [3][2] = no_direction ; turn_to_reach          [3][3] = no_direction ; 

	// node 4 : 
	
	adjacent_nodes         [4][0] = 6             ; adjacent_nodes         [4][1] = 26           ; adjacent_nodes         [4][2] = 26           ; adjacent_nodes         [4][3] = 26;
    path_of_adjacent_nodes [4][0] = 3             ; path_of_adjacent_nodes [4][1] = inf          ; path_of_adjacent_nodes [4][2] = inf          ; path_of_adjacent_nodes [4][3] = inf ;
	final_heading          [4][0] = northeast     ; final_heading          [4][1] = no_direction ; final_heading          [4][2] = no_direction ; final_heading          [4][3] = no_direction ; 
	turn_to_reach          [4][0] = south         ; turn_to_reach          [4][1] = no_direction ; turn_to_reach          [4][2] = no_direction ; turn_to_reach          [4][3] = no_direction ; 

	// node 5 : 
	
	adjacent_nodes         [5][0] = 2             ; adjacent_nodes         [5][1] =  6           ; adjacent_nodes         [5][2] = 9            ; adjacent_nodes         [5][3] = 26;
    path_of_adjacent_nodes [5][0] = 3             ; path_of_adjacent_nodes [5][1] =  1           ; path_of_adjacent_nodes [5][2] = 2            ; path_of_adjacent_nodes [5][3] = inf ;
	final_heading          [5][0] = north         ; final_heading          [5][1] = south        ; final_heading          [5][2] = east         ; final_heading          [5][3] = no_direction ; 
	turn_to_reach          [5][0] = north         ; turn_to_reach          [5][1] = south        ; turn_to_reach          [5][2] = east         ; turn_to_reach          [5][3] = no_direction ; 

	// node 6 : 
	
	adjacent_nodes         [6][0] = 4             ; adjacent_nodes         [6][1] = 5            ; adjacent_nodes         [6][2] =  16          ; adjacent_nodes         [6][3] = 26;
    path_of_adjacent_nodes [6][0] = 3             ; path_of_adjacent_nodes [6][1] = 1            ; path_of_adjacent_nodes [6][2] =  3           ; path_of_adjacent_nodes [6][3] = inf ;
	final_heading          [6][0] = north         ; final_heading          [6][1] = north        ; final_heading          [6][2] = east         ; final_heading          [6][3] = no_direction ; 
	turn_to_reach          [6][0] = southwest     ; turn_to_reach          [6][1] = north        ; turn_to_reach          [6][2] = east         ; turn_to_reach          [6][3] = no_direction ; 

	// node 7 : 
	
	adjacent_nodes         [7][0] = 12            ; adjacent_nodes         [7][1] = 26           ; adjacent_nodes         [7][2] = 26           ; adjacent_nodes         [7][3] = 26;
    path_of_adjacent_nodes [7][0] = 2             ; path_of_adjacent_nodes [7][1] = inf          ; path_of_adjacent_nodes [7][2] = inf          ; path_of_adjacent_nodes [7][3] = inf ;
	final_heading          [7][0] = east          ; final_heading          [7][1] = no_direction ; final_heading          [7][2] = no_direction ; final_heading          [7][3] = no_direction ; 
	turn_to_reach          [7][0] = south         ; turn_to_reach          [7][1] = no_direction ; turn_to_reach          [7][2] = no_direction ; turn_to_reach          [7][3] = no_direction ; 

	// node 8 : 
	
	adjacent_nodes         [8][0] = 9             ; adjacent_nodes         [8][1] = 26           ; adjacent_nodes         [8][2] = 26           ; adjacent_nodes         [8][3] = 26;
    path_of_adjacent_nodes [8][0] = 1             ; path_of_adjacent_nodes [8][1] = inf          ; path_of_adjacent_nodes [8][2] = inf          ; path_of_adjacent_nodes [8][3] = inf ;
	final_heading          [8][0] = south         ; final_heading          [8][1] = no_direction ; final_heading          [8][2] = no_direction ; final_heading          [8][3] = no_direction ; 
	turn_to_reach          [8][0] = south         ; turn_to_reach          [8][1] = no_direction ; turn_to_reach          [8][2] = no_direction ; turn_to_reach          [8][3] = no_direction ; 

	// node 9 : 
	
	adjacent_nodes         [9][0] = 8             ; adjacent_nodes         [9][1] = 5            ; adjacent_nodes         [9][2] = 15           ; adjacent_nodes         [9][3] = 26;
    path_of_adjacent_nodes [9][0] = 1             ; path_of_adjacent_nodes [9][1] = 2            ; path_of_adjacent_nodes [9][2] = 1            ; path_of_adjacent_nodes [9][3] = inf ;
	final_heading          [9][0] = north         ; final_heading          [9][1] = west         ; final_heading          [9][2] = east         ; final_heading          [9][3] = no_direction ; 
	turn_to_reach          [9][0] = north         ; turn_to_reach          [9][1] = west         ; turn_to_reach          [9][2] = east         ; turn_to_reach          [9][3] = no_direction ; 

	// node 10 : 
	
	adjacent_nodes         [10][0] = 16            ; adjacent_nodes         [10][1] = 26           ; adjacent_nodes         [10][2] = 26           ; adjacent_nodes         [10][3] = 26;
    path_of_adjacent_nodes [10][0] = 2             ; path_of_adjacent_nodes [10][1] = inf          ; path_of_adjacent_nodes [10][2] = inf          ; path_of_adjacent_nodes [10][3] = inf ;
	final_heading          [10][0] = south         ; final_heading          [10][1] = no_direction ; final_heading          [10][2] = no_direction ; final_heading          [10][3] = no_direction ; 
	turn_to_reach          [10][0] = east          ; turn_to_reach          [10][1] = no_direction ; turn_to_reach          [10][2] = no_direction ; turn_to_reach          [10][3] = no_direction ; 

	// node 11 : 
	
	adjacent_nodes         [11][0] = 12            ; adjacent_nodes         [11][1] = 26           ; adjacent_nodes         [11][2] = 26           ; adjacent_nodes         [11][3] = 26;
    path_of_adjacent_nodes [11][0] = 3             ; path_of_adjacent_nodes [11][1] = inf          ; path_of_adjacent_nodes [11][2] = inf          ; path_of_adjacent_nodes [11][3] = inf ;
	final_heading          [11][0] = south         ; final_heading          [11][1] = no_direction ; final_heading          [11][2] = no_direction ; final_heading          [11][3] = no_direction ; 
	turn_to_reach          [11][0] = west          ; turn_to_reach          [11][1] = no_direction ; turn_to_reach          [11][2] = no_direction ; turn_to_reach          [11][3] = no_direction ; 

	// node 12 : 
	
	adjacent_nodes         [12][0] = 7             ; adjacent_nodes         [12][1] = 11           ; adjacent_nodes         [12][2] = 17           ; adjacent_nodes         [12][3] = 13;
    path_of_adjacent_nodes [12][0] = 2             ; path_of_adjacent_nodes [12][1] = 3            ; path_of_adjacent_nodes [12][2] = 3            ; path_of_adjacent_nodes [12][3] = 1 ;
	final_heading          [12][0] = north         ; final_heading          [12][1] = east         ; final_heading          [12][2] = east         ; final_heading          [12][3] = south ; 
	turn_to_reach          [12][0] = west          ; turn_to_reach          [12][1] = north        ; turn_to_reach          [12][2] = east         ; turn_to_reach          [12][3] = south ; 

	// node 13 : 
	
	adjacent_nodes         [13][0] = 1             ; adjacent_nodes         [13][1] = 18           ; adjacent_nodes         [13][2] = 12           ; adjacent_nodes         [13][3] = 26;
    path_of_adjacent_nodes [13][0] = 3             ; path_of_adjacent_nodes [13][1] = 2            ; path_of_adjacent_nodes [13][2] = 1            ; path_of_adjacent_nodes [13][3] = inf ;
	final_heading          [13][0] = west          ; final_heading          [13][1] = east         ; final_heading          [13][2] = north        ; final_heading          [13][3] = no_direction ; 
	turn_to_reach          [13][0] = west          ; turn_to_reach          [13][1] = east         ; turn_to_reach          [13][2] = north        ; turn_to_reach          [13][3] = no_direction ; 

	// node 14 : 
	
	adjacent_nodes         [14][0] = 15            ; adjacent_nodes         [14][1] = 26           ; adjacent_nodes         [14][2] = 26           ; adjacent_nodes         [14][3] = 26;
    path_of_adjacent_nodes [14][0] = 1             ; path_of_adjacent_nodes [14][1] = inf          ; path_of_adjacent_nodes [14][2] = inf          ; path_of_adjacent_nodes [14][3] = inf ;
	final_heading          [14][0] = south         ; final_heading          [14][1] = no_direction ; final_heading          [14][2] = no_direction ; final_heading          [14][3] = no_direction ; 
	turn_to_reach          [14][0] = south         ; turn_to_reach          [14][1] = no_direction ; turn_to_reach          [14][2] = no_direction ; turn_to_reach          [14][3] = no_direction ; 

	// node 15 : 
	
	adjacent_nodes         [15][0] = 22            ; adjacent_nodes         [15][1] = 9            ; adjacent_nodes         [15][2] = 14           ; adjacent_nodes         [15][3] = 26;
    path_of_adjacent_nodes [15][0] = 1             ; path_of_adjacent_nodes [15][1] = 1            ; path_of_adjacent_nodes [15][2] = 1            ; path_of_adjacent_nodes [15][3] = inf ;
	final_heading          [15][0] = east          ; final_heading          [15][1] = west         ; final_heading          [15][2] = north        ; final_heading          [15][3] = no_direction ; 
	turn_to_reach          [15][0] = east          ; turn_to_reach          [15][1] = west         ; turn_to_reach          [15][2] = north        ; turn_to_reach          [15][3] = no_direction ; 

	// node 16 : 
	
	adjacent_nodes         [16][0] = 10            ; adjacent_nodes         [16][1] = 23           ; adjacent_nodes         [16][2] =  6           ; adjacent_nodes         [16][3] = 26;
    path_of_adjacent_nodes [16][0] = 2             ; path_of_adjacent_nodes [16][1] = 2            ; path_of_adjacent_nodes [16][2] = 3            ; path_of_adjacent_nodes [16][3] = inf ;
	final_heading          [16][0] = west          ; final_heading          [16][1] = north        ; final_heading          [16][2] = north        ; final_heading          [16][3] = no_direction ; 
	turn_to_reach          [16][0] = north         ; turn_to_reach          [16][1] = east         ; turn_to_reach          [16][2] = west         ; turn_to_reach          [16][3] = no_direction ; 

	// node 17 : 
	
	adjacent_nodes         [17][0] = 12            ; adjacent_nodes         [17][1] = 26           ; adjacent_nodes         [17][2] = 26           ; adjacent_nodes         [17][3] = 26;
    path_of_adjacent_nodes [17][0] = 3             ; path_of_adjacent_nodes [17][1] = inf          ; path_of_adjacent_nodes [17][2] = inf          ; path_of_adjacent_nodes [17][3] = inf ;
	final_heading          [17][0] = west          ; final_heading          [17][1] = no_direction ; final_heading          [17][2] = no_direction ; final_heading          [17][3] = no_direction ; 
	turn_to_reach          [17][0] = west          ; turn_to_reach          [17][1] = no_direction ; turn_to_reach          [17][2] = no_direction ; turn_to_reach          [17][3] = no_direction ; 

	// node 18 : 
	
	adjacent_nodes         [18][0] = 19            ; adjacent_nodes         [18][1] = 13           ; adjacent_nodes         [18][2] = 20           ; adjacent_nodes         [18][3] = 26;
    path_of_adjacent_nodes [18][0] = 1             ; path_of_adjacent_nodes [18][1] = 2            ; path_of_adjacent_nodes [18][2] = 1            ; path_of_adjacent_nodes [18][3] = inf ;
	final_heading          [18][0] = east          ; final_heading          [18][1] = west         ; final_heading          [18][2] = south		  ; final_heading          [18][3] = no_direction ; 
	turn_to_reach          [18][0] = east          ; turn_to_reach          [18][1] = west         ; turn_to_reach          [18][2] = south        ; turn_to_reach          [18][3] = no_direction ; 

	// node 19 : 
	
	adjacent_nodes         [19][0] = 18            ; adjacent_nodes         [19][1] = 26           ; adjacent_nodes         [19][2] = 26           ; adjacent_nodes         [19][3] = 26;
    path_of_adjacent_nodes [19][0] = 1             ; path_of_adjacent_nodes [19][1] = inf          ; path_of_adjacent_nodes [19][2] = inf          ; path_of_adjacent_nodes [19][3] = inf ;
	final_heading          [19][0] = west          ; final_heading          [19][1] = no_direction ; final_heading          [19][2] = no_direction ; final_heading          [19][3] = no_direction ; 
	turn_to_reach          [19][0] = west          ; turn_to_reach          [19][1] = no_direction ; turn_to_reach          [19][2] = no_direction ; turn_to_reach          [19][3] = no_direction ; 

	// node 20 : 
	
	adjacent_nodes         [20][0] = 21            ; adjacent_nodes         [20][1] = 18           ; adjacent_nodes         [20][2] = 22           ; adjacent_nodes         [20][3] = 26;
    path_of_adjacent_nodes [20][0] = 1             ; path_of_adjacent_nodes [20][1] = 1            ; path_of_adjacent_nodes [20][2] = 2            ; path_of_adjacent_nodes [20][3] = inf ;
	final_heading          [20][0] = east          ; final_heading          [20][1] = north        ; final_heading          [20][2] = south        ; final_heading          [20][3] = no_direction ; 
	turn_to_reach          [20][0] = east          ; turn_to_reach          [20][1] = north        ; turn_to_reach          [20][2] = south        ; turn_to_reach          [20][3] = no_direction ; 


	// node 21 : 
	
	adjacent_nodes         [21][0] = 20            ; adjacent_nodes         [21][1] = 26           ; adjacent_nodes         [21][2] = 26           ; adjacent_nodes         [21][3] = 26;
    path_of_adjacent_nodes [21][0] = 1             ; path_of_adjacent_nodes [21][1] = inf          ; path_of_adjacent_nodes [21][2] = inf          ; path_of_adjacent_nodes [21][3] = inf ;
	final_heading          [21][0] = west          ; final_heading          [21][1] = no_direction ; final_heading          [21][2] = no_direction ; final_heading          [21][3] = no_direction ; 
	turn_to_reach          [21][0] = west          ; turn_to_reach          [21][1] = no_direction ; turn_to_reach          [21][2] = no_direction ; turn_to_reach          [21][3] = no_direction ; 

	// node 22 : 
	
	adjacent_nodes         [22][0] = 15            ; adjacent_nodes         [22][1] = 20           ; adjacent_nodes         [22][2] = 25           ; adjacent_nodes         [22][3] = 23;
    path_of_adjacent_nodes [22][0] = 1             ; path_of_adjacent_nodes [22][1] = 2            ; path_of_adjacent_nodes [22][2] = 3            ; path_of_adjacent_nodes [22][3] = 1 ;
	final_heading          [22][0] = west          ; final_heading          [22][1] = north        ; final_heading          [22][2] = south        ; final_heading          [22][3] = south ; 
	turn_to_reach          [22][0] = west          ; turn_to_reach          [22][1] = north        ; turn_to_reach          [22][2] = east         ; turn_to_reach          [22][3] = south ; 

	// node 23 : 
	
	adjacent_nodes         [23][0] = 24            ; adjacent_nodes         [23][1] = 22           ; adjacent_nodes         [23][2] = 16           ; adjacent_nodes         [23][3] = 26;
    path_of_adjacent_nodes [23][0] = 2             ; path_of_adjacent_nodes [23][1] = 1            ; path_of_adjacent_nodes [23][2] = 2            ; path_of_adjacent_nodes [23][3] = inf ;
	final_heading          [23][0] = south         ; final_heading          [23][1] = north        ; final_heading          [23][2] = west         ; final_heading          [23][3] = no_direction ; 
	turn_to_reach          [23][0] = west          ; turn_to_reach          [23][1] = north        ; turn_to_reach          [23][2] = south        ; turn_to_reach          [23][3] = no_direction ; 

	// node 24 : 
	
	adjacent_nodes         [24][0] = 23            ; adjacent_nodes         [24][1] = 26           ; adjacent_nodes         [24][2] = 26           ; adjacent_nodes         [24][3] = 26;
    path_of_adjacent_nodes [24][0] = 2             ; path_of_adjacent_nodes [24][1] = inf          ; path_of_adjacent_nodes [24][2] = inf          ; path_of_adjacent_nodes [24][3] = inf ;
	final_heading          [24][0] = west          ; final_heading          [24][1] = no_direction ; final_heading          [24][2] = no_direction ; final_heading          [24][3] = no_direction ; 
	turn_to_reach          [24][0] = north         ; turn_to_reach          [24][1] = no_direction ; turn_to_reach          [24][2] = no_direction ; turn_to_reach          [24][3] = no_direction ; 

	// node 25 : 
	
	adjacent_nodes         [25][0] = 22            ; adjacent_nodes         [25][1] = 26           ; adjacent_nodes         [25][2] = 26           ; adjacent_nodes         [25][3] = 26;
    path_of_adjacent_nodes [25][0] = 3             ; path_of_adjacent_nodes [25][1] = inf          ; path_of_adjacent_nodes [25][2] = inf          ; path_of_adjacent_nodes [25][3] = inf ;
	final_heading          [25][0] = west          ; final_heading          [25][1] = no_direction ; final_heading          [25][2] = no_direction ; final_heading          [25][3] = no_direction ; 
	turn_to_reach          [25][0] = north         ; turn_to_reach          [25][1] = no_direction ; turn_to_reach          [25][2] = no_direction ; turn_to_reach          [25][3] = no_direction ; 
   
	
	
	// north
	
	turns_map [north][north]         = straight  ; turns_map [north][east]          = right     ; turns_map [north][west]     = left      ; turns_map [north][south]     = dgr_180_R ;
	turns_map [north][northeast]     = right     ; turns_map [north][southwest]     = dgr_180_L ;
	
	
	// north
	
	turns_map [east][north]          = left      ; turns_map [east][east]           = straight  ; turns_map [east][west]      = dgr_180_R ; turns_map [east][south]      = right     ; 
	turns_map [east][northeast]      = left      ; turns_map [east][southwest]      = dgr_180_R ;
	
	
	// west
	
	turns_map [west][north]          = right     ; turns_map [west][east]           = dgr_180_R ; turns_map [west][west]      = straight  ; turns_map [west][south]      = left      ; 
   turns_map [west][northeast]      = dgr_180_R ; turns_map [west][southwest]      = left      ;   

	// south
	
	turns_map [south][north]         = dgr_180_R ; turns_map [south][east]          = left      ; turns_map [south][west]     = right     ; turns_map [south][south]     = straight  ;
   turns_map [south][northeast]     = dgr_180_L ; turns_map [south][southwest]     = right     ;
	
	// northeast
	
	turns_map [northeast][north]     = left      ; turns_map [northeast][east]      = right     ; turns_map [northeast][west] = dgr_180_L ; turns_map [northeast][south] = dgr_180_R ; 
   turns_map [northeast][northeast] = straight  ; turns_map [northeast][southwest] = dgr_180_R ;
	
	// southwest
	
	turns_map [southwest][north]     = dgr_180_R ; turns_map [southwest][east]      = dgr_180_L ; turns_map [southwest][west] = right     ; turns_map [southwest][south] = left      ;
   turns_map [southwest][northeast] = dgr_180_R ; turns_map [southwest][southwest] = straight  ;

	
   flag_initalize_map = 0 ;

	end
end


//                   ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~  ADC I/O   ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 	


// ___ adc clock declarations ___ 
reg    [4:0]counter_25  = 5'b0 ;
reg    clk_adc          = 0    ;
assign adc_clk          = clk_adc   ;


// ___ adc chip select declarations ___ 
reg    [1:0] chip_select_adc  = 2'b0 ;
assign adc_chip_select        = chip_select_adc ;


// ___ adc address declarations ____ 
reg    address_adc            = 0 ;
assign adc_address            = address_adc ;
reg    [4:0] adc_bit_counter  = 5'b00 ;         // count bit in a 16 cycle frame 

localparam 
			df_1 = 2'b01 ,    // dataframe for channel 1  --- 16 bit 
			df_2 = 2'b10 ,    // dataframe for channel 2  --- 16 bit 
			df_3 = 2'b11 ;    // dataframe for channel 3  --- 16 bit 
				
reg [1:0] adc_sm_address  = df_1 ;         // initalizing state machine with df_1 

localparam 
            channel_1 = 2'b01 ,
			channel_2 = 2'b10 ,
			channel_3 = 2'b11 ;

reg [4:0] adc_sm_channel_data  = channel_1 ;


// ____ adc data declarations ____
reg [11:0] L_linesensor = 0 ; 		  
reg [11:0] C_linesensor = 0 ;         	
reg [11:0] R_linesensor = 0 ;         



reg [11:0]Data_1 = 0; 
reg [11:0]Data_2 = 0;
reg [11:0]Data_3 = 0;

localparam 
            data_1 = 2'b01 ,
			data_2 = 2'b10 ,
			data_3 = 2'b11 ;
				
reg [1:0] adc_sm_data  = data_1 ;
reg [11:0] white_threshold =  1900 ; 


// ____ flag to allow data transfer and avg_channel_value ____ 
reg [8:0]  counter_avg = 0 ;

reg [15:0] inter_L_value = 0 ;
reg [15:0] inter_C_value = 0 ;
reg [15:0] inter_R_value = 0 ;
 
reg [11:0] avg_L_value = 0 ;
reg [11:0] avg_C_value = 0 ;
reg [11:0] avg_R_value = 0 ;





//                                               ____ 2.5 MHz CLOCK FOR ADC ____  
always @ (negedge clk )
begin	
       
  /* Description

                : This section is use to convert 50 MHz to 2.5 MHz clock so that it can be provided to adc clock  
                
				: As 50 / 2.5 = 20 & 20/2 = 10 ,  so after every 10 clock cycle of 50 MHz a high or low signal is generated to form 2.5 MHz clock 
   */


		if ( counter_25 == 5'b0 | counter_25 == 5'b10100)
		begin
   		    clk_adc     = 0    ;
			counter_25  = 5'b0 ;
		end 
		
		else if ( counter_25 == 5'b01010) 
		begin
      	    clk_adc = 1 ;
		end
		
		counter_25 = 5'b1 + counter_25 ;
end





//                                      ____ DATA COLLECTION AND MANIPULATION FOR ADC ____  
always @ (negedge clk_adc)
begin

   /* Description

                : This state machine is used to sequentially address data to adc chip
                    so that in next cycle frame data from this channel can be obtain . 

                : It get triggered when adc_bit_counter reaches count 01 , 02 and 03 .  

				: Highly count sensitive change parameter with caution . 

				: df - data frame 
				  address_adc - output pin connected to adc address pin 
				  adc_sm_address  - state machine select input .  

   */
	if (adc_bit_counter == 5'b01 | adc_bit_counter == 5'b10 | adc_bit_counter == 5'b011)
	begin                                                          
		case (adc_sm_address )
			
			df_1 : begin
			if      (adc_bit_counter == 5'b01)  begin address_adc = 1 ; end 
			else if (adc_bit_counter == 5'b10)  begin address_adc = 0 ; end 
			else if (adc_bit_counter == 5'b011) begin address_adc = 1 ; adc_sm_address  = df_2; end 
			       end 
					 
			df_2 : begin
			if      (adc_bit_counter == 5'b01)  begin address_adc = 1 ; end 
			else if (adc_bit_counter == 5'b10)  begin address_adc = 1 ; end 
			else if (adc_bit_counter == 5'b011) begin address_adc = 0 ; adc_sm_address  = df_3 ; end 
			       end 
					 
			df_3 : begin
			if      (adc_bit_counter == 5'b01)  begin address_adc = 1 ; end 
			else if (adc_bit_counter == 5'b10)  begin address_adc = 1 ; end 
			else if (adc_bit_counter == 5'b011) begin address_adc = 1 ; adc_sm_address  = df_1 ;end 
			      end
	endcase 
	end
	


    /* Description :
	            : This state machine get triggered when adc_bit_countre reaches count 04

				: Data 1 - Variable to store data of channel 1 - Left line sensor  
				  Data 2 - Variable to store data of channel 2 - Centre line sensor
				  Data 3 - Variable to store data of channel 3 - Right line sensor      
                  adc_data -  input pin connected with adc output 

				: Right shift fn is performed so to clear out previous data and to store new data bit wise 
                
				: count sensitive change parameter with caution . 
    */
	if (adc_bit_counter >= 5'b100)
	begin
		case (adc_sm_data )
			
			data_1 : begin	
						Data_1 = Data_1 << 1 ;
						Data_1 = Data_1 + adc_data ;
			         end
			
			
			data_2 : begin	
						Data_2 = Data_2 << 1 ;
						Data_2 = Data_2 + adc_data ;
			         end
			
			data_3 : begin	
						Data_3 = Data_3 << 1 ;
						Data_3 = Data_3 + adc_data ;
			         end
	endcase 	
	end
	
	


   /*  Description :   
                : This section is used to store data of respective channel  


   */
	if (adc_bit_counter == 5'b00 | adc_bit_counter == 5'b10000 )
	begin
		case (adc_sm_channel_data)
		
		channel_1 : 
		            begin
					L_linesensor         = Data_1  ;
					adc_sm_channel_data  = channel_2 ;
					adc_sm_data          = data_2 ;
					end
						
						
		channel_2 :
					begin 
					C_linesensor         = Data_2  ;
					adc_sm_channel_data  = channel_3 ;
					adc_sm_data          = data_3 ;
					end 
						
						
		channel_3 : 
					begin 
					R_linesensor         = Data_3 ;
					adc_sm_channel_data  = channel_1 ;
					adc_sm_data          = data_1 ;
				    end 				
						
		endcase
	 end
	
   /*  Description :   
                : This section is used to  add data from consecutive channel values . 
   */
    if ( counter_avg == 10 ) begin inter_L_value = 0 ; inter_C_value = 0 ; inter_R_value = 0 ;  end
    if ( counter_avg == 16 | counter_avg == 64 | counter_avg == 112 | counter_avg == 160  ) begin inter_L_value = inter_L_value + L_linesensor ; end
	if ( counter_avg == 32 | counter_avg == 80 | counter_avg == 128 | counter_avg == 176  ) begin inter_C_value = inter_C_value + C_linesensor ; end
	if ( counter_avg == 48 | counter_avg == 96 | counter_avg == 144 | counter_avg == 192  ) begin inter_R_value = inter_R_value + R_linesensor ; end
	


   /*  Description :   
                : This section is used to  manipulate data by taking mean of value  . 

				: And to reset counter 
   */
    if (counter_avg == 192 )
	begin
		avg_L_value = inter_L_value >> 2 ;
		avg_C_value = inter_C_value >> 2 ;
		avg_R_value = inter_R_value >> 2 ;

        if (avg_L_value <= white_threshold ) begin ledl = 1 ;  end
        if (avg_L_value > white_threshold )  begin ledl = 0 ;  end

        if (avg_C_value <= white_threshold ) begin ledc = 1 ; end
        if (avg_C_value > white_threshold )  begin ledc = 0 ; end

        if (avg_R_value <= white_threshold ) begin ledr = 1 ; end
        if (avg_R_value > white_threshold )  begin ledr = 0 ; end

		counter_avg = 0 ;
	end
   


   /*  Description :   
                : This section is used to to reset all adc counters and parameters .
   */
	if (adc_bit_counter == 5'b101)    
	begin
	   address_adc = 0 ;
	end 
	

	if (adc_bit_counter == 5'b10000)
	begin 
		adc_bit_counter = 0 ;		
	end
	


   /*  Description :   
                : This section is used to increase counter by value of 1  .
   */
	adc_bit_counter = adc_bit_counter + 1 ;
	counter_avg = counter_avg + 1 ;

end


//               ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~  END ADC I/O   ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 


reg rw_f  = 0;
reg rw_b  = 0;
reg lw_f  = 0;
reg lw_b  = 0;
assign RW_F = rw_f;
assign RW_B = rw_b;
assign LW_F = lw_f;
assign LW_B = lw_b;


reg ledl = 0 ;
reg ledc = 0 ;
reg ledr = 0 ;
assign LEDL =  ledl ;
assign LEDC =  ledc ;
assign LEDR =  ledr ;


reg bit0 = 0 ;
reg bit1 = 0 ;
reg bit2 = 0 ;
reg bit3 = 0 ;
assign BIT0 =  bit0 ;
assign BIT1 =  bit1 ;
assign BIT2 =  bit2 ;
assign BIT3 =  bit3 ;




reg [10:0] distance_from_starting_node[26:0] ;
reg [1:0]  status_flag[26:0] ;	
reg [10:0] previous_node[26:0] ;
reg [10:0] dirn_turns_list[26:0] ; 
reg [10:0] currt_heading[26:0] ;

reg flag_reset_list = 1 ;
reg flag_main_loop  = 0 ; 


reg map_setup = 1 ;

reg flag_sub_node = 0 ;
reg flag_update_startDistance = 1 ;
reg flag_trace_node = 0 ;


reg [10:0] pth_pln_cnt = 1 ;
reg [10:0] cumt_dis = 0 ;
reg [10:0] least_value = 100  ; 

reg [49:0]node_string  = 50'b11111111111111111111111111111111111111111111111111 ;
reg [49:0]string_turns = 50'b11111111111111111111111111111111111111111111111111 ;

///////////////////////////////////// |I|
                                   // |M| 
reg [10:0] strt_node    = 0  ;     // |P|  ---\ keep value of both
reg [10:0] current_node = 0  ;     // |o|  ---/ variable same 
                                   // |R| 
reg [4:0]  heading_ptr  = south ;  // |T|  ----> orientation of bot in physical world
reg [10:0] end_node  ;             // |A|  ----> it will take end node as last node define in string_point_to_visit   
                                   // |N| 
///////////////////////////////////// |T| 
//                        node10 -node9 -node 8 -node 7 -node 6 -node 5 -node 4 -node 3 -node 2 -node 1 ( 5 bit each )  
reg [49:0]string_point_to_visit  = 50'b11111111111111111111111111111111111111111000101000 ; // change bit to change destination bits     
reg [49:0] turns = 50'b11111111111111111111111111111111111111111111111111 ;









reg flag_decision  = 0 ;
reg flag_pwm       = 0 ;
reg flag_reset     = 1 ;
reg flag_wait      = 0 ;
reg flag_search    = 0 ;


reg flag_forward_mvt = 0 ;
reg flag_back_mvt    = 0 ;
reg flag_left_mvt    = 0 ;
reg flag_right_mvt   = 0 ;
reg flag_force_mvt   = 0 ;


reg flag_slight_forward_mvt  = 0 ;
reg flag_rotate_left         = 0 ;
reg flag_rotate_right        = 0 ;
reg flag_dgr_180_l           = 0 ;
reg flag_dgr_180_r           = 0 ; 
reg flag_straight_turn       = 0 ;


reg [8:0] cnt_case1 = 0 ;
reg [8:0] cnt_case2 = 0 ;  
reg [8:0] cnt_case3 = 0 ; 
reg [8:0] cnt_case4 = 0 ; 
reg [8:0] cnt_case5 = 0 ; 
reg [8:0] cnt_case6 = 0 ; 
reg [8:0] cnt_case7 = 0 ; 
reg [8:0] cnt_case8 = 0 ; 

reg [8:0]  cnt_search = 0 ;
reg [30:0] cnt_slight = 0 ;
reg [30:0] cnt_force = 0 ;
reg [25:0]  cnt_wait  = 0 ;

  
reg [5:0] current_turns = 0 ;


reg [8:0] cnt_caseX_thres = 50 ;
reg [15:0] cnt_pwm    =  0 ;
reg [30:0] pwm_up    =  19900 ;
reg [30:0] pwm_thres =  20000 ;
reg [30:0] cnt_slight_thres = 0  ;
reg [30:0] cnt_force_thres = 0  ;
reg [25:0] cnt_wait_thres  = 0 ;
reg [30:0] cnt_black = 0;

reg flag_string_preprocessing = 0;

reg flag_kunji2 = 0 ;






////   UART Variable 

reg Tx = 1 ;
assign TX = Tx ;


localparam 
				idle            =  1,
				start           =  2,
				stop            =  3,
				terminate       =  4,

// Identification 

				G_letter1        =  5,
                B_letter1        =  6,
				I_letter1        =  7,
				Number_2_letter1 =  8,
				Dash_letter_11   =  9,
                W_letter1        =  10,				
				Dash_letter_21   =  11,
				Hash_letter      =  12,
                Null_letter1      =  13,

// Pick  Message 

                G_letter2        =  14,
                B_letter2        =  15,
				Number_2_letter2 =  16,
				Dash_letter_12   =  17,
                W_letter2        =  18,				
				Dash_letter_22   =  19,
                P_letter         =  20,
                I_letter2         =  21,
			    C_letter         =  22,
                K_letter         =  23,
				Dash_letter_32   =  24,
				Null_letter2      =  25,

// Dump  Message 

                G_letter3        =  26,
                B_letter3        =  27,
				Number_2_letter3 =  28,
				Dash_letter_13   =  29,
                W_letter3        =  30,				
				Dash_letter_23   =  31,
                G_letter4        =  32,
                D_letter1         =  33,
			    Z_letter         =  34,
                C_letter2        =  35,
				Dash_letter_33   =  36,
                D_letter2         =  37,
                U_letter         =  38,
			    M_letter         =  39,
                P_letter2        =  40,
                Null_letter3      =  41;
				

reg [8:0]counter     = 0    ; 				

reg [8:0] cs_uart     = idle ;
reg [8:0] cf_uart     = idle ;
reg [8:0] ct_uart     = idle ;

reg [8:0]data        = 5    ;
reg [8:0]bit_counter = 0    ;

reg [7:0] variable_letter [2:0] ;
reg [7:0] variable_number [2:0] ;

reg [7:0]g_letter       = 8'b01100111 ;  // 103
reg [7:0]b_letter       = 8'b01000010 ;  // 98              
reg [7:0]i_letter       = 8'b01001001 ;  // 105
reg [7:0]dash_letter    = 8'b00101101 ;  // 45
reg [7:0]hash_letter    = 8'b00100011 ;  // 35
reg [7:0]p_letter       = 8'b00100011 ;  // 112
reg [7:0]c_letter       = 8'b00100011 ;  // 99
reg [7:0]k_letter       = 8'b00100011 ;  // 107
reg [7:0]d_letter       = 8'b00100011 ;  // 100
reg [7:0]z_letter       = 8'b00100011 ;  // 122
reg [7:0]u_letter       = 8'b00100011 ;  // 117
reg [7:0]m_letter       = 8'b00100011 ;  // 109
reg [7:0]null_letter    = 8'b00000000 ;  // 00 
reg [7:0]w_letter       = 8'b01010111 ; 



reg flag_identification = 1 ;
reg flag_pickup = 0 ;
reg flag_dump = 0 ;

// SERVO 
reg flag_to_pick = 0 ; 
reg [15:0] counter_to_pick = 0 ;

reg left_servo = 0 ;
assign LEFT_SERVO = left_servo ;

reg gripper_servo = 0 ;
assign GRIPPER_SERVO = gripper_servo ;

reg [20:0] pwm_counter  = 0 ;
reg [5:0]  delay_count  = 0 ;

reg  flag_up_servo     = 0 ; 
reg  flag_down_servo   = 0 ;
reg  flag_close_servo  = 0 ;
reg  flag_open_servo   = 0 ;
reg  flag_wait_counter = 1 ;
reg  flag_one_time_servo = 0 ;
 
reg flag_one_time_damn = 1 ;



// Calculation of Servo timing 

/* 
for 1 ms ----> 50,000
for x ms ----> 50,000 * x 

Total time period of pulse is 20ms ---> 50,000 * 20 == 100,0000

up-down:- default = 118000, up - 135000
postions:-  default = 65000, close = 15000 , open = 115000 
*/




always @ ( posedge clk )
begin
if (map_setup == 0 )
begin

                         //////////// ______ OPEN AND CLOSE LIST TO STORE DATA _______ ////////
    if (flag_reset_list == 1 )
    	begin
          
		variable_letter[0] = 8'b01001101;
		variable_letter[1] = 8'b01000100;
		variable_letter[2] = 8'b01010111;   // W 

		variable_number[0] = 8'b00110001;   // 1
		variable_number[1] = 8'b00110010;   // 2 
		variable_number[2] = 8'b00110011;   // 3 


       //node 0 : 
     	distance_from_starting_node [0]  = inf ; status_flag [0]  = 0 ;  previous_node [0]  = 27 ;   dirn_turns_list[0] = 0 ;   currt_heading[0] = 0 ;  

    	//node 1 :	
       distance_from_starting_node [1]  = inf ; status_flag [1]  = 0 ;  previous_node [1]  = 27 ;   dirn_turns_list[1] = 0 ;   currt_heading[1] = 0 ;
    
    	//node 2 :
    	distance_from_starting_node [2]  = inf ; status_flag [2]  = 0 ;  previous_node [2]  = 27 ;   dirn_turns_list[2] = 0 ;   currt_heading[2] = 0 ;
    
    	//node 3 :
    	distance_from_starting_node [3]  = inf ; status_flag [3]  = 0 ;  previous_node [3]  = 27 ;   dirn_turns_list[3] = 0 ;   currt_heading[3] = 0 ;
    
    	//node 4 :
    	distance_from_starting_node [4]  = inf ; status_flag [4]  = 0 ;  previous_node [4]  = 27 ;   dirn_turns_list[4] = 0 ;   currt_heading[4] = 0 ;
    
    	//node 5 :
    	distance_from_starting_node [5]  = inf ; status_flag [5]  = 0 ;  previous_node [5]  = 27 ;   dirn_turns_list[5] = 0 ;   currt_heading[5] = 0 ;
    
    	//node 6 :
    	distance_from_starting_node [6]  = inf ; status_flag [6]  = 0 ;  previous_node [6]  = 27 ;   dirn_turns_list[6] = 0 ;   currt_heading[6] = 0 ;
    
    	//node 7 :
    	distance_from_starting_node [7]  = inf ; status_flag [7]  = 0 ;  previous_node [7]  = 27 ;   dirn_turns_list[7] = 0 ;   currt_heading[7] = 0 ;
    
    	//node 8 :
    	distance_from_starting_node [8]  = inf ; status_flag [8]  = 0 ;  previous_node [8]  = 27 ;   dirn_turns_list[8] = 0 ;   currt_heading[8] = 0 ;
    
    	//node 9 :
    	distance_from_starting_node [9]  = inf ; status_flag [9]  = 0 ;  previous_node [9]  = 27 ;   dirn_turns_list[9] = 0 ;   currt_heading[9] = 0 ; 
    
    	//node 10 :
    	distance_from_starting_node [10] = inf ; status_flag [10] = 0 ;  previous_node [10] = 27 ;   dirn_turns_list[10] = 0 ;  currt_heading[10] = 0 ; 
    
    	//node 11 :
    	distance_from_starting_node [11] = inf ; status_flag [11] = 0 ;  previous_node [11] = 27 ;   dirn_turns_list[11] = 0 ;  currt_heading[11] = 0 ; 
    
    	//node 12 :
    	distance_from_starting_node [12] = inf ; status_flag [12] = 0 ;  previous_node [12] = 27 ;   dirn_turns_list[12] = 0 ;  currt_heading[12] = 0 ;
    
    	//node 13 :
    	distance_from_starting_node [13] = inf ; status_flag [13] = 0 ;  previous_node [13] = 27 ;   dirn_turns_list[13] = 0 ;  currt_heading[13] = 0 ;
    
    	//node 14 :
    	distance_from_starting_node [14] = inf ; status_flag [14] = 0 ;  previous_node [14] = 27 ;   dirn_turns_list[14] = 0 ;  currt_heading[14] = 0 ;
    
    	//node 15 :
    	distance_from_starting_node [15] = inf ; status_flag [15] = 0 ;  previous_node [15] = 27 ;   dirn_turns_list[15] = 0 ;  currt_heading[15] = 0 ;
    
    	//node 16 :
    	distance_from_starting_node [16] = inf ; status_flag [16] = 0 ;  previous_node [16] = 27 ;   dirn_turns_list[16] = 0 ;  currt_heading[16] = 0 ;
    
    	//node 17 :
    	distance_from_starting_node [17] = inf ; status_flag [17] = 0 ;  previous_node [17] = 27 ;   dirn_turns_list[17] = 0 ;  currt_heading[17] = 0 ;
    
    	//node 18 :
    	distance_from_starting_node [18] = inf ; status_flag [18] = 0 ;  previous_node [18] = 27 ;   dirn_turns_list[18] = 0 ;  currt_heading[18] = 0 ;
    
    	//node 19 :
    	distance_from_starting_node [19] = inf ; status_flag [19] = 0 ;  previous_node [19] = 27 ;   dirn_turns_list[19] = 0 ;  currt_heading[19] = 0 ;
    
    	//node 20 :
    	distance_from_starting_node [20] = inf ; status_flag [20] = 0 ;  previous_node [20] = 27 ;   dirn_turns_list[20] = 0 ;  currt_heading[20] = 0 ;
    
    	//node 21 :
    	distance_from_starting_node [21] = inf ; status_flag [21] = 0 ;  previous_node [21] = 27 ;   dirn_turns_list[21] = 0 ;  currt_heading[21] = 0 ;
    
    	//node 22 :
    	distance_from_starting_node [22] = inf ; status_flag [22] = 0 ;  previous_node [22] = 27 ;   dirn_turns_list[22] = 0 ;  currt_heading[22] = 0 ;
    
    	//node 23 :
    	distance_from_starting_node [23] = inf ; status_flag [23] = 0 ;  previous_node [23] = 27 ;   dirn_turns_list[23] = 0 ;  currt_heading[23] = 0 ;
    
    	//node 24 :
    	distance_from_starting_node [24] = inf ; status_flag [24] = 0 ;  previous_node [24] = 27 ;   dirn_turns_list[24] = 0 ;  currt_heading[24] = 0 ;
    
    	//node 25 :
    	distance_from_starting_node [25] = inf ; status_flag [25] = 0 ;  previous_node [25] = 27 ;   dirn_turns_list[25] = 0 ;  currt_heading[25] = 0 ;
    
    	//node 26 :
    	distance_from_starting_node [26] = inf ; status_flag [26] = 1 ;  previous_node [26] = 27 ;   dirn_turns_list[26] = 0 ;  currt_heading[26] = 0 ;

    	flag_reset_list = 0 ;
        flag_main_loop =  1 ; 
    
    
    
    end
    
    

    
    	                               //////////// ______ PATH PLANNING MAIN LOOP  _______ ////////
    if (flag_main_loop == 1 )
    begin


    /// UPDATING START NODE INITAL DISTANCE ( ONE TIME )
     if ( flag_update_startDistance == 1 )
     begin
    	distance_from_starting_node[strt_node] = 0 ; 
    	currt_heading[strt_node] = heading_ptr ; 
    	node_string  = 50'b11111111111111111111111111111111111111111111111111 ;
		string_turns  = 50'b11111111111111111111111111111111111111111111111111 ;
    	flag_update_startDistance = 0 ;
    	flag_sub_node = 1 ;
     end


    
    /// UPDATING "CURRENT" NODE AND CHANGING VALUES OF PARAMETER      
     if ( pth_pln_cnt == 2 && flag_sub_node == 1  )
     begin
    	status_flag[current_node] = 1 ; 
    	least_value = 100 ;
     end



    /// UPDATE SUB-NODE VALUES ///
     if (pth_pln_cnt > 2  && pth_pln_cnt <= 6 && flag_sub_node == 1 )
     begin
    	if ( distance_from_starting_node[adjacent_nodes[current_node][pth_pln_cnt-3]]  > distance_from_starting_node[current_node] + path_of_adjacent_nodes[current_node][pth_pln_cnt-3] ) 
    	begin
    		distance_from_starting_node[adjacent_nodes[current_node][pth_pln_cnt-3]] = distance_from_starting_node[current_node] + path_of_adjacent_nodes[current_node][pth_pln_cnt-3] ;
    		previous_node[adjacent_nodes[current_node][pth_pln_cnt-3]] = current_node ;
    
    		currt_heading[adjacent_nodes[current_node][pth_pln_cnt-3]]   = final_heading[current_node][pth_pln_cnt-3] ;
    		dirn_turns_list[adjacent_nodes[current_node][pth_pln_cnt-3]] = turns_map [currt_heading[current_node]][turn_to_reach[current_node][pth_pln_cnt - 3]] ;
    	end 
     end
    
    
    /// NEXT " CURRENT " NODE SELECTION FROM LIST 
     if ( pth_pln_cnt > 6 && pth_pln_cnt <= 32 && flag_sub_node == 1 )
     begin 
    	if ( distance_from_starting_node[pth_pln_cnt - 7] < least_value && status_flag[pth_pln_cnt - 7] == 0 )
    	begin
    		least_value = distance_from_starting_node[pth_pln_cnt - 7] ;
    		current_node = pth_pln_cnt - 7 ; 
        end 
     end
    

    
    /// INTERRUPT WHEN END NODE == CURRENT NODE 
     if (end_node == current_node && flag_sub_node == 1 )
     begin
    	flag_sub_node = 0 ; 
    	pth_pln_cnt = 0 ;
    	flag_trace_node = 1 ;
     end  
    
    
    
    /// TRACE BACK ALL NODES TO FIND PATH 
     if (flag_trace_node == 1 )
     begin
       node_string = node_string << 5 ;
    	node_string = node_string + current_node ;

    		$display (current_node ) ;
            if      (dirn_turns_list[current_node]  == 8)  begin  string_turns = string_turns << 5 ; string_turns = string_turns + 8  ; end 
    		else if (dirn_turns_list[current_node]  == 9)  begin  string_turns = string_turns << 5 ; string_turns = string_turns + 9  ; end
    		else if (dirn_turns_list[current_node]  == 10) begin  string_turns = string_turns << 5 ; string_turns = string_turns + 10 ; end
    		else if (dirn_turns_list[current_node]  == 11) begin  string_turns = string_turns << 5 ; string_turns = string_turns + 11 ; end
    		else if (dirn_turns_list[current_node]  == 12) begin  string_turns = string_turns << 5 ; string_turns = string_turns + 12 ; end
    
    	current_node = previous_node[current_node] ;
       if ( current_node == 27 ) begin flag_trace_node = 0 ;heading_ptr = currt_heading[end_node]; flag_main_loop = 0 ; flag_reset_list = 1 ; strt_node = end_node ; map_setup = 1 ; flag_reset = 1 ; end
     end


    /// reset pth_pln_cnt after 34 clock 
     if ( pth_pln_cnt == 34 )
     begin
    	pth_pln_cnt = 0 ;
     end

    
    pth_pln_cnt = pth_pln_cnt + 1 ;	
    end


end



//                     ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~  PATH PLANNING END HERE ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 


//               ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~  Line following and PWM    ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ ~ 





if (map_setup == 1 )
begin


// Flag_reset to reset all parameters 

    if ( flag_reset == 1 )  
    begin

        cnt_case1 = 0 ;
        cnt_case2 = 0 ;
        cnt_case3 = 0 ;
        cnt_case4 = 0 ;
        cnt_case5 = 0 ;
        cnt_case6 = 0 ;
        cnt_case7 = 0 ;
        cnt_case8 = 0 ;

        flag_pwm = 0 ;

        flag_forward_mvt  = 0 ;
        flag_back_mvt     = 0 ;
        flag_left_mvt     = 0 ;
        flag_right_mvt    = 0 ;

        flag_rotate_left  = 0 ;
        flag_rotate_right = 0 ;
        flag_dgr_180_r    = 0 ;
        flag_dgr_180_l    = 0 ;

        flag_decision     = 1 ;  
        flag_reset        = 0 ;
        flag_search       = 0 ;
		cnt_slight        = 0 ;
		cnt_force         = 0 ;
		flag_kunji2       = 0 ;
    end


    if ( flag_string_preprocessing == 1)
    begin
		        rw_f = 0 ;
                rw_b = 0 ;
                lw_f = 0 ;
                lw_b = 0 ;
        current_turns = string_turns[4:0];
		  flag_kunji2 = 1 ;
		  
        if ( current_turns == 31 )
        begin
				if (cnt_black == 2)begin
					flag_close_servo = 0;
					flag_open_servo = 1;
					end
				flag_reset_list = 1 ;
				flag_update_startDistance = 1;
            current_node = strt_node  ;
            end_node     = string_point_to_visit[4:0] ;
            string_point_to_visit = string_point_to_visit >> 5 ;
            map_setup    = 0  ;
            flag_string_preprocessing = 0 ;
        end


        if ( current_turns != 31 )
        begin
            flag_wait = 1 ;
            flag_string_preprocessing = 0 ;
        end

		  

    end  

    if (flag_wait == 1 )
    begin
        
        cnt_wait = cnt_wait + 1 ;
        
        rw_f = 0 ;
        rw_b = 0 ;
        lw_f = 0 ;
        lw_b = 0 ;
        flag_pwm = 0 ; 

        if (cnt_wait == 500 )
        begin
                

                if (current_turns == 8  ) begin flag_straight_turn  = 1 ; flag_slight_forward_mvt  = 1 ; end
                if (current_turns == 9  ) begin flag_rotate_left    = 1 ; flag_slight_forward_mvt  = 1 ; end
                if (current_turns == 10 ) begin flag_rotate_right   = 1 ; flag_slight_forward_mvt  = 1 ; end
                if (current_turns == 11 ) begin flag_dgr_180_r      = 1 ; flag_slight_forward_mvt  = 1 ; end
                if (current_turns == 12 ) begin flag_dgr_180_l      = 1 ; flag_slight_forward_mvt  = 1 ; end

                string_turns = string_turns >> 5 ;
                cnt_wait  = 0 ;
                flag_pwm  = 1 ; 
                flag_string_preprocessing = 0 ;
			    flag_reset = 0 ;
				 flag_wait = 0;
        end 
    end


/*      ___ OPERATION NAME ___			___ CONFIGURATION  ( L C R ) ___			___ CASE ___ 		___ ACTION ___*/     
	
// 		    OFF TRACK                                 W W W 	                        1						STOP 
//			LEFT SHIFT                                W W B                             2						RIGHT MOVEMENT
//		    NORMAL OPERATION                          W B W                             3						NORMAL FORWARD 
//          NOT POSSIBLE                              W B B 		                    4						STOP
//          RIGHT SHIFT				                  B W W                             5						LEFT MOVEMENT
//          NOT POSSIBLE                              B W B                             6						STOP
//          NOT POSSIBLE                              B B W  	                        7						STOP
//         NODE DETECTION 				              B B B                             8						STOP



    if ( flag_decision == 1 )
    begin

 //     case 1 : ( W W W)       
        if ( avg_L_value <= white_threshold & avg_C_value <= white_threshold & avg_R_value <= white_threshold   )
        begin
            cnt_case1 = cnt_case1 + 1 ;

            cnt_case2 = 0 ;
            cnt_case3 = 0 ;
            cnt_case4 = 0 ;
            cnt_case5 = 0 ;
            cnt_case6 = 0 ;
            cnt_case7 = 0 ;
            cnt_case8 = 0 ;

            if (cnt_case1 == 100 )
            begin

                bit0 = 1  ;
                bit1 = 0  ;
                bit2 = 0  ;
                bit3 = 0  ;

                rw_f = 0 ;
                rw_b = 0 ;
                lw_f = 0 ;
                lw_b = 0 ;
                
                flag_reset = 1 ;
                flag_decision = 0 ;
                flag_pwm   = 1 ;
					 flag_back_mvt = 1;
            end
        end


 //     case 2 : ( W W B)       
        if ( avg_L_value <= white_threshold & avg_C_value <= white_threshold & avg_R_value > white_threshold   )
        begin
            cnt_case2 = cnt_case2 + 1 ;

            cnt_case1 = 0 ;
            cnt_case3 = 0 ;
            cnt_case4 = 0 ;
            cnt_case5 = 0 ;
            cnt_case6 = 0 ;
            cnt_case7 = 0 ;
            cnt_case8 = 0 ;

            if (cnt_case2 == cnt_caseX_thres )
            begin


                bit0 = 0  ;
                bit1 = 1  ;
                bit2 = 0  ;
                bit3 = 0  ;

                flag_forward_mvt = 0 ;
                flag_back_mvt    = 0 ;
                flag_left_mvt    = 0 ;
                flag_right_mvt   = 1 ;
                flag_pwm         = 1 ;
                flag_decision    = 0 ;
               
            end
        end


 //     case 3 : ( W B W)       
        if ( avg_L_value <= white_threshold & avg_C_value > white_threshold & avg_R_value <= white_threshold   )
        begin
            cnt_case3 = cnt_case3 + 1 ;

            cnt_case2 = 0 ;
            cnt_case1 = 0 ;
            cnt_case4 = 0 ;
            cnt_case5 = 0 ;
            cnt_case6 = 0 ;
            cnt_case7 = 0 ;
            cnt_case8 = 0 ;

            if (cnt_case3 == cnt_caseX_thres )
            begin

                
                bit0 = 1  ;
                bit1 = 1  ;
                bit2 = 0  ;
                bit3 = 0  ;

                flag_forward_mvt = 1 ;
                flag_back_mvt    = 0 ;
                flag_left_mvt    = 0 ;
                flag_right_mvt   = 0 ;
                flag_pwm         = 1 ;
                flag_decision    = 0 ;
            end
        end


 //     case 4 : ( W B B)       
        if ( avg_L_value <= white_threshold & avg_C_value > white_threshold & avg_R_value > white_threshold   )
        begin
            cnt_case4 = cnt_case4 + 1 ;

            cnt_case2 = 0 ;
            cnt_case3 = 0 ;
            cnt_case1 = 0 ;
            cnt_case5 = 0 ;
            cnt_case6 = 0 ;
            cnt_case7 = 0 ;
            cnt_case8 = 0 ;

            if (cnt_case4 == cnt_caseX_thres )
            begin

                
                bit0 = 0  ;
                bit1 = 0  ;
                bit2 = 1  ;
                bit3 = 0  ;

                flag_forward_mvt = 0 ;
                flag_back_mvt    = 0 ;
                flag_left_mvt    = 0 ;
                flag_right_mvt   = 1 ;
                flag_pwm         = 1 ;
                flag_decision    = 0 ;
            end
        end


 //     case 5 : ( B W W)       
        if ( avg_L_value > white_threshold & avg_C_value <= white_threshold & avg_R_value <= white_threshold   )
        begin
            cnt_case5 = cnt_case5 + 1 ;

            cnt_case2 = 0 ;
            cnt_case3 = 0 ;
            cnt_case4 = 0 ;
            cnt_case1 = 0 ;
            cnt_case6 = 0 ;
            cnt_case7 = 0 ;
            cnt_case8 = 0 ;

            if (cnt_case5 == cnt_caseX_thres )
            begin

                
                bit0 = 1  ;
                bit1 = 0  ;
                bit2 = 1  ;
                bit3 = 0  ;

                flag_forward_mvt = 0 ;
                flag_back_mvt    = 0 ;
                flag_left_mvt    = 1 ;
                flag_right_mvt   = 0 ;
                flag_pwm         = 1 ;
                flag_decision    = 0 ;
            end
        end



 //     case 6 : ( B W B)       
        if ( avg_L_value > white_threshold & avg_C_value <= white_threshold & avg_R_value > white_threshold  )
        begin
            cnt_case6 = cnt_case6 + 1 ;

            cnt_case2 = 0 ;
            cnt_case3 = 0 ;
            cnt_case4 = 0 ;
            cnt_case5 = 0 ;
            cnt_case1 = 0 ;
            cnt_case7 = 0 ;
            cnt_case8 = 0 ;

            if (cnt_case6 == cnt_caseX_thres )
            begin

                
                bit0 = 0  ;
                bit1 = 1  ;
                bit2 = 1  ;
                bit3 = 0  ;

                rw_f = 0 ;
                rw_b = 0 ;
                lw_f = 0 ;
                lw_b = 0 ;
                flag_reset = 1 ;
                flag_pwm   = 0 ;
                flag_decision  = 0 ;
            end
        end



 //     case 7 : ( B B W)       
        if ( avg_L_value > white_threshold & avg_C_value > white_threshold & avg_R_value <= white_threshold   )
        begin
            cnt_case7 = cnt_case7 + 1 ;

            cnt_case2 = 0 ;
            cnt_case3 = 0 ;
            cnt_case4 = 0 ;
            cnt_case5 = 0 ;
            cnt_case6 = 0 ;
            cnt_case1 = 0 ;
            cnt_case8 = 0 ;

            if (cnt_case7 == cnt_caseX_thres )
            begin

                
                bit0 = 1  ;
                bit1 = 1  ;
                bit2 = 1  ;
                bit3 = 0  ;

                flag_forward_mvt = 0 ;
                flag_back_mvt    = 0 ;
                flag_left_mvt    = 1 ;
                flag_right_mvt   = 0 ;
                flag_pwm         = 1 ;
                flag_decision    = 0 ;
            end
        end



 //     case 8 : ( B B B)       
        if ( avg_L_value > white_threshold & avg_C_value > white_threshold & avg_R_value > white_threshold   )
        begin
            cnt_case8 = cnt_case8 + 1 ;

            cnt_case2 = 0 ;
            cnt_case3 = 0 ;
            cnt_case4 = 0 ;
            cnt_case5 = 0 ;
            cnt_case6 = 0 ;
            cnt_case7 = 0 ;
            cnt_case1 = 0 ;

            if (cnt_case8 == 500 )
            begin

                
                bit0 = 0  ;
                bit1 = 0  ;
                bit2 = 0  ;
                bit3 = 1  ;

                flag_string_preprocessing  = 1 ;
                flag_reset = 0 ;
                flag_pwm   = 0 ;
                flag_decision  = 0 ;
            end
        end
    end 


    if (flag_search == 1)
    begin
        if ( avg_L_value <= white_threshold & avg_C_value > white_threshold & avg_R_value <= white_threshold  )
        begin

            cnt_search = cnt_search + 1 ;
            if (cnt_search == 50 )
            begin
                cnt_search = 0 ;
                flag_reset = 1 ;
                flag_pwm = 0 ;
                flag_search = 0 ;
            end 

        end
    end


// PWM Section to control speed of wheel 

    if (flag_pwm == 1)
    begin

        

        if (flag_forward_mvt == 1 )
        begin
            
            if (cnt_pwm <= 44000 )
            begin
                rw_f = 0 ;
                rw_b = 1 ;
                lw_f = 0 ;
                lw_b = 1 ;
            end

            if (cnt_pwm > 44000)
            begin
                rw_f = 0 ;
                rw_b = 0 ;
                lw_f = 0 ;
                lw_b = 0 ;
            end

            if (cnt_pwm == 45000 )
            begin
                cnt_pwm       = 0 ;
                flag_reset    = 1 ;
                flag_pwm      = 0 ;
                flag_force_mvt = 0 ;
            end

            cnt_pwm = cnt_pwm + 1 ;
        end


        if (flag_back_mvt == 1 )
        begin

            if (cnt_pwm <= 16000 )
            begin
                rw_f = 1 ;
                rw_b = 0 ;
                lw_f = 1 ;
                lw_b = 0 ;
            end

            if (cnt_pwm > 16000 )
            begin
                rw_f = 0 ;
                rw_b = 0 ;
                lw_f = 0 ;
                lw_b = 0 ;
            end

            if (cnt_pwm == 17700 )
            begin
                cnt_pwm       = 0 ;
                flag_reset    = 1 ;
                flag_pwm      = 0 ;
                flag_back_mvt = 0 ;
            end

            cnt_pwm = cnt_pwm + 1 ;         
        end



        if (flag_left_mvt == 1 )
        begin

            if (cnt_pwm <= 29000 )
            begin
                rw_f = 0 ;
                rw_b = 1 ;
                lw_f = 1 ;
                lw_b = 0 ;
            end

            if (cnt_pwm > 29000 )
            begin
                rw_f = 0 ;
                rw_b = 0 ;
                lw_f = 0 ;
                lw_b = 0 ;
            end

            if (cnt_pwm == 30000 )
            begin
                cnt_pwm       = 0 ;
                flag_reset    = 1 ;
                flag_pwm      = 0 ;
                flag_left_mvt = 0 ;
            end

            cnt_pwm = cnt_pwm + 1 ;                
        end



        if (flag_right_mvt == 1 )
        begin
            
            if (cnt_pwm <= 29000 )
            begin
                rw_f = 1 ;
                rw_b = 0 ;
                lw_f = 0 ;
                lw_b = 1 ;
            end

            if (cnt_pwm > 29000 )
            begin
                rw_f = 0 ;
                rw_b = 0 ;
                lw_f = 0 ;
                lw_b = 0 ;
            end

            if (cnt_pwm == 30000 )
            begin
                cnt_pwm       = 0 ;
                flag_reset    = 1 ;
                flag_pwm      = 0 ;
                flag_right_mvt = 0 ;
            end

            cnt_pwm = cnt_pwm + 1 ;
        end



        if ( flag_straight_turn == 1 )
        begin
    
            if ( flag_slight_forward_mvt == 1 )
            begin
                
                rw_f = 0 ;
                rw_b = 1 ;
                lw_f = 0 ;
                lw_b = 1 ;

                cnt_slight = cnt_slight + 1;

                if (cnt_slight == 2000)
                begin
                    cnt_slight = 0 ;
                    flag_slight_forward_mvt = 0 ;
                    flag_force_mvt = 1 ;
                end
            end

            if ( flag_force_mvt == 1 )
            begin
                
                rw_f = 0 ;
                rw_b = 1 ;
                lw_f = 0 ;
                lw_b = 1 ;

                cnt_force = cnt_force + 1 ;

                if (cnt_force == 2000)
                begin
                    flag_force_mvt = 0 ;
                    cnt_force = 0 ;
                    flag_search = 1 ;
                    flag_straight_turn = 0 ;
                end
            end
			end


        if ( flag_rotate_left == 1 )
        begin
    
            if ( flag_slight_forward_mvt == 1 )
            begin
                
                rw_f = 0 ;
                rw_b = 1 ;
                lw_f = 0 ;
                lw_b = 1 ;

                cnt_slight = cnt_slight + 1;

                if (cnt_slight == 2500000)
                begin
                    cnt_slight = 0 ;
                    flag_slight_forward_mvt = 0 ;
                    flag_force_mvt = 1 ;
                end
            end

            if ( flag_force_mvt == 1 )
            begin
                
                rw_f = 0 ;
                rw_b = 1 ;
                lw_f = 1 ;
                lw_b = 0 ;

                cnt_force = cnt_force + 1 ;

                if (cnt_force == 15555500)
                begin
                    flag_force_mvt = 0 ;
                    cnt_force = 0 ;
                    flag_search = 1 ;
                    flag_rotate_left = 0 ;
                end
            end

        end



        if ( flag_rotate_right == 1 )
        begin
            
            if ( flag_slight_forward_mvt == 1 )
            begin
                
                rw_f = 0 ;
                rw_b = 1 ;
                lw_f = 0 ;
                lw_b = 1 ;

                cnt_slight = cnt_slight + 1;

                if (cnt_slight == 6500000)
                begin
                    cnt_slight = 0 ;
                    flag_slight_forward_mvt = 0 ;
                    flag_force_mvt = 1 ;
                    
                end
            end

            if ( flag_force_mvt == 1 )
            begin
                
                rw_f = 1 ;
                rw_b = 0 ;
                lw_f = 0 ;
                lw_b = 1 ;

                cnt_force = cnt_force + 1 ;

                if (cnt_force == 10000000)
                begin
                    flag_force_mvt = 0 ;
                    cnt_force = 0 ;
                    flag_search = 1 ;
                    flag_rotate_right = 0 ;
                end
            end
            
        end



        if ( flag_dgr_180_l == 1 )
        begin
            if ( flag_slight_forward_mvt == 1 )
            begin
                
                rw_f = 0 ;
                rw_b = 1 ;
                lw_f = 0 ;
                lw_b = 1 ;

                cnt_slight = cnt_slight + 1;

                if (cnt_slight == 2)
                begin
                    cnt_slight = 0 ;
                    flag_slight_forward_mvt = 0 ;
                    flag_force_mvt = 1 ;
                end
            end


            if ( flag_force_mvt == 1 )
            begin
                
                rw_f = 1 ;
                rw_b = 0 ;
                lw_f = 0 ;
                lw_b = 1 ;

                cnt_force = cnt_force + 1 ;

                if (cnt_force == 50000000 )
                begin
                    flag_force_mvt = 0 ;
                    cnt_force = 0 ;
                    flag_search = 1 ;
                    flag_dgr_180_l = 0 ;
                end
            end
            
        end



        if ( flag_dgr_180_r == 1 )
        begin
            if ( flag_slight_forward_mvt == 1 )
            begin
                
                rw_f = 0 ;
                rw_b = 1 ;
                lw_f = 0 ;
                lw_b = 1 ;

                cnt_slight = cnt_slight + 1;

                if (cnt_slight == 2)
                begin
                    cnt_slight = 0 ;
                    flag_slight_forward_mvt = 0 ;
                    flag_force_mvt = 1 ;
                end
            end


            if ( flag_force_mvt == 1 )
            begin
               
                rw_f = 0 ;
                rw_b = 1 ;
                lw_f = 1 ;
                lw_b = 0 ;

                cnt_force = cnt_force + 1 ;

                if (cnt_force == 61555000)
                begin
                    flag_force_mvt = 0 ;
                    cnt_force = 0 ;
                    flag_search = 1 ;
                    flag_dgr_180_r = 0 ;
                end
            end  
        end
     

    end

        
    end 
	 
// COLOR SENSOR   
	
  //& (avg>4600 & avg<5200)
	if (COUNT_GREEN <25  & COUNT_BLUE< 25 & (COUNT_RED>=25  & COUNT_RED <= 64) )
		begin
		red_delay = red_delay+1;
		if (red_delay == 1000000) begin
			red_delay = 0;
			rled = 1;
			gled = 0;
			bled = 0;
			 if (flag_one_time_damn == 1 )
                begin
                flag_to_pick = 1 ;
                flag_one_time_damn = 0 ; 
                end 
		end
		end

  //& (avg>3100 & avg<3500)
	else if (COUNT_BLUE < 25  &  COUNT_RED < 25 & (COUNT_GREEN>=35  & COUNT_GREEN <= 64))
		begin
		green_delay = green_delay+1;
		if (green_delay == 1000000) begin
			green_delay = 0;
			rled = 0;
			gled = 1;
			bled = 0;
			 if (flag_one_time_damn == 1 )
                begin
                flag_to_pick = 1 ;
                flag_one_time_damn = 0 ; 
                end 
		end
		end
	///(avg>5000 & avg<5210)	
		else if (COUNT_GREEN <= 25   & COUNT_RED <= 25 & (COUNT_BLUE>=30 & COUNT_BLUE <= 64))
		begin
		blue_delay = blue_delay+1;
		if (blue_delay == 900000) begin
			blue_delay = 0;
			rled = 0;
    			gled = 0;
    			bled = 1;

                if (flag_one_time_damn == 1 )
                begin
                flag_to_pick = 1 ;
                flag_one_time_damn = 0 ; 
                end 
    		end
    		end


if (flag_to_pick == 1  ) 
begin



// this section of code is used to down the arm to grip the block
    if (flag_down_servo == 1)
    begin

        if (pwm_counter <= 118000 ) 
        begin
            left_servo = 1 ;
            flag_one_time_servo = 1 ;
        end

        if (pwm_counter >118000 ) 
        begin 

            left_servo = 0 ;

            if (flag_one_time_servo == 1 )
            begin
                delay_count = delay_count + 1  ;
                flag_one_time_servo = 0 ;
            end

            if (delay_count == 6 )
            begin
                delay_count = 0 ;
                flag_down_servo = 0 ;
    				flag_close_servo = 0;
    
    //            flag_wait_counter = 1 ;
            end
        end   

    end 


// this section of code is used to open the fingers of gripper  to hold  the  block
    // open gripper 
    if (flag_open_servo == 1)
    begin

        if (pwm_counter <=115000 ) 
        begin
            gripper_servo = 1 ;
            flag_one_time_servo = 1 ;
        end

        if (pwm_counter > 115000 ) 
        begin 

            gripper_servo = 0 ;

            if (flag_one_time_servo == 1 )
            begin
                delay_count = delay_count + 1  ;
                flag_one_time_servo = 0 ;
            end

            if (delay_count == 10 )
            begin
                delay_count = 0; 
                flag_open_servo = 0 ;
                flag_wait_counter = 0 ;
    //				flag_one_time_servo = 1 ;
            end
        end   
    end 


// this section of code is used to provide some delay 
    // wait 
    if (flag_wait_counter == 1)
    begin

        if (pwm_counter <=1000  )
        begin
            flag_one_time_servo = 1 ;
        end

        if (pwm_counter > 1000)
        begin

            if (flag_one_time_servo == 1)
            begin
                delay_count = delay_count +1 ;
                flag_one_time_servo = 0 ;
            end

            if (delay_count == 10 )
            begin
                delay_count = 0 ;
                flag_one_time_damn = 1 ;
                flag_wait_counter = 0 ;
                flag_close_servo = 1; 
            end 

        end

    end 


// this section of code is used to close the arm to grip the block
    // close gripper 
    if (flag_close_servo == 1)
    begin

        if (pwm_counter <= 15000) 
        begin
            gripper_servo = 1 ;
            flag_one_time_servo = 1 ;
        end

        if (pwm_counter > 15000) 
        begin 

            gripper_servo = 0 ;

            if (flag_one_time_servo == 1 )
            begin
                delay_count = delay_count + 1  ;
                flag_one_time_servo = 0 ;
            end

            if (delay_count == 10 )
            begin
                delay_count = 0 ;
                flag_close_servo = 1 ;
                flag_up_servo = 1 ;
            end
        end   
    end 


// this section of code is used to up the arm to grip the block
    // up servo  
    if (flag_up_servo == 1)
    begin

        if (pwm_counter <= 135000) 
        begin
            left_servo = 1 ;
            flag_one_time_servo = 1 ;
        end

        if (pwm_counter > 135000 ) 
        begin 

            left_servo = 0 ;

            if (flag_one_time_servo == 1 )
            begin
                delay_count = delay_count + 1  ;
                flag_one_time_servo = 0 ;
            end

            if (delay_count == 10 )
            begin
                delay_count = 0 ;
                flag_up_servo = 0 ;
					 flag_kunji2 = 0;
                flag_down_servo = 0 ;
                flag_to_pick = 0 ;
            end
        end   

    end 


    if (pwm_counter == 1000000 )
    begin
        pwm_counter = 0 ;
    end 
    pwm_counter = pwm_counter + 1 ;


end


// UART data transmission section 

if (counter == 0 || counter == 9'b110110010 )
    begin 

if (flag_identification == 1)

begin 
    case (cs_uart)

    			idle :
    					begin 
    					Tx = 1 ;
    					cs_uart = start ;
    					end 
    
    			start : 
    					 begin 
    					 Tx = 0 ;
    					 cs_uart = data ;
    					 data = data + 1 ;
    					 end 
    
    			stop :
    					 begin 
    					 Tx = 1 ;
    					 cs_uart = idle ;
    					 end 
    
    			terminate :
    						begin 
    						Tx = 1 ;
    						counter = 9'b00 ; 	
    						cs_uart = idle ;	
    						data = 14 ;
    						bit_counter = 4'b00 ;
    						end 
    
    			G_letter1 :
    						begin 
    						Tx = g_letter[bit_counter] ;
    						bit_counter = bit_counter + 1 ;
    						if (bit_counter == 4'b1000)
    						begin 
    						bit_counter = 0 ;
    						cs_uart = stop  ;
    						end 
    						end 

                B_letter1 :
    						begin 
    						Tx = b_letter[bit_counter] ;
    						bit_counter = bit_counter + 1 ;
    						if (bit_counter == 4'b1000)
    						begin 
    						bit_counter = 0 ;
    						cs_uart = stop  ;
    						end 
    						end 

                I_letter1 :
    						begin 
    						Tx = i_letter[bit_counter] ;
    						bit_counter = bit_counter + 1 ;
    						if (bit_counter == 4'b1000)
    						begin 
    						bit_counter = 0 ;
    						cs_uart = stop  ;
    						end 
    						end 

                Number_2_letter1 :
    						begin 
    						Tx = variable_number[1][bit_counter] ;
    						bit_counter = bit_counter + 1 ;
    						if (bit_counter == 4'b1000)
    						begin 
    						bit_counter = 0 ;
    						cs_uart = stop  ;
    						end 
    						end 

                Dash_letter_11 :
    						begin 
    						Tx = dash_letter[bit_counter] ;
    						bit_counter = bit_counter + 1 ;
    						if (bit_counter == 4'b1000)
    						begin 
    						bit_counter = 0 ;
    						cs_uart = stop  ;
    						end 
    						end 

                W_letter1 :
    						begin 
    						Tx = w_letter[bit_counter] ;
    						bit_counter = bit_counter + 1 ;
    						if (bit_counter == 4'b1000)
    						begin 
    						bit_counter = 0 ;
    						cs_uart = stop  ;
    						end 
    						end 

                Dash_letter_21 :
    						begin 
    						Tx = dash_letter[bit_counter] ;
    						bit_counter = bit_counter + 1 ;
    						if (bit_counter == 4'b1000)
    						begin 
    						bit_counter = 0 ;
    						cs_uart = stop  ;
    						end 
    						end 

                Hash_letter :
    						begin 
    						Tx = hash_letter[bit_counter] ;
    						bit_counter = bit_counter + 1 ;
    						if (bit_counter == 4'b1000)
    						begin 
    						bit_counter = 0 ;
    						cs_uart = stop  ;
    						end 
    						end 


                Null_letter1 :
    						begin 
    						Tx = null_letter[bit_counter] ;
    						bit_counter = bit_counter + 1 ;
    						if (bit_counter == 4'b1000)
    						begin 
    						bit_counter = 0 ;
    						cs_uart = terminate  ;
                            flag_identification = 0 ;
                            flag_pickup = 1 ;
    						end 
    						end 

    endcase 
end



if (flag_pickup == 1)

begin 
    case (cf_uart)

    			idle :
    					begin 
    					Tx = 1 ;
    					cf_uart = start ;
    					end 
    
    			start : 
    					 begin 
    					 Tx = 0 ;
    					 cf_uart = data ;
    					 data = data + 1 ;
    					 end 
    
    			stop :
    					 begin 
    					 Tx = 1 ;
    					 cf_uart = idle ;
    					 end 
    
    			terminate :
    						begin 
    						Tx = 1 ;
    						counter = 9'b00 ; 	
    						cf_uart = idle ;	
    						data = 26;
    						bit_counter = 4'b00 ;
    						end 
    
    			G_letter2 :
    						begin 
    						Tx = g_letter[bit_counter] ;
    						bit_counter = bit_counter + 1 ;
    						if (bit_counter == 4'b1000)
    						begin 
    						bit_counter = 0 ;
    						cf_uart = stop  ;
    						end 
    						end 

                B_letter2 :
    						begin 
    						Tx = b_letter[bit_counter] ;
    						bit_counter = bit_counter + 1 ;
    						if (bit_counter == 4'b1000)
    						begin 
    						bit_counter = 0 ;
    						cf_uart = stop  ;
    						end 
    						end 


                Number_2_letter2 :
    						begin 
    						Tx = variable_number[1][bit_counter] ;
    						bit_counter = bit_counter + 1 ;
    						if (bit_counter == 4'b1000)
    						begin 
    						bit_counter = 0 ;
    						cf_uart = stop  ;
    						end 
    						end 

                Dash_letter_12 :
    						begin 
    						Tx = dash_letter[bit_counter] ;
    						bit_counter = bit_counter + 1 ;
    						if (bit_counter == 4'b1000)
    						begin 
    						bit_counter = 0 ;
    						cf_uart = stop  ;
    						end 
    						end 

                W_letter2 :
    						begin 
    						Tx = variable_letter[2][bit_counter] ;
    						bit_counter = bit_counter + 1 ;
    						if (bit_counter == 4'b1000)
    						begin 
    						bit_counter = 0 ;
    						cf_uart = stop  ;
    						end 
    						end 

                Dash_letter_22 :
    						begin 
    						Tx = dash_letter[bit_counter] ;
    						bit_counter = bit_counter + 1 ;
    						if (bit_counter == 4'b1000)
    						begin 
    						bit_counter = 0 ;
    						cf_uart = stop  ;
    						end 
    						end 

                P_letter :
    						begin 
    						Tx = p_letter[bit_counter] ;
    						bit_counter = bit_counter + 1 ;
    						if (bit_counter == 4'b1000)
    						begin 
    						bit_counter = 0 ;
    						cf_uart = stop  ;
    						end 
    						end 



                I_letter2 :
    						begin 
    						Tx = i_letter[bit_counter] ;
    						bit_counter = bit_counter + 1 ;
    						if (bit_counter == 4'b1000)
    						begin 
    						bit_counter = 0 ;
    						cf_uart = stop  ;
    						end 
    						end 


                    
                C_letter :
    						begin 
    						Tx = c_letter[bit_counter] ;
    						bit_counter = bit_counter + 1 ;
    						if (bit_counter == 4'b1000)
    						begin 
    						bit_counter = 0 ;
    						cf_uart = stop  ;
    						end 
    						end 




                K_letter :
    						begin 
    						Tx = k_letter[bit_counter] ;
    						bit_counter = bit_counter + 1 ;
    						if (bit_counter == 4'b1000)
    						begin 
    						bit_counter = 0 ;
    						cf_uart = stop  ;
    						end 
    						end 




                Dash_letter_32 :
    						begin 
    						Tx = dash_letter[bit_counter] ;
    						bit_counter = bit_counter + 1 ;
    						if (bit_counter == 4'b1000)
    						begin 
    						bit_counter = 0 ;
    						cf_uart = stop  ;
    						end 
    						end 



                Hash_letter :
    						begin 
    						Tx = hash_letter[bit_counter] ;
    						bit_counter = bit_counter + 1 ;
    						if (bit_counter == 4'b1000)
    						begin 
    						bit_counter = 0 ;
    						cf_uart = stop  ;
    						end 
    						end 



                Null_letter2 :
    						begin 
    						Tx = null_letter[bit_counter] ;
    						bit_counter = bit_counter + 1 ;
    						if (bit_counter == 4'b1000)
    						begin 
    						bit_counter = 0 ;
    						cf_uart = terminate  ;
                            flag_pickup = 0 ;
                            flag_dump = 1 ;
    						end 
    						end 

    endcase 
end



if (flag_pickup == 1)
begin 
    case (ct_uart)

    			idle :
    					begin 
    					Tx = 1 ;
    					ct_uart = start ;
    					end 
    
    			start : 
    					 begin 
    					 Tx = 0 ;
    					 ct_uart = data ;
    					 data = data + 1 ;
    					 end 
    
    			stop :
    					 begin 
    					 Tx = 1 ;
    					 ct_uart = idle ;
    					 end 
    
    			terminate :
    						begin 
    						Tx = 1 ;
    						counter = 9'b00 ; 	
    						ct_uart = idle ;	
    						data = 5;
    						bit_counter = 4'b00 ;
    						end 
    
    			G_letter3 :
    						begin 
    						Tx = g_letter[bit_counter] ;
    						bit_counter = bit_counter + 1 ;
    						if (bit_counter == 4'b1000)
    						begin 
    						bit_counter = 0 ;
    						ct_uart = stop  ;
    						end 
    						end 

                B_letter3 :
    						begin 
    						Tx = b_letter[bit_counter] ;
    						bit_counter = bit_counter + 1 ;
    						if (bit_counter == 4'b1000)
    						begin 
    						bit_counter = 0 ;
    						ct_uart = stop  ;
    						end 
    						end 


                Number_2_letter3 :
    						begin 
    						Tx = variable_number[1][bit_counter] ;
    						bit_counter = bit_counter + 1 ;
    						if (bit_counter == 4'b1000)
    						begin 
    						bit_counter = 0 ;
    						ct_uart = stop  ;
    						end 
    						end 


                Dash_letter_13 :
    						begin 
    						Tx = dash_letter[bit_counter] ;
    						bit_counter = bit_counter + 1 ;
    						if (bit_counter == 4'b1000)
    						begin 
    						bit_counter = 0 ;
    						ct_uart = stop  ;
    						end 
    						end 

                W_letter3 :
    						begin 
    						Tx = variable_letter[2][bit_counter] ;
    						bit_counter = bit_counter + 1 ;
    						if (bit_counter == 4'b1000)
    						begin 
    						bit_counter = 0 ;
    						ct_uart = stop  ;
    						end 
    						end 

                Dash_letter_23 :
    						begin 
    						Tx = dash_letter[bit_counter] ;
    						bit_counter = bit_counter + 1 ;
    						if (bit_counter == 4'b1000)
    						begin 
    						bit_counter = 0 ;
    						ct_uart = stop  ;
    						end 
    						end 

                G_letter4 :
    						begin 
    						Tx = g_letter[bit_counter] ;
    						bit_counter = bit_counter + 1 ;
    						if (bit_counter == 4'b1000)
    						begin 
    						bit_counter = 0 ;
    						ct_uart = stop  ;
    						end 
    						end 



                D_letter1 :
    						begin 
    						Tx = d_letter[bit_counter] ;
    						bit_counter = bit_counter + 1 ;
    						if (bit_counter == 4'b1000)
    						begin 
    						bit_counter = 0 ;
    						ct_uart = stop  ;
    						end 
    						end 


                    
                Z_letter :
    						begin 
    						Tx = z_letter[bit_counter] ;
    						bit_counter = bit_counter + 1 ;
    						if (bit_counter == 4'b1000)
    						begin 
    						bit_counter = 0 ;
    						ct_uart = stop  ;
    						end 
    						end 




                C_letter :
    						begin 
    						Tx = c_letter[bit_counter] ;
    						bit_counter = bit_counter + 1 ;
    						if (bit_counter == 4'b1000)
    						begin 
    						bit_counter = 0 ;
    						ct_uart = stop  ;
    						end 
    						end 




                Dash_letter_33 :
    						begin 
    						Tx = dash_letter[bit_counter] ;
    						bit_counter = bit_counter + 1 ;
    						if (bit_counter == 4'b1000)
    						begin 
    						bit_counter = 0 ;
    						ct_uart = stop  ;
    						end 
    						end 



                D_letter2 :
    						begin 
    						Tx = d_letter[bit_counter] ;
    						bit_counter = bit_counter + 1 ;
    						if (bit_counter == 4'b1000)
    						begin 
    						bit_counter = 0 ;
    						ct_uart = stop  ;
    						end 
    						end 

                
                U_letter :
    						begin 
    						Tx = u_letter[bit_counter] ;
    						bit_counter = bit_counter + 1 ;
    						if (bit_counter == 4'b1000)
    						begin 
    						bit_counter = 0 ;
    						ct_uart = stop  ;
    						end 
    						end 


                M_letter :
    						begin 
    						Tx = m_letter[bit_counter] ;
    						bit_counter = bit_counter + 1 ;
    						if (bit_counter == 4'b1000)
    						begin 
    						bit_counter = 0 ;
    						ct_uart = stop  ;
    						end 
    						end 

                P_letter2 :
    						begin 
    						Tx = p_letter[bit_counter] ;
    						bit_counter = bit_counter + 1 ;
    						if (bit_counter == 4'b1000)
    						begin 
    						bit_counter = 0 ;
    						ct_uart = stop  ;
    						end 
    						end 


                Null_letter3 :
    						begin 
    						Tx = null_letter[bit_counter] ;
    						bit_counter = bit_counter + 1 ;
    						if (bit_counter == 4'b1000)
    						begin 
    						bit_counter = 0 ;
    						ct_uart = terminate  ;
                            flag_dump = 0 ;
                            flag_identification = 1 ;
    						end 
    						end 

    endcase 
 end
end

if (counter == 9'b110110010)
begin
	counter = 9'b0 ;
end 
counter = counter + 1 ;





 end

endmodule 