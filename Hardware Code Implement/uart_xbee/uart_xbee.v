// SB : Task 2 A : ADC
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.
This file is used to design ADC Controller.

Recommended Quartus Version : 19.1
The submitted project file must be 19.1 compatible as the evaluation will be done on Quartus Prime Lite 19.1.

Warning: The error due to compatibility will not be entertained.
-------------------
*/

//ADC Controller design
//Inputs  : clk_50 : 50 MHz clock, dout : digital output from ADC128S022 (serial 12-bit)
//Output  : adc_cs_n : Chip Select, din : Ch. address input to ADC128S022, adc_sck : 2.5 MHz ADC clock,
//				d_out_ch5, d_out_ch6, d_out_ch7 : 12-bit output of ch. 5,6 & 7,
//				data_frame : To represent 16-cycle frame (optional)

//////////////////DO NOT MAKE ANY CHANGES IN MODULE//////////////////
module uart_xbee(
	input  clk_50,				//50 MHz clock
	input  dout,				//digital output from ADC128S022 (serial 12-bit)
	output adc_cs_n,			//ADC128S022 Chip Select
	output din,					//Ch. address input to ADC128S022 (serial)
	output adc_sck,			//2.5 MHz ADC clock

	output led_1 ,
	output led_2 ,
	output led_3 
	
);
	
////////////////////////WRITE YOUR CODE FROM HERE////////////////////

reg [4:0]counter_25 = 5'b0 ;
reg ADC_SCK = 0 ;
assign adc_sck = ADC_SCK ; 


wire [1:0]chip_select = 2'b0 ;
assign adc_cs_n = chip_select ;


reg LED_1 ;
reg LED_2 ;
reg LED_3 ;
assign led_1 = LED_1 ;
assign led_2 = LED_2 ;
assign led_3 = LED_3 ;


reg address = 0;
assign din = address ;
reg [4:0]address_counter = 5'b00 ;

localparam df_1 = 2'b01 ,
			  df_2 = 2'b10 ,
			  df_3 = 2'b11 ,
			  df_end = 2'b00 ;
reg [1:0]cs = df_1 ;

reg [4:0]channel_counter = 5'b00 ;
reg [11:0]Data = 12'b00 ;
localparam channel_1 = 2'b01 ,   // <== channel 5
			  channel_2 = 2'b10 ,	// <== channel 6
			  channel_3 = 2'b11 ;	// <== channel 7
reg [1:0]cc = channel_1 ;

reg [11:0]comparison = 12'b0 ;

 
initial
begin 
LED_1 = 1'b1 ;
LED_2 = 1'b1 ;
LED_3 = 1'b1 ;
end


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


always @(negedge adc_sck)
begin
   address = 0 ;
	if (address_counter == 5'b10 | address_counter == 5'b11 | address_counter == 5'b100)
	begin
		case (cs)
			
			df_1 : 
			if (address_counter == 5'b10) begin address = 1 ;end 
			else if (address_counter == 5'b11) begin address = 0; end 
			else if (address_counter == 5'b100) begin address = 1 ; cs = df_2; end 
			
			df_2 :
			if (address_counter == 5'b10) begin address = 1 ;end 
			else if (address_counter == 5'b11) begin address = 1 ; end 
			else if (address_counter == 5'b100) begin address = 0 ; cs = df_3 ;end 
			
			df_3 :
			if (address_counter == 5'b10) begin address = 1 ;end 
			else if (address_counter == 5'b11) begin address = 1 ;end 
			else if (address_counter == 5'b100) begin address = 1 ; cs = df_end ;end 
			
			df_end:
				address = 0 ;
	endcase 
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
		Data = Data<<1 ;
		Data = Data + dout ;
	end
	

	if (channel_counter == 5'b00 | channel_counter == 5'b10000 )
	begin
		case (cc)
		
		channel_1 : begin
		            if (Data >= comparison) begin LED_1 = 0 ; LED_2 = 1 ; LED_3 = 1 ; end 
					
						cc = channel_2 ;
						end 
		channel_2 :
						begin 
						if (Data >= comparison) begin LED_1 = 1 ; LED_2 = 0 ; LED_3 = 1 ; end 
						
						cc = channel_3 ;
						end 
		channel_3 : 
						begin 
						if (Data >= comparison) begin LED_1 = 1 ; LED_2 = 1 ; LED_3 = 0 ; end 
						
						cc = channel_1 ;
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