module Line_Follower (

    input clk ,
	 input colour_freq,
	output red_led,
	output blue_led,
	output s2,
	output s3,
	output green_led ,
    output TX  

) ;


reg Tx = 0 ;
assign TX = Tx ;

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
reg [50:0] final_val2= 0;
reg [50:0] final_val3= 0;
reg [50:0] final_val4= 0;
reg [50:0] check_counter1r= 0;
reg [50:0] check_counter2r= 0;
reg [50:0] check_counter3r= 0;
reg [50:0] check_counter4r= 0;
reg [50:0] check_counter1g= 0;
reg [50:0] check_counter2g= 0;
reg [50:0] check_counter3g= 0;
reg [50:0] check_counter4g= 0;
reg [50:0] check_counter1b= 0;
reg [50:0] check_counter2b= 0;
reg [50:0] check_counter3b= 0;
reg [50:0] check_counter4b= 0;

reg [50:0] red_delay= 0;
reg [50:0] blue_delay= 0;
reg [50:0] green_delay= 0;
reg [50:0] global_count = 0;

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
				Hash_letter1      =  12,
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
				Hash_letter2      =  25,
				Null_letter2      =  26,

// Dump  Message 

            G_letter3        =  27,
            B_letter3        =  28,
				Number_2_letter3 =  29,
				Dash_letter_13   =  30,
            W_letter3        =  31,				
				Dash_letter_23   =  32,
            G_letter4        =  33,
            D_letter1         =  34,
			   Z_letter         =  35,
            C_letter2        =  36,
				Dash_letter_33   =  37,
            D_letter2         =  38,
            U_letter         =  39,
			   M_letter         =  40,
            P_letter2        =  41,
            Null_letter3      =  42;
				

reg [10:0]counter     = 0    ; 				

reg [8:0] cs_uart     = idle ;
reg [8:0] cf_uart     = idle ;
reg [8:0] ct_uart     = idle ;

reg [8:0]data        = 5    ;
reg [8:0]bit_counter = 0    ;


reg [7:0]g_letter       = 8'b01000111 ;  // 103 ----> G +
reg [7:0]b_letter       = 8'b01000010 ;  // 98        B +   
reg [7:0]i_letter       = 8'b01001001 ;  // 105       I + 
reg [7:0]letter_2       = 8'b00110010 ;  // 50        2
reg [7:0]dash_letter    = 8'b00101101 ;  // 45        -
reg [7:0]w_letter       = 8'b01011000 ;  // 119       W
reg [7:0]hash_letter    = 8'b00100011 ;  // 35        #
reg [7:0]p_letter       = 8'b01010000 ;  // 112       P
reg [7:0]c_letter       = 8'b01000011 ;  // 99        C
reg [7:0]k_letter       = 8'b01001011 ;  // 107       K
reg [7:0]d_letter       = 8'b01000100 ;  // 100       D
reg [7:0]z_letter       = 8'b01011010 ;  // 122       Z
reg [7:0]u_letter       = 8'b01010101 ;  // 117       U
reg [7:0]m_letter       = 8'b01001101 ;  // 109       M
reg [7:0]null_letter    = 8'b00000000 ;  // 00        NULL 


reg flag_identification = 1 ;
reg flag_pickup = 0 ;
reg flag_dump = 0 ;

always @ ( posedge clk )
begin

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
							flag_identification = 0 ;
//                     flag_pickup = 1 ;
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
    						Tx = letter_2[bit_counter] ;
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

                Hash_letter1 :
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
    						data = 27;
    						bit_counter = 4'b00 ;
							flag_pickup = 0 ;
//                     flag_dump = 1 ;
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
    						Tx = letter_2[bit_counter] ;
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
    						Tx = w_letter[bit_counter] ;
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



                Hash_letter2 :
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

    						end 
    						end 

    endcase 
end



if (flag_dump == 1)
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
							flag_dump = 0 ;
//                     flag_identification = 1 ;
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
    						Tx = letter_2[bit_counter] ;
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
    						Tx = w_letter[bit_counter] ;
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




                C_letter2 :
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

 //& (avg>4600 & avg<5200)
	if (COUNT_GREEN <25  & COUNT_BLUE< 25 & (COUNT_RED>=385  & COUNT_RED <= 64) )
		begin
		red_delay = red_delay+1;
		if (red_delay == 1000000) begin
			red_delay = 0;
			rled = 1;
			gled = 0;
			bled = 0;
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
			flag_dump = 1;
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
				flag_identification = 1;
				flag_pickup = 1;

    		end
    		end

end

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


endmodule 