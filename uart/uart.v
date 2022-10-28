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
//Output  : d : UART transmit output

//////////////////DO NOT MAKE ANY CHANGES IN MODULE//////////////////
module uart(
	input clk_50M,	//50 MHz clock
	output tx		//UART transmit output
);
////////////////////////WRITE YOUR CODE FROM HERE////////////////////
reg d=1'b1;
assign tx=d;
reg [31:0]count = 0;
localparam idle = 4'b0,
			  start = 4'd1,
			  stop = 4'd2,
			  state_s = 4'd3,
			  state_b = 4'd4,
			  state_th = 4'd5,
			  state_fv = 4'd6,
			  state_s1 = 4'd7,
			  state_s2 = 4'd8,
			  state_s3 = 4'd9,
			  state_s4 = 4'd10,
			  state_s5 = 4'd11,
			  state_s6 = 4'd12,
			  state_s7 = 4'd13,
			  state_s8 = 4'd14,
			  state_b1 = 4'd15,
			  state_b2 = 5'd16,
			  state_b3 = 5'd17,
			  state_b4 = 5'd18,
			  state_b5 = 5'd19,
			  state_b6 = 5'd20,
			  state_b7 = 5'd21,
			  state_b8 = 5'd22,
			  state_th1 = 5'd23,
			  state_th2 = 5'd24,
			  state_th3 = 5'd25,
			  state_th4 = 5'd26,
			  state_th5 = 5'd27,
			  state_th6 = 5'd28,
			  state_th7 = 5'd29,
			  state_th8 = 5'd30,
			  state_fv1 = 4'd31,
			  state_fv2 = 6'd32,
			  state_fv3 = 6'd33,
			  state_fv4 = 6'd34,
			  state_fv5 = 6'd35,
			  state_fv6 = 6'd36,
			  state_fv7 = 6'd37,
			  state_fv8 = 6'd38,
			  finish = 6'd39;

reg [5:0]states = start;
reg [5:0]state1 = state_s1; 
reg [5:0]state2 = state_b1;
reg [5:0]state3 = state_th1;
reg [5:0]state4 = state_fv1;

