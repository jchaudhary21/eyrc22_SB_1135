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
module adc_control(
	input  clk_50,				//50 MHz clock
	input  dout,				//digital output from ADC128S022 (serial 12-bit)
	output adc_cs_n,			//ADC128S022 Chip Select
	output din,					//Ch. address input to ADC128S022 (serial)
	output adc_sck,			//2.5 MHz ADC clock
	output [11:0]d_out_ch5,	//12-bit output of ch. 5 (parallel)
	output [11:0]d_out_ch6,	//12-bit output of ch. 6 (parallel)
	output [11:0]d_out_ch7,	//12-bit output of ch. 7 (parallel)
	output [1:0]data_frame	//To represent 16-cycle frame (optional)
);
	
////////////////////////WRITE YOUR CODE FROM HERE////////////////////

reg [4:0]counter_25 = 5'b0 ;
reg ADC_SCK = 0 ;
assign adc_sck = ADC_SCK ; 

reg [5:0]frame_counter = 6'b0 ;
reg [1:0]DATA_FRAME =	2'b01 ;
assign data_frame = DATA_FRAME ;

wire [1:0]chip_select = 2'b0 ;
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
reg [11:0]Data = 12'b00 ;
localparam channel_1 = 2'b01 ,   // <== channel 5
			  channel_2 = 2'b10 ,	// <== channel 6
			  channel_3 = 2'b11 ;	// <== channel 7
reg [1:0]cc = channel_1 ;
reg [11:0]Data_ch5 = 0; 
reg [11:0]Data_ch6 = 0;
reg [11:0]Data_ch7 = 0;
assign d_out_ch5 = Data_ch5 ;
assign d_out_ch6 = Data_ch6 ;
assign d_out_ch7 = Data_ch7 ;
 

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
						Data_ch6 = Data  ;
						cc = channel_2 ;
						end 
		channel_2 :
						begin 
						Data_ch7 = Data  ;
						cc = channel_3 ;
						end 
		channel_3 : 
						begin 
						Data_ch5 = Data ;
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