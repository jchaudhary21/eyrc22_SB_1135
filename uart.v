// SB : Task 2 B : UART
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.
This file is used to design UART Transmitter.

Recommended Quartus Version : 19.1
The submitted project file must be 19.1 compatible as the evaluation will be done on Quartus Prime Lite 19.1.

Warning: The error due to compatibility will not be entertained.
-------------------
*/

//UART Transmitter design
//Input   : clk_50M : 50 MHz clock
//Output  : tx : UART transmit output

//////////////////DO NOT MAKE ANY CHANGES IN MODULE//////////////////
module uart(
	input clk_50M,	//50 MHz clock
	output tx		//UART transmit output
);
////////////////////////WRITE YOUR CODE FROM HERE////////////////////
// 434 ==> 110110010

reg Tx ;
assign tx = Tx ;

localparam 
				idle      = 3'b000 ,
				start     = 3'b001 ,
				stop      = 3'b010 ,
				terminate = 3'b011 ,
				S_letter  = 3'b100 ,                      // --------------------------//  
			   B_letter  = 3'b101 ,                      //   Made by Team - 1135     // 
			   X_letter  = 3'b110 ,                      // --------------------------//
				Y_letter  = 3'b111 ;

reg [8:0]counter = 9'b00 ; 				
reg [2:0]cs = idle ;	
reg [2:0]data = 3'b100 ;
reg [3:0]bit_counter = 4'b00 ;	
reg [7:0]s_letter = 8'b1010011 ;
reg [7:0]b_letter = 8'b1000010 ;                 
reg [7:0]x_letter = 8'b0110011 ;
reg [7:0]y_letter = 8'b0110101 ;
	
always @ (posedge clk_50M) 
begin 

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
						end 
						
			S_letter :
						begin 
						Tx = s_letter[bit_counter] ;
						bit_counter = bit_counter + 1 ;
						if (bit_counter == 4'b1000)
						begin 
						bit_counter = 0 ;
						cs = stop  ;
						end 
						end 
						
						
			B_letter :
						begin 
						Tx = b_letter[bit_counter] ;
						bit_counter = bit_counter + 1 ;
						if (bit_counter == 4'b1000)
						begin 
						bit_counter = 0 ;
						cs = stop  ;
						end 
						end 
						
						
			X_letter :
						begin 
						Tx = x_letter[bit_counter] ;
						bit_counter = bit_counter + 1 ;
						if (bit_counter == 4'b1000)
						begin 
						bit_counter = 0 ;
						cs = stop  ;
						end 
						end 
						
						
			Y_letter :
						begin 
						Tx = y_letter[bit_counter] ;
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

////////////////////////YOUR CODE ENDS HERE//////////////////////////
endmodule
///////////////////////////////MODULE ENDS///////////////////////////