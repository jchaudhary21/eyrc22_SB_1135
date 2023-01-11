
module COLOUR_SENSOR(
	input clk,
	input colour_freq,
	output red_led,
	output blue_led,
	output green_led,
	output [7:0] count
);


reg temp_col_freq;
reg [7:0] act_freq_cnt = 0;
reg [7:0] cnt_freq_str = 0;
reg [6:0] pwm_cnt = 0;
reg pwm_50;
reg rled=1;
reg gled=1;
reg bled=1;
assign count = act_freq_cnt;
assign red_led = rled;
assign green_led =gled;
assign blue_led = bled;
localparam lower_red = 2085,
    		  upper_red = 2777,
			  lower_blue =3333,
    		  upper_blue =5000,
			  lower_green = 1666,
    		  upper_green = 1950;
	always @ (posedge clk) begin
		temp_col_freq <= colour_freq;
		if (colour_freq)
			cnt_freq_str <= cnt_freq_str + 1;
		else if (temp_col_freq) begin
			act_freq_cnt <= cnt_freq_str;
			cnt_freq_str <= 0;
		end
		if (act_freq_cnt>lower_red & act_freq_cnt<upper_red)
		begin
			rled = 1;
			gled = 0;
			bled = 0;
		end
		if (act_freq_cnt>lower_green & act_freq_cnt<upper_green)
		begin
			rled = 0;
			gled = 1;
			bled = 0;
		end	
		if (act_freq_cnt>lower_blue & act_freq_cnt<upper_blue)
		begin
			rled = 0;
			gled = 0;
			bled = 1;
		end
		else
		begin
		   rled = 0;
			gled = 0;
			bled = 0;
		end
	end
	
//	always @ (posedge clk) begin
//		if (pwm_cnt == 99) 
//			pwm_cnt <= 0;
//		else
//			pwm_cnt <= pwm_cnt +1;
//		
//		pwm_50 = (pwm_cnt>50) ? 1 : 0;
//		
//		if (act_freq_cnt>lower_red & act_freq_cnt<upper_red)
//			rled = pwm_50;
//		if (act_freq_cnt>lower_green & act_freq_cnt<upper_green)
//			gled = pwm_50;	
//		if (act_freq_cnt>lower_blue & act_freq_cnt<upper_blue)
//			bled = pwm_50;
//	end
	
		
endmodule