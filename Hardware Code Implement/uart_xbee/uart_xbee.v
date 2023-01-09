
module uart_xbee(

     input clk_50 ,
	  output adc_sck,
     input din ,
	  output dout  ,
	  output tx ,
	  output adc_cs_n 
	  
	  
	  
);



reg [8:0]adc_clk_counter = 5'b00000;  
reg [8:0]adc_uart_switch = 9'b000000000; // highest count 320 , 101000000
reg ADC_SCK = 0 ;
assign adc_sck = ADC_SCK ;



reg adc_uart_flag = 1;



reg [4:0]addr_counter = 5'b00000;

reg DIN = 0 ;
assign din = DIN ;

reg [11:0]data_adc = 12'b0 ;
  

  
reg uart_clk = 0 ;   // highest uart_clk 434, 110110010 
reg [8:0]uart_clk_counter = 9'b000000000;

reg Tx ;
assign tx = Tx ;


localparam 
				idle      = 3'b000 ,
				start     = 3'b001 ,
				stop      = 3'b010 ,
				terminate = 3'b011 ,
				ch0_lb    = 3'b100 ,  
            ch0_ub	 = 3'b101 ;			
				
reg [2:0]cs = idle ;
reg [3:0]bit_counter = 4'b00 ;
reg [2:0]data = 3'b100 ;
reg [13:0]uart_adc_switch =  14'b00000000000000; // 14'b10011011111110

// Master Clock 

always @(negedge clk_50)
begin 

if(adc_uart_flag == 1 )
begin
 
if (adc_clk_counter == 5'b10100)
	begin 
		ADC_SCK = 0 ;
		adc_clk_counter = 0 ;
	end 
 
 if (adc_clk_counter ==  5'b01010)
	begin 
		ADC_SCK = 1 ;
		
	end 
 
 if ( adc_uart_switch == 9'b101000000)
   begin 
	   adc_uart_flag = 0 ;
		uart_adc_switch = 0 ;
		uart_clk_counter = 0 ;

	end
	
 adc_clk_counter = adc_clk_counter + 1 ;
 adc_uart_switch = adc_uart_switch + 1 ;
 
end 


if (adc_uart_flag == 0 )
begin
 
	 
	 
	if (uart_clk_counter == 9'b110110010 )
		begin
        uart_clk = 0;
		  uart_clk_counter  = 0 ;
		  
		end
		
	if (uart_clk_counter == 9'b011011001 )
		begin
        uart_clk = 1;


		end
	
 
  if ( uart_adc_switch == 14'b10011011111110)
   begin 
	   adc_uart_flag = 1 ;
		 adc_clk_counter = 0 ;
       adc_uart_switch = 0;
	end

	uart_adc_switch  = uart_adc_switch + 1 ;
	uart_clk_counter = uart_clk_counter + 1 ;
	
end 

end
 
 
 // ADC data receive 
always @(negedge adc_sck)
begin 


			
		      if (addr_counter >= 5'b00101 )
			    begin
				   data_adc = data_adc >> 1 ;
					data_adc  = data_adc + dout ;
					

				 end  
				 
			addr_counter = addr_counter + 1;
		
end 


always @(negedge uart_clk)
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
					 cs = data ;
					 data = data + 1 ;
					 end 
					 
			stop :
					 begin 
					 Tx = 1 ;
					 cs = idle ;
					 end 
					 
			terminate :
						begin 
						Tx = 1 ;
						cs = idle ;
						data = 3'b100 ; 
						end 
						
			ch0_lb :
						begin 
						Tx = data_adc[bit_counter] ;
						bit_counter = bit_counter + 1 ;
                  
						if (bit_counter == 4'b1000)
						begin 
						bit_counter = 0 ;
						cs = stop  ;
						end 
						end 
						
						
						
			ch0_ub :
						begin 
						Tx = data_adc[bit_counter+8] ;
						bit_counter = bit_counter + 1 ;

						if (bit_counter == 4'b1000)
						begin 
						bit_counter = 0 ;
						cs = terminate  ;
						end 
						end 
			

endcase 
end

 
 endmodule
