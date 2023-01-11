module uart_xbee(
	input  clk_50,				
	input  dout,				
	output adc_cs_n,			
	output din,					
	output adc_sck,			
	output [11:0]d_out_ch5,	
	output [11:0]d_out_ch6,	
	output [11:0]d_out_ch7,	
	output [1:0]data_frame,
	output tx ,
	output  LED1,
	output  LED2,
	output  LED3
);
	

/* __________ Parameters __________ */ 
	
/* ------- ADC ------- */
	
reg adc_clock = 0 ;
assign adc_sck = adc_clock ;
reg [4:0]adc_clock_counter = 5'b10100 ;

reg led1 = 0 ;
reg led2 = 0 ;
reg led3 = 0 ;
assign LED1 = led1 ;
assign LED2 = led2 ;
assign LED3 = led3 ;

reg adc_uart = 1 ;
reg adc_initalize = 0 ;

reg adc_cs = 0 ;
assign adc_cs_n = adc_cs ;

reg adc_addr = 0 ;
assign din = adc_addr ;
reg [4:0]adc_addr_counter = 5'b0 ; 
reg [11:0]data = 12'b0 ; 


reg [8:0]adc_counter =  9'b000000000 ;

/* -xxxxxxxxxxxxxxxxx- */

/*------- UART ------- */

reg Tx ;
assign tx = Tx ;

localparam 
				idle      = 3'b000 ,
				start     = 3'b001 ,
				stop      = 3'b010 ,
				terminate = 3'b011 ,
				ch0_ub    = 3'b100 ,                        
			   ch0_lb    = 3'b101 ;                       

reg [8:0]counter = 9'b00 ; 				
reg [2:0]cs = idle ;	
reg [2:0]uart_data = 3'b100 ;
reg [3:0]bit_counter = 4'b00 ;	



/* -xxxxxxxxxxxxxxxx-*/
		
/* _______________________________ */




always @(negedge clk_50)
begin 


         /* ADC Clock */
if (adc_uart == 1 )
begin 
	
   if (adc_initalize == 1)
	   begin 
		 adc_clock_counter = 5'b0 ;
		 adc_clock = 0 ;
		 adc_initalize = 0 ;
		end
		
	if (adc_clock_counter == 5'b10100)
	   begin 
		     adc_clock_counter = 5'b0 ;
			  adc_clock = 0 ;
		end 
	
	if (adc_clock_counter == 5'b01010)
	    begin 
		     adc_clock = 1 ;
		 end 
    if (adc_counter == 9'b101000001)
	   begin
	    adc_counter = 0 ;
		 adc_uart = 0 ; 
		 led1 = 1 ;
		end
	adc_clock_counter = adc_clock_counter + 1 ;
	adc_counter =  adc_counter + 1 ;
end 		 
		 
		 
		 
		 
		 		 
else if (adc_uart == 0 ) 
begin 
	led2 = 1 ;

	if (counter == 0 || counter == 9'b110110010 )
	begin 

		case (cs)

			idle :
					begin 
					Tx = 1 ;
					cs = start ;
					
					end 
					
			start : 
					 begin 
					 Tx = 0 ;
					 cs = uart_data ;
					 uart_data = uart_data + 1 ;
					 end 
					 
			stop :
					 begin 
					 Tx = 1 ;
					 cs = idle ;
					 end 
					 
			terminate :
						begin 
						Tx = 1 ;
						adc_initalize = 1 ;
						adc_uart = 1 ;
						cs = idle ;
						uart_data = 100 ;
						end 
						
			ch0_ub   :
						begin 
						Tx = data[11-bit_counter] ;
						bit_counter = bit_counter + 1 ;
						if (bit_counter == 4'b1000)
						begin 
						bit_counter = 0 ;
						cs = stop  ;
						end 
						end 
						
						
						
			ch0_lb   :
						begin 
						Tx = data[7-bit_counter] ;
						bit_counter = bit_counter + 1 ;
						if (bit_counter == 4'b1000)
						begin 
						bit_counter = 0 ;
						cs = terminate  ;
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
 

end 
 
//
	//
		//
 
 
always @ (negedge adc_sck)
begin 

if (adc_uart == 1 )
begin 
	
    if (adc_addr_counter >= 5'b00100 )
	   begin
		
		  data = data<<1 ;
		  data = data + dout ;
        adc_cs = 1 ;

      end 
		
		if (adc_addr_counter == 5'b10000)
	    begin
		 adc_addr_counter = 0 ;
		 $display(data);
		 led3 = 1 ;
		 end 
     
	  adc_addr_counter = adc_addr_counter + 1 ; 
end

end 

//
	//
		//
		



////////////////////////YOUR CODE ENDS HERE//////////////////////////
endmodule
///////////////////////////////MODULE ENDS///////////////////////////