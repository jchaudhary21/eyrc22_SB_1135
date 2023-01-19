module pwm_motor(
 
    input clk,             // Clock input
    // input [7:0]DUTY_CYCLE, // Input Duty Cycle
    output PWM_OUT1,
	 output PWM_OUT2,// Output PWM
    output PWM_OUT3,
	 output PWM_OUT4
);
 
//
//reg [7:0]DUTY_CYCLE = 8'b01100100 ; // 100% 
//reg  DUTY_CYCLE = 8'b00110010 ;  // 50 % ;
reg [7:0]DUTY_CYCLE = 8'b00000101 ;  // 20 % ;
// DUTY_CYCLE = 8'b00000000 ;  // 20 % ;


 
reg pwm_out1 = 0;
reg pwm_out2 = 0 ;
reg pwm_out3 = 1 ;
reg pwm_out4 = 0 ;
reg [7:0]freq_cnt1 = 0;
reg [7:0]freq_cnt2 = 0;
assign PWM_OUT1 = pwm_out1 ;
assign PWM_OUT2 = pwm_out2 ;
assign PWM_OUT3 = pwm_out3 ;
assign PWM_OUT4 = pwm_out4 ;
reg [7:0]counter = 8'b0 ; 

always @( posedge clk )

begin


		if (freq_cnt1 == 78) begin
			pwm_out1 <= 1;
			freq_cnt1 <= 0;
		end
		else begin
			pwm_out1 <= 0;
			freq_cnt1 <= freq_cnt1 + 1;
			end
//		if (freq_cnt == 50) begin
//
//        if ( counter == 8'b01100100 | counter == 8'b00000000 )
//        begin 
//                counter =  8'b10 ;
//                pwm_out1 = 0 ;
//        end 
//                
//
//        else 
//        begin 
//                if( counter <= DUTY_CYCLE - 1 )
//                
//                begin            
//                    pwm_out1 = 0 ;
//                    counter = counter + 8'b10 ;
//                end 
//                
//                
//                else 
//                
//                begin 
//                    pwm_out1 = 1 ;
//                    counter = counter + 8'b10 ;
//                    
//                end 
//			end
//		  freq_cnt <= 0;
//	end
//	else begin
//			freq_cnt <=freq_cnt+1;
//	end     
end   

always @( posedge clk )

begin


		if (freq_cnt2 == 215) begin
			pwm_out2 <= 1;
			freq_cnt2 <= 0;
		end
		else begin
			pwm_out2 <= 0;
			freq_cnt2 <= freq_cnt2 + 1;
			end 
end
////////////////////////YOUR CODE ENDS HERE//////////////////////////
endmodule
///////////////////////////////MODULE ENDS///////////////////////////