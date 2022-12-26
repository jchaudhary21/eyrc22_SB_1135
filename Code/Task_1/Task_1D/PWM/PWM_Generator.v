// SB : Task 1 D PWM Generator
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.
This file is used to design a module which will scale down the 50Mhz Clock Frequency to 1Mhz and perform Pulse Width Modulation on it.

Recommended Quartus Version : 19.1
The submitted project file must be 19.1 compatible as the evaluation will be done on Quartus Prime Lite 19.1.

Warning: The error due to compatibility will not be entertained.
-------------------
*/

//PWM Generator
//Inputs : Clk, DUTY_CYCLE
//Output : PWM_OUT

//////////////////DO NOT MAKE ANY CHANGES IN MODULE//////////////////

module PWM_Generator(
 
	input clk,             // Clock input
	input [7:0]DUTY_CYCLE, // Input Duty Cycle
	output PWM_OUT         // Output PWM
);
 
////////////////////////WRITE YOUR CODE FROM HERE////////////////////

reg pwm_out ;
assign PWM_OUT = pwm_out ;
reg [7:0]counter = 8'b0 ; 

always @( posedge clk )

begin

		if ( counter == 8'b01100100 | counter == 8'b00000000 )
		begin 
				counter =  8'b10 ;
				pwm_out = 1 ;
		end 
				

		else 
		begin 
				if( counter <= DUTY_CYCLE - 1 )
				begin			
					pwm_out = 1 ;
					counter = counter + 8'b10 ;
				end 
				
				
				else 
				begin 
					pwm_out = 0 ;
					counter = counter + 8'b10 ;
					
				end 

end
end 		
////////////////////////YOUR CODE ENDS HERE//////////////////////////
endmodule
///////////////////////////////MODULE ENDS///////////////////////////