// SB : Task 1C Frequency Counter
/*
Instructions
-------------------
Students are not allowed to make any changes in the Module declaration.
This file is used to design 2:1 Multiplexer.

Recommended Quartus Version : 19.1
The submitted project file must be 19.1 compatible as the evaluation will be done on Quartus Prime Lite 19.1.

Warning: The error due to compatibility will not be entertained.
			Do not make any changes to Test_Bench_Vector.txt file. Violating will result into Disqualification.
-------------------
*/

//Freq Counter design
//Inputs	: clk & ip_sig (input signal)
//Output	: count (8 bits)

//////////////////DO NOT MAKE ANY CHANGES IN MODULE//////////////////
module freq_counter(
	input clk,
	input ip_sig,

	output reg [7:0] count = 0
);


////////////////////////WRITE YOUR CODE FROM HERE////////////////////  
reg in1;
reg [7:0] cnt_str = 0;
	always @ (posedge clk) begin
		in1 <= ip_sig;
		if (ip_sig)
			cnt_str <= cnt_str + 1;
		else if (in1) begin
			count <= cnt_str;
			cnt_str <= 0;
		end
	end
		
////////////////////////YOUR CODE ENDS HERE//////////////////////////
endmodule
///////////////////////////////MODULE ENDS///////////////////////////
