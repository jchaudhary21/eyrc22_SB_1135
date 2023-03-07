

//////////////////DO NOT MAKE ANY CHANGES IN MODULE//////////////////
module working_ADC(

	input  clk_50,				//50 MHz clock
	input  dout,				//digital output from ADC128S022 (serial 12-bit)
	output adc_cs_n,			//ADC128S022 Chip Select
	output din,					//Ch. address input to ADC128S022 (serial)
	output adc_sck,			//2.5 MHz ADC clock
//	output [11:0]d_out_ch5,	//12-bit output of ch. 5 (parallel)
//	output [11:0]d_out_ch6,	//12-bit output of ch. 6 (parallel)
//	output [11:0]d_out_ch7,	//12-bit output of ch. 7 (parallel)
//	output [1:0]data_frame	//To represent 16-cycle frame (optional)
	output LED0 , 
	output LED1 ,
	output LED2 , 
	output LED3 ,
	output LED4 , 
	output LED5 ,
	output LED6 , 
	output LED7 
);
	
////////////////////////WRITE YOUR CODE FROM HERE////////////////////

reg [4:0]counter_25 = 5'b0 ;
reg ADC_SCK = 0 ;
assign adc_sck = ADC_SCK ; 

reg [5:0]frame_counter = 6'b0 ;
reg [1:0]DATA_FRAME =	2'b01 ;
assign data_frame = DATA_FRAME ;

reg chip_select = 0 ;
assign adc_cs_n = chip_select ;

reg address = 0;
assign din = address ;
reg [4:0]address_counter = 5'b00 ;

localparam df_1 = 2'b01 ,
			  df_2 = 2'b10 ,
			  df_3 = 2'b11 ,
			  df_end = 2'b00 ;
			  
reg [1:0]cs = df_1 ;

reg [4:0]channel_counter = 5'b00 ;

//reg [11:0]Data = 12'b00 ;

localparam channel_1 = 2'b01 ,   // <== channel 5
			  channel_2 = 2'b10 ,	// <== channel 6
			  channel_3 = 2'b11 ;	// <== channel 7
			  
reg [1:0]cc = channel_1 ;

reg [11:0]Data_ch5 = 0; 
reg [11:0]Data_ch6 = 0;
reg [11:0]Data_ch7 = 0;

//assign d_out_ch5 = Data_ch5 ;
//assign d_out_ch6 = Data_ch6 ;
//assign d_out_ch7 = Data_ch7 ;
 

 localparam data_1 = 2'b01 ,   // <== data_channel 5
			   data_2 = 2'b10 ,	// <== data_channel 6
			   data_3 = 2'b11 ;	// <== data_channel 7

reg [1:0]cf = data_1 ;

reg [11:0]Data_1 = 0; 
reg [11:0]Data_2 = 0;
reg [11:0]Data_3 = 0;

reg [31:0] led_counter = 0 ;

reg led0 = 0 ;
reg led1 = 0 ;
reg led2 = 0 ;
reg led3 = 0 ;
reg led4 = 0 ;
reg led5 = 0 ;
reg led6 = 0 ;
reg led7 = 0 ;
assign LED0 = led0 ;
assign LED1 = led1 ;
assign LED2 = led2 ;
assign LED3 = led3 ;
assign LED4 = led4 ;
assign LED5 = led5 ;
assign LED6 = led6 ;
assign LED7 = led7 ;
 
always @(negedge clk_50)
begin	
		if ( counter_25 == 5'b0 | counter_25 == 5'b10100)
		begin
			ADC_SCK = 0 ;
			counter_25 = 5'b0 ;
			
		end 
		
		else if ( counter_25 == 5'b01010) 
		begin
			ADC_SCK = 1 ;
		end
		
		counter_25 = 5'b1 + counter_25 ;
end


always @( negedge adc_sck)
begin
	if (frame_counter == 6'b0 | frame_counter == 6'b110000 )
		begin 
			DATA_FRAME = 2'b01 ;
			frame_counter = 6'b0 ;
		end
	else if (frame_counter == 6'b010000)
		begin
			DATA_FRAME = 2'b10 ;
		end
	else if (frame_counter == 6'b100000)
		begin
			DATA_FRAME = 2'b11 ;
		
		end 
		frame_counter = frame_counter + 6'b1 ;
end 


always @(negedge adc_sck)
begin
   //address = 0 ;
	if (address_counter == 5'b01 | address_counter == 5'b10 | address_counter == 5'b011)
	begin
		case (cs)
			
			df_1 : begin
			if (address_counter == 5'b01) begin address = 1 ;end 
			else if (address_counter == 5'b10) begin address = 0; end 
			else if (address_counter == 5'b011) begin address = 1 ; cs = df_2; end 
			       end 
					 
			df_2 : begin
			if (address_counter == 5'b01) begin address = 1 ;end 
			else if (address_counter == 5'b10) begin address = 1 ; end 
			else if (address_counter == 5'b011) begin address = 0 ; cs = df_3 ;end 
			       end 
					 
			df_3 : begin
			if (address_counter == 5'b01) begin address = 1 ;end 
			else if (address_counter == 5'b10) begin address = 1 ;end 
			else if (address_counter == 5'b011) begin address = 1 ; cs = df_1 ;end 
			      end
					

	endcase 
	end
	
	else if (address_counter == 5'b101)
	begin
	   address = 0 ;
	end 
	
	else if (address_counter == 5'b10000)
	begin 
		address_counter = 0 ;
	end
	address_counter = address_counter + 1 ;
end 	
		

always @(negedge adc_sck)
begin

	if (channel_counter >= 5'b100)
	begin
		case (cf)
			
			data_1 : begin	
						Data_1 = Data_1 << 1 ;
						Data_1 = Data_1 + dout ;
			         end
			
			
			data_2 : begin	
						Data_2 = Data_2 << 1 ;
						Data_2 = Data_2 + dout ;
			         end
			
			data_3 : begin	
						Data_3 = Data_3 << 1 ;
						Data_3 = Data_3 + dout ;
			         end
			
	endcase 	
	end
	

	if (channel_counter == 5'b00 | channel_counter == 5'b10000 )
	begin
		case (cc)
		
		channel_1 : begin
						Data_ch6 = Data_1  ;
						cc = channel_2 ;
						cf = data_2 ;
						led0 = 1;
						if ( Data_ch6 == 12'b000000000000 )      // greater than 1 v 
				         begin 
					          		led5 = 1 ;
										
							end
							
						else if( Data_ch6 > 12'b000000000000 )
					    	begin 
					          		led5 = 0 ;
							end
							
						end
						
						
		channel_2 :
						begin 
						Data_ch7 = Data_2  ;
						cc = channel_3 ;
						cf = data_3 ;
						if ( Data_2 == 12'b000000000000 )      // greater than 1 v 
				         begin 
					          		led5 = 1 ;
										
							end
							
						else if( Data_ch6 > 12'b000000000000 )
					    	begin 
					          		led5 = 0 ;
							end
						end 
						
						
		channel_3 : 
						begin 
						Data_ch5 = Data_3 ;
						cc = channel_1 ;
						cf = data_1 ;
						if ( Data_3 == 12'b000000000000 )      // greater than 1 v 
				         begin 
					          		led5 = 1 ;
										
							end
							
						else if( Data_ch6 > 12'b000000000000 )
					    	begin 
					          		led5 = 0 ;
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




////////////////////////YOUR CODE ENDS HERE//////////////////////////
endmodule
///////////////////////////////MODULE ENDS///////////////////////////
