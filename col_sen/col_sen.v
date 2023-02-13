module col_sen(
	input clk,
	input colour_freq,
	output red_led,
	output blue_led,
	output s2,
	output s3,
	output green_led
	
);


reg temp_col_freq;
reg [100:0] act_freq_cnt1 = 0;
reg [100:0] cnt_freq_str1 = 0;
reg [100:0] act_freq_cnt2 = 0;
reg [100:0] cnt_freq_str2 = 0;
reg [100:0] act_freq_cnt3 = 0;
reg [100:0] cnt_freq_str3 = 0;
reg [100:0] act_freq_cnt4 = 0;
reg [100:0] cnt_freq_str4 = 0;

reg [100:0] sum = 0;
reg [100:0] avg = 0;
reg s2f = 0;
reg s3f = 0;
assign s2 = s2f;
assign s3 = s3f;
reg rled=0;
reg gled=0;
reg bled=0;
assign red_led = rled;
assign green_led =gled;
assign blue_led = bled;
reg [100:0] COUNT_RED = 0;
reg [100:0] COUNT_GREEN = 0;
reg [100:0] COUNT_BLUE = 0;

reg [100:0] count_1 = 0;
reg [100:0] count_2 = 0;
reg [100:0] count_3 = 0;
reg [100:0] count_4 = 0;

always @ (posedge clk )
begin	
	if (s2f ==0 & s3f == 0 ) begin
		if (count_1 < 1000000)begin
			temp_col_freq <= colour_freq;
			if (colour_freq)
				cnt_freq_str1 <= cnt_freq_str1 + 1;
			else if (temp_col_freq) begin
				act_freq_cnt1 <= cnt_freq_str1;
				cnt_freq_str1 <= 0;
			end
			count_1 = count_1+1;
		end
		else begin
				count_1 = 0;
				s2f = 1;
				s3f = 1;
			end
	end
	
		if (s2f ==1 & s3f == 1 ) begin
		if (count_2 < 1000000)begin
			temp_col_freq <= colour_freq;
			if (colour_freq)
				cnt_freq_str2 <= cnt_freq_str2 + 1;
			else if (temp_col_freq) begin
				act_freq_cnt2 <= cnt_freq_str2;
				cnt_freq_str2 <= 0;
			end
			count_2 = count_2+1;
		end
		if (count_2 == 1000000) begin
				count_2 = 0;
				s2f = 1;
				s3f = 0;
			end
	end
	
	if (s2f ==1 & s3f == 0 ) begin
		if (count_3 < 1000000)begin
			temp_col_freq <= colour_freq;
			if (colour_freq)
				cnt_freq_str3 <= cnt_freq_str3 + 1;
			else if (temp_col_freq) begin
				act_freq_cnt3 <= cnt_freq_str3;
				cnt_freq_str3 <= 0;
			end
			count_3 = count_3+1;
		end
		if (count_3 == 1000000) begin
				count_3 = 0;
				s2f = 0;
				s3f = 1;
			end
	end
	
	if (s2f ==0 & s3f == 1 ) begin
		if (count_4 < 1000000)begin
			temp_col_freq <= colour_freq;
			if (colour_freq)
				cnt_freq_str4 <= cnt_freq_str4 + 1;
			else if (temp_col_freq) begin
				act_freq_cnt4 <= cnt_freq_str4;
				cnt_freq_str4 <= 0;
			end
			count_4 = count_4+1;
		end
		if (count_4 == 1000000) begin
				count_4 = 0;
				s2f = 0;
				s3f = 0;
			end
	end
	sum <= act_freq_cnt1+act_freq_cnt2+act_freq_cnt3+act_freq_cnt4;
	avg <= sum >> 2;
		if (sum>1200 & avg<1500)
		begin
			COUNT_RED = COUNT_RED + 1;
			if (COUNT_RED == 30000000) begin
			COUNT_RED = 0;
			COUNT_GREEN = 0;
			COUNT_BLUE = 0;
			rled = 1;
			gled = 0;
			bled = 0;
		
			end
		end
		else if (act_freq_cnt3>2300 & act_freq_cnt4< 2700)
		begin
		COUNT_GREEN = COUNT_GREEN + 1;
		if (COUNT_GREEN == 30000000) begin
			COUNT_RED = 0;
			COUNT_GREEN = 0;
			COUNT_BLUE = 0;
			rled = 0;
			gled = 1;
			bled = 0;
	
			end
		end	
		else if (act_freq_cnt1>3900 & act_freq_cnt2<4500)
		begin
			COUNT_BLUE = COUNT_BLUE + 1;
		if (COUNT_BLUE == 30000000) begin
			COUNT_RED = 0;
			COUNT_GREEN = 0;
			COUNT_BLUE = 0;
			rled = 0;
			gled = 0;
			bled = 1;

		end
		end


end
	

endmodule