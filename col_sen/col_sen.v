module col_sen(
	input clk,
	input colour_freq,
	output red_led,
	output blue_led,
	output tx,
	output green_led
	
);


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
				Number_letter   = 5'b01000 ,
				Dash_letter_1   = 5'b01001 ,
            Variable_letter = 5'b01010 ,				
				Dash_letter_2   = 5'b01011 ,
				Hash_letter     = 5'b01100 ,
				Null_letter     = 5'b01101 ;
				
			
reg [8:0]counter = 9'b00 ; 				
reg [8:0]cs_uart = idle ;	
reg [8:0]data = 5'b00101;
reg [8:0]bit_counter = 4'b00 ;
	
reg [7:0]g_letter       = 8'b01000111 ;
reg [7:0]b_letter       = 8'b01000010 ;                 
reg [7:0]i_letter       = 8'b01001001 ;
reg [7:0]dash_letter_1  = 8'b00101101 ;
reg [7:0]m_letter       = 8'b01001101 ;
reg [7:0]d_letter       = 8'b01000100 ;
reg [7:0]w_letter       = 8'b01010111 ; 
reg [7:0]letter_1       = 8'b00110001 ;
reg [7:0]letter_2       = 8'b00110010 ;
reg [7:0]letter_3       = 8'b00110011 ;
reg [7:0]dash_letter_2  = 8'b00101101 ;
reg [7:0]hash_letter    = 8'b00100011 ;
reg [7:0]null_letter    = 8'b00000000 ;

reg [7:0] variable_letter  [2:0];
reg [7:0] variable_number  [2:0];

reg [3:0]variable_cnt = 0;
reg [3:0]variable_num_cnt = 0;
reg [5:0] cnt_uart = 0 ;
reg uart_flag = 0 ;
reg [1:0]sent_r = 1;
reg [1:0]sent_g = 1;
reg [1:0]sent_b = 1;

reg uart_tx_blue = 1 ;
reg uart_tx_red = 1 ;
reg uart_tx_green = 1 ;

always @ (posedge clk )
begin
variable_letter[0] = 8'b01001101;
variable_letter[1] = 8'b01000100;
variable_letter[2] = 8'b01010111;
variable_number[0] = 8'b00110001;
variable_number[1] = 8'b00110010;
variable_number[2] = 8'b00110011;




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
						
						
		  Number_letter :
						begin 
						Tx = variable_number[variable_num_cnt][bit_counter] ;	
						
						bit_counter = bit_counter + 1 ;
						if (bit_counter == 4'b1000)
						begin 
						bit_counter = 0 ;
						cnt_uart = cnt_uart + 1 ;
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
						
			 Null_letter :
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
		if (act_freq_cnt>1200 & act_freq_cnt<1500)
		begin
			COUNT_RED = COUNT_RED + 1;
			if (COUNT_RED == 30000000) begin
			COUNT_RED = 0;
			COUNT_GREEN = 0;
			COUNT_BLUE = 0;
			rled = 1;
			gled = 0;
			bled = 0;
			variable_cnt = 0;
			variable_num_cnt = 0;
			
			if (uart_tx_red == 1)
			begin
				uart_flag = 1 ;
			   uart_tx_blue = 1 ;
				uart_tx_red = 0 ;
			   uart_tx_green = 1 ;	
         end
			
			end
		end
		else if (act_freq_cnt>2300 & act_freq_cnt< 2700)
		begin
		COUNT_GREEN = COUNT_GREEN + 1;
		if (COUNT_GREEN == 30000000) begin
			COUNT_RED = 0;
			COUNT_GREEN = 0;
			COUNT_BLUE = 0;
			rled = 0;
			gled = 1;
			bled = 0;
			variable_cnt = 1;
			variable_num_cnt = 1;
		
			if (uart_tx_blue == 1)
			begin
				uart_flag = 1 ;
			   uart_tx_blue = 0 ;
				uart_tx_red = 1 ;
			   uart_tx_green = 1 ;	
         end
		
			end
		end	
		else if (act_freq_cnt>3900 & act_freq_cnt<4500)
		begin
			COUNT_BLUE = COUNT_BLUE + 1;
		if (COUNT_BLUE == 30000000) begin
			COUNT_RED = 0;
			COUNT_GREEN = 0;
			COUNT_BLUE = 0;
			rled = 0;
			gled = 0;
			bled = 1;
			variable_cnt = 2;
			variable_num_cnt = 2;
			
			if (uart_tx_green == 1)
			begin
				uart_flag = 1 ;
			   uart_tx_blue = 1 ;
				uart_tx_red = 1 ;
			   uart_tx_green = 0 ;	
         end
		
		end
		end


end
	

endmodule