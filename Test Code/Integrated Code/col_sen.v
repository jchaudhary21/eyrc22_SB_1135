module col_sen (

    input clk ,
    output TX  

) ;


reg Tx = 0 ;
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
                     flag_pickup = 1 ;
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
                     flag_dump = 1 ;
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
                     flag_identification = 1 ;
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


end

endmodule 