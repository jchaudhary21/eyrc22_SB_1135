
module line_follower (

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
		output LW_B 					// Left wheel  front side
		
		
		
	) ;


// --- ADC PARAMETERS INITALIZATION 
	
	
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

reg [11:0] L_linesensor = 0 ; 		  // channel 5 of ADC
reg [11:0] C_linesensor = 0 ;         // channel 6 of ADC	
reg [11:0] R_linesensor = 0 ;         // channel 7 of ADC

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

	
	
// --- MOTOR PARAMATERS INITALIZATION 
	
reg white_threshold 		       		=  12'b010011011010 ; // <---| > 1V 
reg [7:0]lower_dutycycle_threshold  =  8'b00010100 ; // <---| 20 % 
reg [7:0]upper_dutycycle_threshold  =  8'b01011010 ; // <---| 90 % 
reg [7:0]stop_dutycycle_threshold   =  8'b000000000 ; // <---|  0 %

reg [7:0]pwm_counter = 8'b0 ;

reg rw_f = 0 ;
reg rw_b = 0 ;
reg lw_f = 0 ;
reg lw_b = 0 ;

reg [7:0]rw_dutycycle = 0 ;
reg [7:0]lw_dutycycle = 0 ;

assign RW_F =  rw_f ;
assign RW_B =  rw_b ;
assign LW_F =  lw_f ;
assign LW_B =  lw_b ;


reg flag_normal_movement  		= 0  ;
reg flag_right_movement  	   = 0  ;
reg flag_left_movement  		= 0  ;
reg flag_stop_movement        = 0  ;
reg flag_action               = 0  ;
reg flag_decision             = 1  ;
reg flag_pwm                  = 0  ;


always @ (posedge clk )
begin
	
// --- 	MAIN LOOP WHICH DETECT THRESHOLD AND TAKE DECISION
			
/*      ___ OPERATION NAME ___			___ CONFIGURATION  ( L C R ) ___			___ CASE ___ 		___ ACTION ___*/     
	
// 		    OFF TRACK             				     W W W 	                           1						STOP 
//			    LEFT SHIFT							        W W B                             2						RIGHT MOVEMENT
//		     NORMAL OPERATION        			        W B W                             3						NORMAL FORWARD 
//          NOT POSSIBLE                          W B B 		                        4						STOP
//          RIGHT SHIFT				                 B W W                             5						LEFT MOVEMENT
//          NOT POSSIBLE                          B W B                             6						STOP
//          NOT POSSIBLE                          B B W  	                        7						STOP
//         NODE DETECTION 				              B B B                             8						STOP


if ( flag_decision == 1 )
begin

// CASE : 1 
	
	if ( L_linesensor <= white_threshold & C_linesensor <= white_threshold & R_linesensor <= white_threshold)
	begin 
	
		flag_normal_movement  		= 0  ;
		flag_right_movement  	   = 0  ;
		flag_left_movement  		   = 0  ;
		flag_stop_movement         = 1  ;
		flag_decision              = 0  ;
		flag_pwm                   = 0  ;
		flag_action                = 1  ;
		
	end 
	

// CASE : 2 
	
	else if ( L_linesensor <= white_threshold & C_linesensor <= white_threshold & R_linesensor >= white_threshold)
	begin
	
		flag_normal_movement  		= 0  ;
		flag_right_movement  	   = 1  ;
		flag_left_movement  		   = 0  ;
		flag_stop_movement         = 0  ;
		flag_decision              = 0  ;
		flag_pwm                   = 0  ;
		flag_action                = 1  ;
		
	end
	
	
// CASE : 3 
		
	else if ( L_linesensor <= white_threshold & C_linesensor >= white_threshold & R_linesensor <= white_threshold)
	begin
	
		flag_normal_movement  		= 1  ;
		flag_right_movement  	   = 0  ;
		flag_left_movement  		   = 0  ;
		flag_stop_movement         = 0  ;
		flag_decision              = 0  ;
		flag_pwm                   = 0  ;
		flag_action                = 1  ;
		
	end
	
	
// CASE : 4 
	
	else if ( L_linesensor <= white_threshold & C_linesensor >= white_threshold & R_linesensor >= white_threshold)
	begin
	
		flag_normal_movement  		= 0  ;
		flag_right_movement  	   = 0  ;
		flag_left_movement  		   = 0  ;
		flag_stop_movement         = 1  ;
		flag_decision              = 0  ;
		flag_pwm                   = 0  ;
		flag_action                = 1  ;

		
	end
	
	
// CASE : 5 
		
	else if ( L_linesensor >= white_threshold & C_linesensor <= white_threshold & R_linesensor <= white_threshold)
	begin
	
		flag_normal_movement  		= 0  ;
		flag_right_movement  	   = 0  ;
		flag_left_movement  		   = 1  ;
		flag_stop_movement         = 0  ;
		flag_decision              = 0  ;
		flag_pwm                   = 0  ;
		flag_action                = 1  ;
	
	end
	

