module Line_Follower (

      // GLOBAL CLOCK 
		
		input clk ,
	 
	  // ADC DATA AND ADDRESS DECLARATION  
	 
      input  adc_data ,
	   output adc_chip_select ,
	   output adc_address ,
	   output adc_clk ,	
		 
		output RW_F ,              // Right wheel front side  
		output RW_B ,					// Right wheel front side
		output LW_F ,					// Left wheel  front side
		output LW_B ,					// Left wheel  front side
		
		output led_r ,
		output led_m ,
		output led_l ,
		
		output Digit0 ,
		output Digit1 ,
		output Digit2 ,
		output Digit3 ,
		output tx,
		output ledt,
		
		input colour_freq,
		output red_led,
		output blue_led,
		output green_led
	) ;

reg tled = 0;
assign ledt = tled;

//// UART_COLOUR - INTEGRATED :) DECL///////

reg temp_col_freq;
reg [100:0] act_freq_cnt = 0;
reg [100:0] cnt_freq_str = 0;

reg rled=0;
reg gled=0;
reg bled=0;
assign red_led = rled;
assign green_led =gled;
assign blue_led = bled;
reg [100:0] COUNT_RED = 0;
reg [100:0] COUNT_GREEN = 0;
reg [100:0] COUNT_BLUE = 0;

reg [10:0] uart_count1 = 0; 
reg [10:0] uart_count2 = 0; 
reg [10:0] uart_count3 = 0; 
reg Tx = 1 ;
assign tx = Tx ;



localparam 
				idle            = 5'b00001 ,
				start           = 5'b00010 ,
				stop            = 5'b00011 ,
				terminate       = 5'b00100 ,
				G_letter        = 5'b00101 ,
				B_letter        = 5'b00110 ,
				I_letter        = 5'b00111 ,
				Number_letter_1 = 5'b01000 ,
				Dash_letter_1   = 5'b01001 ,
            Variable_letter = 5'b01010 ,				
				Dash_letter_2   = 5'b01011 ,
				Hash_letter     = 5'b01100 ,
				Null_letter_1   = 5'b01101 ,
				N_letter        = 5'b01110 ,
				O_letter        = 5'b01111 ,
				D_letter        = 5'b10000 ,
				E_letter   		 = 5'b10001 ,
				Number_letter_2 = 5'b10010 ,
				Null_letter_2   = 5'b10011 ;
				
			
reg [8:0]counter = 9'b00 ; 				
reg [8:0]cs_uart = idle ;	
reg [8:0]data = 5'b00101;
reg [8:0]bit_counter = 4'b00 ;
	
reg [7:0]g_letter       = 8'b01000111 ;
reg [7:0]b_letter       = 8'b01000010 ;                 
reg [7:0]i_letter       = 8'b01001001 ;
reg [7:0]dash_letter_1  = 8'b00101101 ;
reg [7:0]hash_letter    = 8'b00100011 ;
reg [7:0]dash_letter_2  = 8'b00101101 ;
reg [7:0]null_letter_1    = 8'b00000000 ;	
reg [7:0]n_letter       = 8'b01001110 ;
reg [7:0]o_letter       = 8'b01001111 ;                 
reg [7:0]d_letter       = 8'b01000100 ;
reg [7:0]e_letter       = 8'b01000101 ;
reg [7:0]null_letter_2    = 8'b00000000 ;


reg [7:0] variable_number_1  [2:0];
reg [7:0] variable_number_2  [2:0];
reg [7:0] variable_letter  [2:0];
reg [3:0]variable_cnt = 0;
reg uart_flag = 0 ;


//// uart  colour code///////

always @ (posedge clk )
begin
variable_letter[0] = 8'b01001101;
variable_letter[1] = 8'b01000100;
variable_letter[2] = 8'b01010111;
variable_number_1[0] = 8'b00110001;
variable_number_1[2] = 8'b00110010;
variable_number_1[1] = 8'b00110011;
variable_number_2[0] = 8'b00110001;
variable_number_2[2] = 8'b00110010;
variable_number_2[1] = 8'b00110011;
if (uart_flag == 1 )
begin 