reg [2:0]int_count = 2'b00;
reg [2:0]check = 0;
 always @(posedge clk_50M) begin
		if (count<433) begin
		count <= count +1 ;
		end
		else if (count==433) begin
		
			case(states)
			idle:
			if (d != 1'b1) begin d<=1'b1;end
			else if (check==4) begin states=finish;end
			else begin states=start;
			count=0;end
			
			start: 
			if (d != 1'b0) begin d<=1'b0;end
			else if (int_count == 2'b00) begin states = state_s;
			count=0;end
			else if (int_count == 2'b01) begin states = state_b;
			count=0;end
			else if (int_count == 2'b10) begin states = state_th;
			count=0;end
			else if (int_count == 2'b11) begin states = state_fv;
			count=0;end
			
			state_s:
			case(state1)
					
						state_s1:
						if (d != 1'b1) begin d <=1'b1;end
						else begin state1 = state_s2;
						count=0;end
						
						state_s2:
						if (d != 1'b1) begin d <=1'b1;end
						else begin state1 = state_s3;
						count=0;end
						
						state_s3:
						if (d != 1'b0) begin d <=1'b0;end
						else begin state1 = state_s4;
						count=0;end
						
						state_s4:
						if (d != 1'b0) begin d <=1'b0;end
						else begin state1 = state_s5;
						count=0;end
						
						state_s5:
						if (d != 1'b1) begin d <=1'b1;end
						else begin state1 = state_s6;
						count=0;end
						
						state_s6:
						if (d != 1'b0) begin d <=1'b0;end
						else begin state1 = state_s7;
						count=0;end
						
						state_s7:
						if (d != 1'b1) begin d <=1'b1;end
						else begin state1 = state_s8;
						count=0;end
						
						state_s8:
						if (d != 1'b0) begin d <=1'b0;end
						else begin states = stop;
									  int_count = 2'b01;
									  count=0;end
					endcase
					
			state_b:
			case(state2)
					
						state_b1:
						if (d != 1'b0) begin d <=1'b0;end
						else begin state2 = state_b2;
						count=0;end
						
						state_b2:
						if (d != 1'b1) begin d <=1'b1;end
						else begin state2 = state_b3;
						count=0;end
						
						state_b3:
						if (d != 1'b0) begin d <=1'b0;end
						else begin state2 = state_b4;
						count=0;end
						
						state_b4:
						if (d != 1'b0) begin d <=1'b0;end
						else begin state2 = state_b5;
						count=0;end
						
						state_b5:
						if (d != 1'b0) begin d <=1'b0;end
						else begin state2 = state_b6;
						count=0;end
						
						state_b6:
						if (d != 1'b0) begin d <=1'b0;end
						else begin state2 = state_b7;
						count=0;end
						
						state_b7:
						if (d != 1'b1) begin d <=1'b1;end
						else begin state2 = state_b8;
						count=0;end
						
						state_b8:
						if (d != 1'b0) begin d <=1'b0;end
						else begin states = stop;
									  int_count = 2'b10;
									  count=0;end
					endcase
					
			state_th:
			case(state3)
					
						state_th1:
						if (d != 1'b1) begin d <=1'b1;end
						else begin state3 = state_th2;
						count=0;end
						
						state_th2:
						if (d != 1'b1) begin d <=1'b1;end
						else begin state3 = state_th3;
						count=0;end
						
						state_th3:
						if (d != 1'b0) begin d <=1'b0;end
						else begin state3 = state_th4;
						count=0;end
						
						state_th4:
						if (d != 1'b0) begin d <=1'b0;end
						else begin state3 = state_th5;
						count=0;end
						
						state_th5:
						if (d != 1'b1) begin d <=1'b1;end
						else begin state3 = state_th6;
						count=0;end
						
						state_th6:
						if (d != 1'b1) begin d <=1'b1;end
						else begin state3 = state_th7;
						count=0;end
						
						state_th7:
						if (d != 1'b0) begin d <=1'b0;end
						else begin state3 = state_th8;
						count=0;end
						
						state_th8:
						if (d != 1'b0) begin d <=1'b0;end
						else begin states = stop;
									  int_count = 2'b11;
									  count=0;end
						endcase
			state_fv:
			
					case(state4)
					
						state_fv1:
						if (d != 1'b1) begin d <=1'b1;end
						else begin state4 = state_fv2;
						count=0;end
						
						state_fv2:
						if (d != 1'b0) begin d <=1'b0;end
						else begin state4 = state_fv3;
						count=0;end
						
						state_fv3:
						if (d != 1'b1) begin d <=1'b1;end
						else begin state4 = state_fv4;
						count=0;end
						
						state_fv4:
						if (d != 1'b0) begin d <=1'b0;end
						else begin state4 = state_fv5;
						count=0;end
						
						state_fv5:
						if (d != 1'b1) begin d <=1'b1;end
						else begin state4 = state_fv6;
						count=0;end
						
						state_fv6:
						if (d != 1'b1) begin d <=1'b1;end
						else begin state4 = state_fv7;
						count=0;end
						
						state_fv7:
						if (d != 1'b0) begin d <=1'b0;end
						else begin state4 = state_fv8;
						count=0;end
						
						state_fv8:
						if (d != 1'b0) begin d <=1'b0;end
						else begin states = stop;
									  count=0;end
					endcase
			
			stop:
			if (d != 1'b1) begin d<=1'b1;end
			else begin states=idle;
			check<=check+1;
			count=0;end
			
			finish:
			d<=1;
		endcase
		end
end

////////////////////////YOUR CODE ENDS HERE//////////////////////////
endmodule
///////////////////////////////MODULE ENDS///////////////////////////