// CASE : 6 
		
	else if ( L_linesensor >= white_threshold & C_linesensor <= white_threshold & R_linesensor >= white_threshold)
	begin
	
		flag_normal_movement  		= 0  ;
		flag_right_movement  	   = 0  ;
		flag_left_movement  		   = 0  ;
		flag_stop_movement         = 1  ;
		flag_decision              = 0  ;
		flag_pwm                   = 0  ;
		flag_action                = 1  ;

	end
	
	
// CASE : 7  
	
	else if ( L_linesensor >= white_threshold & C_linesensor >= white_threshold & R_linesensor <= white_threshold)
	begin
	
		flag_normal_movement  		= 0  ;
		flag_right_movement  	   = 0  ;
		flag_left_movement  		   = 0  ;
		flag_stop_movement         = 1  ;
		flag_decision              = 0  ;
		flag_pwm                   = 0  ;
		flag_action                = 1  ;
		
	end
	
	 
// CASE : 8 	
	
	else if ( L_linesensor >= white_threshold & C_linesensor >= white_threshold & R_linesensor >= white_threshold)
	begin

		flag_normal_movement  		= 0  ;
		flag_right_movement  	   = 0  ;
		flag_left_movement  		   = 0  ;
		flag_stop_movement         = 1  ;
		flag_decision              = 0  ;
		flag_pwm                   = 0  ;
		flag_action                = 1  ;
	
	end

end 	

	
	
// --- PART OF CODE WHICH WILL DECIDE HOW MUCH PWM TO SUPPLY TO LEFT AND RIGHT MOTORS 
	
/*      ___ FLAG RAISED ___        ___ DUTY CYCLES ___   */
 
//          stop_movement                 left  : 0 %
//                                        right : 0 %
          
//          right_movement                left  : lower dutycycle threshold ( eg  : 20 % ) 
//                                        right : upper dutycycle threshold ( eg  : 90 % )

//          left_movement                 left  :  upper dutycycle threshold ( eg : 20 % )
//                                        right :  lower dutycycle threshold ( eg : 90 % )

//          normal_movement               left  :  upper dutycycle threshold ( eg : 90 % )
//                                        right :  upper dutycycle threshold ( eg : 90 % )
 	
	
if (flag_action == 1 )
begin

	if ( flag_stop_movement == 1 )
	begin
	
		rw_dutycycle = stop_dutycycle_threshold ;
	   lw_dutycycle = stop_dutycycle_threshold ;	
		flag_decision              = 0  ;
		flag_pwm                   = 1  ;
		flag_action                = 0  ;
	
	end 
	
	
	
	else if (flag_right_movement == 1)
	begin 
	
		rw_dutycycle = upper_dutycycle_threshold  ;
		lw_dutycycle = lower_dutycycle_threshold  ;
		flag_decision              = 0  ;
		flag_pwm                   = 1  ;
		flag_action                = 0  ;
		
	end 
	
	
	
	else if (flag_left_movement == 1)
	begin 
	
		lw_dutycycle = upper_dutycycle_threshold  ;
		rw_dutycycle = lower_dutycycle_threshold  ;
		flag_decision              = 0  ;
		flag_pwm                   = 1  ;
		flag_action                = 0  ;
	
	end

	
	
	else if (flag_right_movement == 1)
	begin 
	
		rw_dutycycle = upper_dutycycle_threshold  ;
		lw_dutycycle = upper_dutycycle_threshold  ;
		flag_decision              = 0  ;
		flag_pwm                   = 1  ;
		flag_action                = 0  ;
		
	end 

end 


if (flag_pwm == 1 )
begin 


	if ( pwm_counter == 8'b01100100 )
		begin 
				pwm_counter    =  8'b00 ;
				rw_f           =  1  ;
				lw_b           =  0  ;
				lw_f           =  1  ;
				lw_b           =  0  ;
				flag_pwm       =  0  ; 
				flag_action    =  0  ;
		      flag_decision  =  1  ;
		end 
				

				
	if( pwm_counter <= rw_dutycycle - 1 )
		begin	
				rw_f = 0 ;
//				rw_b = 0 ;
				pwm_counter = pwm_counter + 8'b10 ;	
		end 
				
				
				
	if ( pwm_counter <= lw_dutycycle - 1)
		begin
        		lw_f = 0 ;
//				lw_b = 0 ;

		end
				
				
	if ( pwm_counter > rw_dutycycle - 1 )
		begin 
				rw_f = 1 ;
//				rw_b = 0 ;
				pwm_counter = pwm_counter + 8'b10 ;
		end
	
	
	if ( pwm_counter > lw_dutycycle - 1 )
		begin 
           lw_f = 1 ;
//			  lw_b = 0 ; 
		end 


end 
end


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
		
						C_linesensor  = Data_1  ;
						cc            = channel_2 ;
						cf            = data_2 ;

			
						end
						
						
		channel_2 :
						begin 
						
						R_linesensor  = Data_2  ;
						cc            = channel_3 ;
						cf            = data_3 ;
					
						end 
						
						
		channel_3 : 
						begin 
						
						L_linesensor  = Data_3 ;
						cc            = channel_1 ;
						cf            = data_1 ;
					
						end 				
						
		endcase 
	 end
	
	
	if (channel_counter == 5'b10000)
	begin 
		channel_counter = 5'b00 ;
	end
	
	channel_counter = channel_counter + 1 ;
end
endmodule 