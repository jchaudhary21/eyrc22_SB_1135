module uart (

    input clk ,
    output TX , 

) ;


reg tx = 1 ;
assign TX = tx ;


localparam 
				idle            = 5'b00001 ,
				start           = 5'b00010 ,
				stop            = 5'b00011 ,
				terminate       = 5'b00100 ,

// Identification 

				G_letter1        = 5'b00101 ,
                B_letter1        = 5'b00110 ,
				I_letter1        = 5'b00111 ,
				Number_2_letter1 = 5'b01000 ,
				Dash_letter_11   = 5'b01001 ,
                W_letter1        = 5'b01010 ,				
				Dash_letter_21   = 5'b01011 ,
				Hash_letter      = 5'b01100 ,

// Pick  Message 

                G_letter2        = 5'b00101 ,
                B_letter2        = 5'b00110 ,
				Number_2_letter2 = 5'b01000 ,
				Dash_letter_12   = 5'b01001 ,
                W_letter2        = 5'b01010 ,				
				Dash_letter_22   = 5'b01011 ,
                P_letter         = 5'b01010 ,
                I_letter         = 5'b01010 ,
			    C_letter         = 5'b01010 ,
                K_letter         = 5'b01010 ,
				Dash_letter_32   = 5'b01011 ,


				Null_letter     = 5'b01101 ;

// Dump  Message 

                G_letter3        = 5'b00101 ,
                B_letter3        = 5'b00110 ,
				Number_2_letter3 = 5'b01000 ,
				Dash_letter_13   = 5'b01001 ,
                W_letter3        = 5'b01010 ,				
				Dash_letter_23   = 5'b01011 ,
                G_letter4        = 5'b01010 ,
                D_letter         = 5'b01010 ,
			    Z_letter         = 5'b01010 ,
                C_letter2        = 5'b01010 ,
				Dash_letter_2    = 5'b01011 ,
                D_letter         = 5'b01010 ,
                U_letter         = 5'b01010 ,
			    M_letter         = 5'b01010 ,
                P_letter2        = 5'b01010 ,
				

reg [8:0]counter = 9'b00 ; 				
reg [8:0]cs_uart = idle ;	
reg [8:0]data = 5'b00101;
reg [8:0]bit_counter = 4'b00 ;


reg [7:0]g_letter       = 8'b01100111 ;  // 103
reg [7:0]b_letter       = 8'b01000010 ;  // 98              
reg [7:0]i_letter       = 8'b01001001 ;  // 105
reg [7:0]letter_2       = 8'b00110010 ;  // 50
reg [7:0]dash_letter    = 8'b00101101 ;  // 45
reg [7:0]w_letter       = 8'b01010111 ;  // 119
reg [7:0]hash_letter    = 8'b00100011 ;  // 35
reg [7:0]p_letter       = 8'b00100011 ;  // 112
reg [7:0]i_letter       = 8'b00100011 ;  // 105
reg [7:0]c_letter       = 8'b00100011 ;  // 99
reg [7:0]k_letter       = 8'b00100011 ;  // 107
reg [7:0]d_letter       = 8'b00100011 ;  // 100
reg [7:0]z_letter       = 8'b00100011 ;  // 122
reg [7:0]u_letter       = 8'b00100011 ;  // 117
reg [7:0]m_letter       = 8'b00100011 ;  // 109


reg [7:0]null_letter    = 8'b00000000 ;




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
						Tx = g_letter[bit_counter] ;
						bit_counter = bit_counter + 1 ;
						if (bit_counter == 4'b1000)
						begin 
						bit_counter = 0 ;
						cs_uart = stop  ;
						end 
						end 

            I_letter1 :
						begin 
						Tx = g_letter[bit_counter] ;
						bit_counter = bit_counter + 1 ;
						if (bit_counter == 4'b1000)
						begin 
						bit_counter = 0 ;
						cs_uart = stop  ;
						end 
						end 

            NUMBER_2_letter1 :
						begin 
						Tx = g_letter[bit_counter] ;
						bit_counter = bit_counter + 1 ;
						if (bit_counter == 4'b1000)
						begin 
						bit_counter = 0 ;
						cs_uart = stop  ;
						end 
						end 

            Dash_letter11 :
						begin 
						Tx = g_letter[bit_counter] ;
						bit_counter = bit_counter + 1 ;
						if (bit_counter == 4'b1000)
						begin 
						bit_counter = 0 ;
						cs_uart = stop  ;
						end 
						end 

            W_letter1 :
						begin 
						Tx = g_letter[bit_counter] ;
						bit_counter = bit_counter + 1 ;
						if (bit_counter == 4'b1000)
						begin 
						bit_counter = 0 ;
						cs_uart = stop  ;
						end 
						end 

            Dash_letter21 :
						begin 
						Tx = g_letter[bit_counter] ;
						bit_counter = bit_counter + 1 ;
						if (bit_counter == 4'b1000)
						begin 
						bit_counter = 0 ;
						cs_uart = stop  ;
						end 
						end 

            Hash_letter :
						begin 
						Tx = g_letter[bit_counter] ;
						bit_counter = bit_counter + 1 ;
						if (bit_counter == 4'b1000)
						begin 
						bit_counter = 0 ;
						cs_uart = stop  ;
						end 
						end 

                    

                    
						
						
			
			

endcase 
end 