if (counter == 0 || counter == 9'b110110010 )
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
//					 tled = 1;
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
						data = 5'b00101;
						bit_counter = 4'b00 ;
						uart_flag = 0 ;
						end 
						
			G_letter :
						begin 
						Tx = g_letter[bit_counter] ;
						bit_counter = bit_counter + 1 ;
						if (bit_counter == 4'b1000)
						begin 
						bit_counter = 0 ;
						cs_uart = stop  ;
						end 
						end 
						
						
			B_letter :
						begin 
						Tx = b_letter[bit_counter] ;
						bit_counter = bit_counter + 1 ;
						if (bit_counter == 4'b1000)
						begin 
						bit_counter = 0 ;
						cs_uart = stop  ;
						end 
						end 

			I_letter :
						begin 
						Tx = i_letter[bit_counter] ;
						bit_counter = bit_counter + 1 ;
						if (bit_counter == 4'b1000)
						begin 
						bit_counter = 0 ;
						cs_uart = stop  ;
						end 
						end 
						
						
		  Number_letter_1 :
						begin 
						Tx = variable_number_1[variable_cnt][bit_counter] ;	
						
						bit_counter = bit_counter + 1 ;
						if (bit_counter == 4'b1000)
						begin 
						bit_counter = 0 ;
						cs_uart = stop  ;
						end 
						end 

			Dash_letter_1 :
						begin 
						Tx = dash_letter_1[bit_counter] ;
						bit_counter = bit_counter + 1 ;
						if (bit_counter == 4'b1000)
						begin 
						bit_counter = 0 ;
						cs_uart = stop  ;
						end 
						end 

		  Variable_letter :
						begin
						
						Tx = variable_letter[variable_cnt][bit_counter] ;	
						bit_counter =bit_counter  + 1 ;
						if (bit_counter == 4'b1000)
						begin 
						bit_counter = 0 ;
						cs_uart = stop  ;
						end 
						end 					
						
			Dash_letter_2 :
						begin 
						Tx = dash_letter_2[bit_counter] ;
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
						
			 Null_letter_1 :
						begin 
						Tx = null_letter_1[bit_counter] ;
						bit_counter = bit_counter + 1 ;
						if (bit_counter == 4'b1000)
						begin 
						bit_counter = 0 ;
						cs_uart = stop  ;
						end 
						end 
			
			N_letter :
						begin 
						Tx = n_letter[bit_counter] ;
						bit_counter = bit_counter + 1 ;
						if (bit_counter == 4'b1000)
						begin 
						bit_counter = 0 ;
						cs_uart = stop  ;
						end 
						end 
						
						
			O_letter :
						begin 
						Tx = o_letter[bit_counter] ;
						bit_counter = bit_counter + 1 ;
						if (bit_counter == 4'b1000)
						begin 
						bit_counter = 0 ;
						cs_uart = stop  ;
						end 
						end 

			D_letter :
						begin 
						Tx = d_letter[bit_counter] ;
						bit_counter = bit_counter + 1 ;
						if (bit_counter == 4'b1000)
						begin 
						bit_counter = 0 ;
						cs_uart = stop  ;
						end 
						end 
						 
			E_letter :
						begin 
						Tx = e_letter[bit_counter] ;
						bit_counter = bit_counter + 1 ;
						if (bit_counter == 4'b1000)
						begin 
						bit_counter = 0 ;
						cs_uart = stop  ;
						end 
						end 
						
		  Number_letter_2 :
						begin 
						Tx = variable_number_2[variable_cnt][bit_counter] ;	
						
						bit_counter = bit_counter + 1 ;
						if (bit_counter == 4'b1000)
						begin 
						bit_counter = 0 ;
						cs_uart = stop  ;
						end 
						end 
						
		 Null_letter_2 :
						begin 
						Tx = null_letter_2[bit_counter] ;
						bit_counter = bit_counter + 1 ;
						if (bit_counter == 4'b1000)
						begin 
						bit_counter = 0 ;
						cs_uart = terminate  ;
						end 
						end 
			
endcase 
end 

if (counter == 9'b110110010)
begin
	counter = 9'b0 ;
end 
counter = counter + 1 ;
end

		temp_col_freq <= colour_freq;
		if (colour_freq)
			cnt_freq_str <= cnt_freq_str + 1;
		else if (temp_col_freq) begin
			act_freq_cnt <= cnt_freq_str;
			cnt_freq_str <= 0;
		end
		if (act_freq_cnt>3000 & act_freq_cnt<4300)
		begin
			COUNT_RED = COUNT_RED + 1;
			if (COUNT_RED == 10000000) begin
			COUNT_RED = 0;
			COUNT_GREEN = 0;
			COUNT_BLUE = 0;
			rled = 1;
			gled = 0;
			bled = 0;
			variable_cnt = 0;
			uart_count1=0;
			uart_count2=0;
			uart_count3 = uart_count3 +1;

			if (uart_count3<2)begin uart_flag = 1;end
			end
		end
		else if (act_freq_cnt>4500 & act_freq_cnt< 5500)
		begin
		COUNT_GREEN = COUNT_GREEN + 1;
		if (COUNT_GREEN == 10000000) begin
			COUNT_RED = 0;
			COUNT_GREEN = 0;
			COUNT_BLUE = 0;
			rled = 0;
			gled = 1;
			bled = 0;
			uart_count2 = uart_count2 +1;
		variable_cnt = 1;
		uart_count1=0;
		uart_count3=0;
		if (uart_count2 <2)begin uart_flag = 1;end
			end
		end	
		else if (act_freq_cnt>1900 & act_freq_cnt< 2400)
		begin
			COUNT_BLUE = COUNT_BLUE + 1;
		if (COUNT_BLUE == 10000000) begin
			COUNT_RED = 0;
			COUNT_GREEN = 0;
			COUNT_BLUE = 0;
			rled = 0;
			gled = 0;
			bled = 1;
			uart_count1 = uart_count1 +1;
		variable_cnt = 2;
		uart_count2=0;
		uart_count3=0;
		if (uart_count1<2)begin uart_flag = 1;end
		end
		end


end	
////// --- ADC PARAMETERS INITALIZATION //////////////////////// 
	
	
// ___ adc clock declarations ___ 
	
reg    [4:0]counter_25  = 5'b0 ;
reg    clk_adc          = 0    ;
assign adc_clk          = clk_adc   ;


// ___ adc chip select declarations ___ 

wire   [1:0] chip_select_adc  = 2'b0 ;
assign adc_chip_select        = chip_select_adc ;


// ___ adc address declarations ____ 

reg    address_adc            = 0 ;
assign adc_address           = address_adc ;
reg    [4:0] address_counter = 5'b00 ;

localparam 
				df_1 = 2'b01 ,
			   df_2 = 2'b10 ,
				df_3 = 2'b11 ;
				
reg [1:0]cs = df_1 ;

reg  [4:0]channel_counter = 5'b00 ;

localparam 
            channel_1 = 2'b01 ,
				channel_2 = 2'b10 ,
				channel_3 = 2'b11 ;

reg [4:0] cc = channel_1 ;


// adc data declarations 

reg [11:0] L_linesensor = 0 ; 		  
reg [11:0] C_linesensor = 0 ;         	
reg [11:0] R_linesensor = 0 ;         

reg [11:0] Data_ch5 = 0 ;
reg [11:0] Data_ch6 = 0 ;
reg [11:0] Data_ch7 = 0 ;

reg [11:0]Data_1 = 0; 
reg [11:0]Data_2 = 0;
reg [11:0]Data_3 = 0;

localparam 
            data_1 = 2'b01 ,
				data_2 = 2'b10 ,
				data_3 = 2'b11 ;
				
reg [1:0] cf = data_1 ;
reg [11:0]white_threshold =  1900 ; 




///////////////////////////////////////////////////////////////

// ---- 2.5 MHz clock for adc 


always @ (negedge clk )
begin	

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


// ___ address of next channel ___ 

always @(negedge clk_adc)
begin

 
	if (address_counter == 5'b01 | address_counter == 5'b10 | address_counter == 5'b011)
	begin
		case (cs)
			
			df_1 : begin
			if      (address_counter == 5'b01)  begin address_adc = 1 ; end 
			else if (address_counter == 5'b10)  begin address_adc = 0 ; end 
			else if (address_counter == 5'b011) begin address_adc = 1 ; cs = df_2; end 
			       end 
					 
			df_2 : begin
			if      (address_counter == 5'b01)  begin address_adc = 1 ; end 
			else if (address_counter == 5'b10)  begin address_adc = 1 ; end 
			else if (address_counter == 5'b011) begin address_adc = 0 ; cs = df_3 ; end 
			       end 
					 
			df_3 : begin
			if      (address_counter == 5'b01)  begin address_adc = 1 ; end 
			else if (address_counter == 5'b10)  begin address_adc = 1 ; end 
			else if (address_counter == 5'b011) begin address_adc = 1 ; cs = df_1 ;end 
			      end
					

	endcase 
	end
	
	else if (address_counter == 5'b101)
	begin
	
	   address_adc = 0 ;
		
	end 
	
	else if (address_counter == 5'b10000)
	begin 
	
		address_counter = 0 ;
		
	end
	
	address_counter = address_counter + 1 ;
	
end 	



// ___ data receive and storing in global variable 


always @(negedge clk_adc)
begin

	if (channel_counter >= 5'b100)
	begin
		case (cf)
			
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
	

	if (channel_counter == 5'b00 | channel_counter == 5'b10000 )
	begin
		case (cc)
		
		channel_1 : 
		            begin
		
						L_linesensor  = Data_1  ;
						cc            = channel_2 ;
						cf            = data_2 ;
						
                  if ( white_threshold >= L_linesensor )
						begin 
							r_led = 1 ;
						end
						else if( Data_1 > white_threshold )
					    	begin 
					          		r_led = 0 ;
							end
							
			
						end
						
						
		channel_2 :
						begin 
						
						C_linesensor  = Data_2  ;
						cc            = channel_3 ;
						cf            = data_3 ;
					
                  if ( white_threshold >= C_linesensor )
						begin 
							m_led = 1 ;
						end 
						else if( Data_2 > white_threshold )
					    	begin 
					          		m_led = 0 ;
							end
					
						end 
						
						
		channel_3 : 
						begin 
						
						R_linesensor  = Data_3 ;
						cc            = channel_1 ;
						cf            = data_1 ;
						
						if ( white_threshold >= R_linesensor )
						begin 
							l_led = 1 ;
						end 
						else if( Data_3 > white_threshold )
					    	begin 
					          		l_led = 0 ;
							end
				end 				
						
		endcase 
	 end
	
	
	if (channel_counter == 5'b10000)
	begin 
		channel_counter = 5'b00 ;
	end
	
	channel_counter = channel_counter + 1 ;
end

///////////////////////////////////////////////////////////////////


/////////// LINE FOLLOWER ////////////////////////////////////////


reg rw_f = 0 ;
reg rw_b = 0 ;
reg lw_f = 0 ;
reg lw_b = 0 ;


assign RW_F =  rw_f ;
assign RW_B =  rw_b ;
assign LW_F =  lw_f ;
assign LW_B =  lw_b ;


reg flag_normal_movement  		= 0  ;
reg flag_right_movement  	   = 0  ;
reg flag_left_movement  		= 0  ;
reg flag_stop_movement        = 0  ;
reg flag_decision             = 1  ;
reg flag_pwm                  = 0  ;


reg bit0 = 0 ;
reg bit1 = 0 ;
reg bit2 = 0 ;
reg bit3 = 0 ;

assign Digit0 = bit0 ;
assign Digit1 = bit1 ;
assign Digit2 = bit2 ;
assign Digit3 = bit3 ;

reg r_led = 0 ;
reg m_led = 0 ;
reg l_led = 0 ;

assign led_r = r_led ;
assign led_m = m_led ;
assign led_l = l_led ;

// --- PWM --- 

reg [100:0] pwm_thres = 1000 ;

reg [100:0] rw_f_pwm_thres = 0 ;
reg [100:0] rw_b_pwm_thres = 0 ;
reg [100:0] lw_f_pwm_thres = 0 ;
reg [100:0] lw_b_pwm_thres = 0 ;
 
reg [100:0] pwm_slow  = 1000;
reg [100:0] pwm_fast  = 1000; 

reg [100:0] pwm_cnt = 0 ;

// ------------

reg [100:0]cnt_case1 = 0 ;
reg [20:0]cnt_case2 = 0 ;
reg [20:0]cnt_case3 = 0 ;
reg [20:0]cnt_case4 = 0 ;
reg [20:0]cnt_case5 = 0 ;
reg [20:0]cnt_case6 = 0 ;
reg [20:0]cnt_case7 = 0 ;
reg [20:0]cnt_case8 = 0 ;

reg [20:0]cnt_caseX_thres = 20 ;




// movement parameters

reg right_turn = 0 ;
reg left_turn = 0 ;
reg round_turn = 0 ;
reg turn_flag = 0 ;

reg [100:0] cnt_pwm_mov_str_thresh = 10000000;
reg [100:0] cnt_pwm_mov_str = 0;
reg [100:0] count_n1 = 0;
reg [100:0] cnt_pwm_thres_rl = 25000000 ;
reg [100:0] cnt_pwm_thres_180 = 50000000 ;
reg [100:0] cnt_pwm = 0 ;
reg flag_check = 0;
reg node_1_turn = 1;
reg node_2_turn = 0;
reg node_3_turn = 0;
reg node_4_turn = 0;
reg node_5_turn = 0;
reg node_6_turn = 0;
reg node_7_turn = 0;
reg node_8_turn = 0;
reg node_9_turn = 0;
reg node_10_turn = 0;
reg n1 = 0;
reg n2 = 0;
reg n3 = 0;
reg n4 = 0;
reg n5 = 0;
reg n6 = 0;
reg n7 = 0;
reg n8 = 0;
reg n9 = 0;
reg n10 = 0;
always @ (posedge clk) begin
if ( flag_decision == 1 )
begin

// CASE : 1 
	
	if ( L_linesensor <= white_threshold & C_linesensor <= white_threshold & R_linesensor <= white_threshold)
	begin 
		
      cnt_case1 = cnt_case1 + 1 ; 
		 
		if (cnt_case1 == cnt_caseX_thres)
		begin 
		
		bit0 = 1 ;
		bit1 = 0 ;
		bit2 = 0 ;
		bit3 = 0 ;
		tled = 1;
//		count_n1 = count_n1 + 1;
//		if (node_1_flag == 1) begin 
//			right_turn = 1; 
//			node_1_flag=0; 
//			node_2_flag = 1;
//		end
//		if (node_2_flag == 1 & count_n1 > 100000000) begin 
//			 
//			left_turn = 1; 
//			node_2_flag=0; 
//		end
		flag_normal_movement  		= 0  ;
		flag_right_movement  	   = 0  ;
		flag_left_movement  		   = 0  ;
		flag_stop_movement         = 1  ;
		flag_pwm                   = 1  ;
			
      cnt_case1 = 0 ;
		flag_decision  =  0  ;
		rw_f_pwm_thres =  0;
		rw_b_pwm_thres =  0;
		lw_f_pwm_thres =  0;
		lw_b_pwm_thres =  0;
		end
		
	end 
	

// CASE : 2 
	
	else if ( L_linesensor <= white_threshold & C_linesensor <= white_threshold & R_linesensor >= white_threshold)
	begin

      cnt_case2 = cnt_case2 + 1 ; 
		 
		if (cnt_case2 == cnt_caseX_thres)
		begin 
		
		bit0 = 0 ;
		bit1 = 1 ;
		bit2 = 0 ;
		bit3 = 0 ;
		
		flag_normal_movement  		= 0  ;
		flag_right_movement  	   = 1  ;
		flag_left_movement  		   = 0  ;
		flag_stop_movement         = 0  ;
		flag_pwm                   = 1  ;
      flag_decision  =  0  ;
		cnt_case2 = 0 ;
		rw_f_pwm_thres =  0;
		rw_b_pwm_thres =   pwm_slow;
		lw_f_pwm_thres =  pwm_fast ;
		lw_b_pwm_thres =  0;
		
		end
		
	end
	
	
// CASE : 3 
		
	else if ( L_linesensor <= white_threshold & C_linesensor >= white_threshold & R_linesensor <= white_threshold)
	begin

		cnt_case3 = cnt_case3 + 1 ; 
		 
		if (cnt_case3 == cnt_caseX_thres)
		begin 
		
		bit0 = 1 ;
		bit1 = 1 ;
		bit2 = 0 ;
		bit3 = 0 ;
		
		flag_normal_movement  		= 1  ;
		flag_right_movement  	   = 0  ;
		flag_left_movement  		   = 0  ;
		flag_stop_movement         = 0  ;
		flag_pwm                   = 1  ;
	   cnt_case3 = 0 ;
		flag_decision  =  0  ;
		rw_f_pwm_thres =  pwm_fast;
		rw_b_pwm_thres =  0 ;
		lw_f_pwm_thres =  pwm_fast ;
		lw_b_pwm_thres =  0;
		
		end

	end
	
	
// CASE : 4 
	
	else if ( L_linesensor <= white_threshold & C_linesensor >= white_threshold & R_linesensor >= white_threshold)
	begin
	
		cnt_case4 = cnt_case4 + 1 ; 
		 
		if (cnt_case4 == cnt_caseX_thres)
		begin 
		
		bit0 = 0 ;
		bit1 = 0 ;
		bit2 = 1 ;
		bit3 = 0 ;
		
		flag_normal_movement  		= 0  ;
		flag_right_movement  	   = 1  ;
		flag_left_movement  		   = 0  ;
		flag_stop_movement         = 0  ;
		flag_pwm                   = 1  ;
      flag_decision  =  0  ;
		rw_f_pwm_thres =  0;
		rw_b_pwm_thres =  pwm_slow ;
		lw_f_pwm_thres =  pwm_fast ;
		lw_b_pwm_thres =  0;
		cnt_case4 = 0; 
		
		end
	end
	
	
// CASE : 5 
		
	else if ( L_linesensor >= white_threshold & C_linesensor <= white_threshold & R_linesensor <= white_threshold)
	begin


		cnt_case5 = cnt_case5 + 1 ; 
		 
		if (cnt_case5 == cnt_caseX_thres)
		begin 
		
		
		bit0 = 1 ;
		bit1 = 0 ;
		bit2 = 1 ;
		bit3 = 0 ;
		
		flag_normal_movement  		= 0  ;
		flag_right_movement  	   = 0  ;
		flag_left_movement  		   = 1  ;
		flag_stop_movement         = 0  ;
		flag_pwm                   = 1  ;
      flag_decision  =  0  ;
		rw_f_pwm_thres =  pwm_fast ;
		rw_b_pwm_thres =  0  ;
		lw_f_pwm_thres =  0  ;
		lw_b_pwm_thres =  pwm_slow  ;
		
		end

	end
	

// CASE : 6 
		
	else if ( L_linesensor >= white_threshold & C_linesensor <= white_threshold & R_linesensor >= white_threshold)
	begin
	

		cnt_case6 = cnt_case6 + 1 ; 
		 
		if (cnt_case6 == cnt_caseX_thres)
		begin 
		
		bit0 = 0 ;
		bit1 = 1 ;
		bit2 = 1 ;
		bit3 = 0 ;
		
		
		flag_normal_movement  		= 0  ;
		flag_right_movement  	   = 0  ;
		flag_left_movement  		   = 0  ;
		flag_stop_movement         = 1  ;
		flag_pwm                   = 1  ;
      flag_decision  =  0  ;
		rw_f_pwm_thres =  0;
		rw_b_pwm_thres =  0 ;
		lw_f_pwm_thres =  0 ;
		lw_b_pwm_thres =  0;
		
		end

	end
	
	
// CASE : 7  
	
	else if ( L_linesensor >= white_threshold & C_linesensor >= white_threshold & R_linesensor <= white_threshold)
	begin
	
		cnt_case7 = cnt_case7 + 1 ; 
		 
		if (cnt_case7 == cnt_caseX_thres)
		begin 
		
		bit0 = 1 ;
		bit1 = 1 ;
		bit2 = 1 ;
		bit3 = 0 ;
		
		flag_normal_movement  		= 0  ;
		flag_right_movement  	   = 0  ;
		flag_left_movement  		   = 1  ;
		flag_stop_movement         = 0  ;
		flag_pwm                   = 1  ;
      flag_decision  =  0  ;
		rw_f_pwm_thres =  pwm_fast;
		rw_b_pwm_thres =  0 ;
		lw_f_pwm_thres =  0 ;
		lw_b_pwm_thres =  pwm_slow ;
		
		end

	end
	
	 
// CASE : 8 	
	
	 if ( L_linesensor >= white_threshold & C_linesensor >= white_threshold & R_linesensor >= white_threshold)
	begin

		cnt_case8 = cnt_case8 + 1 ; 
		if (cnt_case8 == cnt_caseX_thres+1000)
		begin 
		
		bit0 = 0 ;
		bit1 = 0 ;
		bit2 = 0 ;
		bit3 = 1 ;
		flag_check = 1;
		
//		count_n1 = count_n1 + 1;
//		if (node_1_flag == 1) begin
//			tled = 1;
//			right_turn = 1; 
//			node_1_flag=0;
//			node_2_flag = 1;	 
//		end
//		if (node_2_flag == 1 & count_n1 > 100000000) begin 
//			left_turn = 1; 
//			node_2_flag=0; 
//		end
		flag_normal_movement  		= 0  ;
		flag_right_movement  	   = 0  ;
		flag_left_movement  		   = 0  ;
		flag_stop_movement         = 0  ;
		flag_pwm                   = 1  ;
      flag_decision  =  0  ;
		
		rw_f_pwm_thres =  0  ;
		rw_b_pwm_thres =  0  ;
		lw_f_pwm_thres =  0  ;
		lw_b_pwm_thres =  0  ;
		
		end

	end

end 	

if (flag_check == 1) begin
		if (node_1_turn == 1)begin
		right_turn = 1;
		n1 = 1;
		cnt_pwm_thres_rl = 25000000 ;
		cnt_pwm_mov_str_thresh = 10000000;
		end
		if (node_2_turn == 1) begin
		left_turn = 1;
		n2 = 1;
		cnt_pwm_thres_rl = 25000000 ;
		cnt_pwm_mov_str_thresh = 12000000;
		end
		if (node_3_turn == 1) begin
		round_turn = 1;
		n3 = 1;
		cnt_pwm_thres_180 = 55000000 ;
		end
		if (node_4_turn == 1) begin
		left_turn = 1;
		n4 = 1;
		cnt_pwm_thres_rl = 25000000 ;
		cnt_pwm_mov_str_thresh = 12000000;
		end
		if (node_5_turn == 1) begin
		left_turn = 1;
		n5 = 1;
		cnt_pwm_thres_rl = 25000000 ;
		cnt_pwm_mov_str_thresh = 12000000;
		end
		if (node_6_turn == 1) begin
		left_turn = 1;
		n6 = 1;
		cnt_pwm_thres_rl = 25000000 ;
		end
		if (node_7_turn == 1) begin
		round_turn = 1;
		n7 = 1;
		cnt_pwm_thres_180 = 57000000 ;
		end
		if (node_8_turn == 1) begin
		left_turn = 1;
		n8 = 1;
		cnt_pwm_thres_rl = 25000000 ;
		end
		if (node_9_turn == 1) begin
		left_turn = 1;
		n9 = 1;
		cnt_pwm_thres_rl = 25000000 ;
		end
		if (node_10_turn == 1) begin
		flag_stop_movement = 1;
		end
		
		end


if (flag_pwm == 1 )
begin 

// NORMAL MOVEMENT 

		if (flag_normal_movement == 1)
		begin
		

		 
			 if (pwm_cnt == pwm_thres )
			 
			 begin
			      rw_f = 1 ;
					rw_b = 1 ;
					lw_f = 1 ;
					lw_b = 1 ; 
					
					flag_normal_movement = 0 ;
					flag_pwm       =  0  ; 
					flag_decision  =  1  ;
			      pwm_cnt        =  0  ;	
				
					cnt_case1       = 0  ;
					cnt_case2       = 0  ;
					cnt_case3       = 0  ;
					cnt_case4       = 0  ;
					cnt_case5       = 0  ;
					cnt_case6       = 0  ;
					cnt_case7       = 0  ;
					cnt_case8       = 0  ;
							bit0 = 0 ;
							bit1 = 0 ;
							bit2 = 0 ;
							bit3 = 0 ;
						rw_f_pwm_thres =  0  ;
		rw_b_pwm_thres =  0  ;
		lw_f_pwm_thres =  0  ;
		lw_b_pwm_thres =  0  ;
			end
			
			// --- RW_F PWM 
			
			if ( pwm_cnt < rw_f_pwm_thres )
			begin
					rw_f = 0 ;
			end
			
			if ( pwm_cnt > rw_f_pwm_thres )
			begin
					rw_f = 1 ;
			end
			
			// --- RW_B PWM
			
			if ( pwm_cnt < rw_b_pwm_thres )
			begin
					rw_b = 0 ;
			end
			
			if ( pwm_cnt > rw_b_pwm_thres )
			begin
					rw_b = 1 ;
			end

			// --- LW_F PWM
			
			if ( pwm_cnt < lw_f_pwm_thres )
			begin
					lw_f = 0 ;
			end
			
			if ( pwm_cnt > lw_f_pwm_thres )
			begin
					lw_f = 1 ;
			end
			
			// --- LW_B PWM
			
			if ( pwm_cnt < lw_b_pwm_thres )
			begin
					lw_b = 0 ;
			end
		
			if ( pwm_cnt > lw_b_pwm_thres )
			begin
					lw_b = 1 ;
			end			
			
			pwm_cnt = pwm_cnt + 1 ;
			
		end

		
// RIGHT MOVEMENT 

	 if (flag_right_movement == 1)
		begin
		 
		  if (pwm_cnt  == pwm_thres )
		  begin
		      
			  rw_f = 1 ;
			  rw_b = 1 ; 
			  lw_f = 1 ;
			  lw_b = 1 ;
			  		rw_f_pwm_thres =  0  ;
		rw_b_pwm_thres =  0  ;
		lw_f_pwm_thres =  0  ;
		lw_b_pwm_thres =  0  ;
			  
			  flag_right_movement = 0 ;
			  flag_pwm       =  0  ; 
			  flag_decision  =  1  ;
			  pwm_cnt        =  0  ; 
			  
			  cnt_case1       = 0  ;
           cnt_case2       = 0  ;
			  cnt_case3       = 0  ;
			  cnt_case4       = 0  ;
			  cnt_case5       = 0  ;
			  cnt_case6       = 0  ;
			  cnt_case7       = 0  ;
			  cnt_case8       = 0  ;
			  	bit0 = 0 ;
							bit1 = 0 ;
							bit2 = 0 ;
							bit3 = 0 ;
		  end	
		  
		  	// --- RW_F PWM 
			
			if ( pwm_cnt < rw_f_pwm_thres )
			begin
					rw_f = 0 ;
			end
			
			if ( pwm_cnt > rw_f_pwm_thres )
			begin
					rw_f = 1 ;
			end
			
			// --- RW_B PWM
		
		if ( pwm_cnt < rw_b_pwm_thres )
		begin
				rw_b = 0 ;
		end
		
		if ( pwm_cnt > rw_b_pwm_thres )
		begin
				rw_b = 1 ;
		end

		// --- LW_F PWM
		
		if ( pwm_cnt < lw_f_pwm_thres )
		begin
					lw_f = 0 ;
			end
			
			if ( pwm_cnt > lw_f_pwm_thres )
			begin
					lw_f = 1 ;
			end
			
			// --- LW_B PWM
			
			if ( pwm_cnt < lw_b_pwm_thres )
			begin
					lw_b = 0 ;
			end
			
			if ( pwm_cnt > lw_b_pwm_thres )
			begin
					lw_b = 1 ;
			end
		   
			pwm_cnt = pwm_cnt + 1 ;
		
		end
		
// LEFT MOVEMENT 

	 if (flag_left_movement == 1)
		begin
			

		  if (pwm_cnt == pwm_thres )
		  begin

   		  lw_f = 0 ;
			  lw_b = 0 ; 
			  rw_f = 0 ;
			  rw_b = 0 ;
			  
			  
			 flag_left_movement = 0 ;
			 flag_pwm       =  0  ; 
			 flag_decision  =  1  ;
			 pwm_cnt        =  0  ; 
			 
   		 cnt_case1       = 0  ;
          cnt_case2       = 0  ;
			 cnt_case3       = 0  ;
			 cnt_case4       = 0  ;
			 cnt_case5       = 0  ;
			 cnt_case6       = 0  ;
			 cnt_case7       = 0  ;
			 cnt_case8       = 0  ;
			 	bit0 = 0 ;
							bit1 = 0 ;
							bit2 = 0 ;
							bit3 = 0 ;
			 		rw_f_pwm_thres =  0  ;
		rw_b_pwm_thres =  0  ;
		lw_f_pwm_thres =  0  ;
		lw_b_pwm_thres =  0  ;
		  end
		  
		  			// --- RW_F PWM 
			
			if ( pwm_cnt < rw_f_pwm_thres )
			begin
					rw_f = 0 ;
			end
			
			if ( pwm_cnt > rw_f_pwm_thres )
			begin
					rw_f = 1 ;
			end
			
			// --- RW_B PWM
			
			if ( pwm_cnt < rw_b_pwm_thres )
			begin
					rw_b = 0 ;
			end
			
			if ( pwm_cnt > rw_b_pwm_thres )
			begin
					rw_b = 1 ;
			end

			// --- LW_F PWM
			
			if ( pwm_cnt < lw_f_pwm_thres )
			begin
					lw_f = 0 ;
			end
			
			if ( pwm_cnt > lw_f_pwm_thres )
			begin
					lw_f = 1 ;
			end
			
			// --- LW_B PWM
			
			if ( pwm_cnt < lw_b_pwm_thres )
			begin
					lw_b = 0 ;
			end
			
			if ( pwm_cnt > lw_b_pwm_thres )
			begin
					lw_b = 1 ;
			end
			
			pwm_cnt = pwm_cnt + 1 ;
			
		end

		
// TURN RIGHT

	if ( right_turn == 1 )
		begin 
		if (cnt_pwm_mov_str < cnt_pwm_mov_str_thresh) begin
			rw_f = 0 ;
        rw_b = 1 ;
       lw_f = 0 ;
       lw_b = 1 ;
		 
		 cnt_pwm_mov_str =cnt_pwm_mov_str + 1;
		end
		if (cnt_pwm_mov_str == cnt_pwm_mov_str_thresh) begin
			rw_f = 0 ;
        rw_b = 0 ;
       lw_f = 0 ;
       lw_b = 0 ;
		 cnt_pwm_mov_str = 0;
		 turn_flag = 1;
		 end
		if (turn_flag == 1) begin 
        if ( cnt_pwm < cnt_pwm_thres_rl )
        begin

        rw_f = 1 ;
        rw_b = 0 ;
       lw_f = 0 ;
       lw_b = 1 ;

        cnt_pwm = cnt_pwm + 1 ;

        end

        if ( cnt_pwm == cnt_pwm_thres_rl )
        begin

			rw_f = 0 ;
			rw_b = 0 ;
			lw_f = 0 ;
			lw_b = 0 ;
			flag_pwm       =  0  ;
			flag_decision = 1;
			turn_flag = 0;
        cnt_pwm = 0 ;
        right_turn = 0  ;
		  flag_check = 0;
		  if (n1 == 1) begin
		  node_1_turn = 0;
		  node_2_turn = 1;
		  n1 = 0;
		  end
        end
		 end

   end

// TURN LEFT

	if ( left_turn == 1 )
		begin 
		if (cnt_pwm_mov_str < cnt_pwm_mov_str_thresh) begin
			rw_f = 0 ;
        rw_b = 1 ;
       lw_f = 0 ;
       lw_b = 1 ;
		 
		 cnt_pwm_mov_str =cnt_pwm_mov_str + 1;
		end
		if (cnt_pwm_mov_str == cnt_pwm_mov_str_thresh) begin
			rw_f = 0 ;
        rw_b = 0 ;
       lw_f = 0 ;
       lw_b = 0 ;
		 cnt_pwm_mov_str = 0;
		 turn_flag = 1;
		 end
		 if (turn_flag == 1) begin
        if ( cnt_pwm < cnt_pwm_thres_rl )
        begin

        rw_f = 0 ;
        rw_b = 1 ;
       lw_f = 1 ;
       lw_b = 0 ;

        cnt_pwm = cnt_pwm + 1 ;

        end
	
        if ( cnt_pwm == cnt_pwm_thres_rl )
        begin

			rw_f = 0 ;
			rw_b = 0 ;
			lw_f = 0 ;
			lw_b = 0 ;
			flag_pwm       =  0  ;
			flag_decision = 1;
        cnt_pwm = 0 ;
        left_turn = 0  ;
		  flag_check = 0;
		  turn_flag = 0;
		  if (n2 == 1) begin
		  node_2_turn = 0;
		  node_3_turn = 1;
		  n2 = 0;
		  end
		  if (n4 == 1) begin
			node_4_turn = 0;
			node_5_turn = 1;
			n4 = 0;
			end
		  if (n5 == 1) begin
			node_5_turn = 0;
			node_6_turn = 1;
			n5 = 0;
			end
		  if (n6 == 1) begin
			node_6_turn = 0;
			node_7_turn = 1;
			n6 = 0;
			end
		 if (n8 == 1) begin
			node_8_turn = 0;
			node_9_turn = 1;
			n8 = 0;
			end
		 if (n9 == 1) begin
			node_9_turn = 0;
			node_10_turn = 1;
			n9 = 0;
			end
        end
		end
   end

	// TURN 180

	if ( round_turn == 1 )
		begin 

        if ( cnt_pwm < cnt_pwm_thres_180 )
        begin

        rw_f = 1 ;
        rw_b = 0 ;
       lw_f = 0 ;
       lw_b = 1 ;

        cnt_pwm = cnt_pwm + 1 ;

        end

        if ( cnt_pwm == cnt_pwm_thres_180 )
        begin

			rw_f = 0 ;
			rw_b = 0 ;
			lw_f = 0 ;
			lw_b = 0 ;
			flag_pwm       =  0  ;
			flag_decision = 1;
        cnt_pwm = 0 ;
        round_turn = 0  ;
		  flag_check = 0;
		  if (n3 ==1) begin
		  node_3_turn = 0;
		  node_4_turn = 1;
		  n3 = 0;
		  end
		  if (n7 ==1) begin
		  node_7_turn = 0;
		  node_8_turn = 1;
		  n7 = 0;
		  end
		  
        end
		  

   end

	
// STOP MOVEMENT 

	 if (flag_stop_movement == 1)
		begin

			  lw_f = 0 ;
			  lw_b = 0 ; 
			  rw_f = 0 ;
			  rw_b = 0 ;
			 
			  flag_stop_movement = 0 ;
			  flag_pwm       =  0  ; 
			  pwm_cnt = 0 ;
			  flag_decision = 1;
           		 
  			  cnt_case1       = 0  ;
           cnt_case2       = 0  ;
			  cnt_case3       = 0  ;
			  cnt_case4       = 0  ;
			  cnt_case5       = 0  ;
			  cnt_case6       = 0  ;
			  cnt_case7       = 0  ;
			  cnt_case8       = 0  ;
			
//			  bit0 = 0 ;
//			  bit1 = 0 ;
//							bit2 = 0 ;
//							bit3 = 0 ;
						rw_f_pwm_thres =  0  ;
		rw_b_pwm_thres =  0  ;
		lw_f_pwm_thres =  0  ;
		lw_b_pwm_thres =  0  ;
			 
 		
		end
		
end 
end
endmodule 
