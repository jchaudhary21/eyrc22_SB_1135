// SB : Task 1 B : Finite State Machine
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.
This file is used to design a Finite State Machine.

Recommended Quartus Version : 19.1
The submitted project file must be 19.1 compatible as the evaluation will be done on Quartus Prime Lite 19.1.

Warning: The error due to compatibility will not be entertained.
			Do not make any changes to Test_Bench_Vector.txt file. Violating will result into Disqualification.
-------------------
*/

//Finite State Machine design
//Inputs  : I (4 bit) and CLK (clock)
//Output  : Y (Y = 1 when 102210 sequence(decimal number sequence) is detected)

//////////////////DO NOT MAKE ANY CHANGES IN MODULE//////////////////
module fsm(
	input CLK,			  //Clock
	input [3:0]I,       //INPUT I
	output	  Y		  //OUTPUT Y
);

reg Y1 = 0;
assign Y = Y1;



////////////////////////WRITE YOUR CODE FROM HERE//////////////////// 
	

// Tip : Write your code such that Quartus Generates a State Machine 
//			(Tools > Netlist Viewers > State Machine Viewer).
// 		For doing so, you will have to properly declare State Variables of the
//       State Machine and also perform State Assignments correctly.
//			Use Verilog case statement to design.



localparam s1 = 4'd0 , 
			  s2 = 4'd1 ,
			  s3 = 4'd2 , 
			  s4 = 4'd3 ,
			  s5 = 4'd4 ,
			  s6 = 4'd5 ,
			  s7 = 4'd6 ;
			  
reg [3:0] cs = s1 ;  // cs ---> Current State 

			  
always @(posedge CLK)

begin 

   Y1 = 0 ;
	
case (cs)

	
	s1 :
	if (I == 4'b01) begin cs = s2 ; end 
	else begin cs = s1 ; end 
	
	s2 :
	if (I == 4'b00) begin cs = s3 ; end 
	else begin cs = s1 ; end 
	
	s3 :
	if (I == 4'b10) begin cs = s4 ; end 
	else begin cs = s1 ; end 
	
	s4 :
	if (I == 4'b10) begin cs = s5 ; end 
	else begin cs = s1 ; end 
	
	s5 :
	if (I == 4'b01) begin cs = s6 ; end 
	else begin cs = s1 ; end 
	
	s6 :
	if (I == 4'b00) begin cs = s7 ; Y1 = 1 ; end 
	else begin cs = s1 ; end 
	
	s7 :
	if ( I == 4'b10) begin cs = s4 ; end 
	else if (I == 4'b01) begin cs = s2 ; end 
	else begin cs = s1 ; end 
	
	
	
	
endcase
end 
////////////////////////YOUR CODE ENDS HERE//////////////////////////
endmodule
///////////////////////////////MODULE ENDS///////////////////////////