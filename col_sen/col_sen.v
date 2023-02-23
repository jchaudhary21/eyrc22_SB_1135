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
reg [50:0] act_freq_cnt1 = 0;
reg [50:0] cnt_freq_str1 = 0;
reg [50:0] act_freq_cnt2 = 0;
reg [50:0] cnt_freq_str2 = 0;
reg [50:0] act_freq_cnt3 = 0;
reg [50:0] cnt_freq_str3 = 0;
reg [50:0] act_freq_cnt4 = 0;
reg [50:0] cnt_freq_str4 = 0;

reg [50:0] new_act_freq_cnt1 = 0;
reg [50:0] new_act_freq_cnt2 = 0;
reg [50:0] new_act_freq_cnt3 = 0;
reg [50:0] new_act_freq_cnt4 = 0;

reg [50:0] sum = 0;
reg [50:0] avg = 0;
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
reg [50:0] COUNT_RED = 0;
reg [50:0] COUNT_GREEN = 0;
reg [50:0] COUNT_BLUE = 0;

reg [50:0] count_1 = 0;
reg [50:0] count_2 = 0;
reg [50:0] count_3 = 0;
reg [50:0] count_4 = 0;
reg [50:0] final_val1 = 0;
reg [50:0] final_val2= 0;
reg [50:0] final_val3= 0;
reg [50:0] final_val4= 0;
reg [50:0] check_counter1r= 0;
reg [50:0] check_counter2r= 0;
reg [50:0] check_counter3r= 0;
reg [50:0] check_counter4r= 0;
reg [50:0] check_counter1g= 0;
reg [50:0] check_counter2g= 0;
reg [50:0] check_counter3g= 0;
reg [50:0] check_counter4g= 0;
reg [50:0] check_counter1b= 0;
reg [50:0] check_counter2b= 0;
reg [50:0] check_counter3b= 0;
reg [50:0] check_counter4b= 0;

reg [50:0] red_delay= 0;
reg [50:0] blue_delay= 0;
reg [50:0] green_delay= 0;
reg [50:0] global_count = 0;
always @ (posedge clk )
begin
if (global_count <5000000 ) begin
	if (s2f ==0 & s3f == 0 ) begin
		if (count_1 < 78125)begin
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
				new_act_freq_cnt1 = new_act_freq_cnt1 + act_freq_cnt1;
				final_val1 = new_act_freq_cnt1;
							if (2400 < act_freq_cnt1 &  2900 > act_freq_cnt1)begin
					check_counter1r = check_counter1r+1;end
			if (4500 < act_freq_cnt1 &  4900 > act_freq_cnt1)begin
					check_counter1g = check_counter1g+1;	end
			if (13000 < act_freq_cnt1 &  13800 > act_freq_cnt1)begin
					check_counter1b = check_counter1b+1;	end
			end

	end
	
		if (s2f ==1 & s3f == 1 ) begin
		if (count_2 < 78125)begin
			temp_col_freq <= colour_freq;
			if (colour_freq)
				cnt_freq_str2 <= cnt_freq_str2 + 1;
			else if (temp_col_freq) begin
				act_freq_cnt2 <= cnt_freq_str2;
				cnt_freq_str2 <= 0;
			end
			count_2 = count_2+1;
		end
		else begin
				count_2 = 0;
				s2f = 1;
				s3f = 0;
				new_act_freq_cnt2 = new_act_freq_cnt2 + act_freq_cnt2;
				final_val2 = new_act_freq_cnt2;
				if (12500 < act_freq_cnt2 &  14000 > act_freq_cnt2)begin
					check_counter2r = check_counter2r+1;end
			if (3200 < act_freq_cnt2 &  3600 > act_freq_cnt2)begin
					check_counter2g = check_counter2g+1;	end
			if (9300 < act_freq_cnt2 &  9800 > act_freq_cnt2)begin
					check_counter2b = check_counter2b+1;	end
		end
	end
	
	if (s2f ==1 & s3f == 0 ) begin
		if (count_3 < 78125)begin
			temp_col_freq <= colour_freq;
			if (colour_freq)
				cnt_freq_str3 <= cnt_freq_str3 + 1;
			else if (temp_col_freq) begin
				act_freq_cnt3 <= cnt_freq_str3;
				cnt_freq_str3 <= 0;
			end
			count_3 = count_3+1;
		end
		else begin
				count_3 = 0;
				s2f = 0;
				s3f = 1;
				new_act_freq_cnt3 = new_act_freq_cnt3 + act_freq_cnt3;
				final_val3 = new_act_freq_cnt3;
			if (1500 < act_freq_cnt3 &  2000 > act_freq_cnt3)begin
					check_counter3r = check_counter3r+1;end
			if (1200 < act_freq_cnt3 &  1600 > act_freq_cnt3)begin
					check_counter3g = check_counter3g+1;	end
			if (1800 < act_freq_cnt3 &  2300 > act_freq_cnt3)begin
					check_counter3b = check_counter3b+1;	end
			end
	end
	
	if (s2f ==0 & s3f == 1 ) begin
		if (count_4 < 78125)begin
			temp_col_freq <= colour_freq;
			if (colour_freq)
				cnt_freq_str4 <= cnt_freq_str4 + 1;
			else if (temp_col_freq) begin
				act_freq_cnt4 <= cnt_freq_str4;
				cnt_freq_str4 <= 0;

			end
			count_4 = count_4+1;
		end
		else begin
				count_4 = 0;
				s2f = 0;
				s3f = 0;
				new_act_freq_cnt4 = new_act_freq_cnt4 + act_freq_cnt4;
				final_val4 = new_act_freq_cnt4;
			if (7200 < act_freq_cnt4 &  14000 > act_freq_cnt4)begin
					check_counter4r = check_counter4r+1;end
			if (6800 < act_freq_cnt4 &  7200 > act_freq_cnt4)begin
					check_counter4g = check_counter4g+1;	end
			if (3500 < act_freq_cnt4 &  4200 > act_freq_cnt4)begin
					check_counter4b = check_counter4b+1;	end
			end
	end
	global_count = global_count +1 ;
end
else begin
sum = (final_val1 >> 4)+(final_val2 >> 4)+(final_val3 >> 4)+(final_val4 >> 4);
avg = sum >> 2;
COUNT_RED = check_counter1r+check_counter2r+check_counter3r+check_counter4r;
COUNT_GREEN = check_counter1g+check_counter2g+check_counter3g+check_counter4g;
COUNT_BLUE = check_counter1b+check_counter2b+check_counter3b+check_counter4b;

global_count = 0 ;
new_act_freq_cnt1 = 0;
new_act_freq_cnt2= 0;
new_act_freq_cnt3= 0;
new_act_freq_cnt4= 0;
check_counter1b = 0;
check_counter2b = 0;
check_counter3b = 0;
check_counter4b = 0;
check_counter1r = 0;
check_counter2r = 0;
check_counter3r = 0;
check_counter4r = 0;
check_counter1g = 0;
check_counter2g = 0;
check_counter3g = 0;
check_counter4g = 0;
end
end
always @ (posedge clk )
begin
	if (COUNT_RED >60 | (avg>4500 & avg<4800))
		begin
		red_delay = red_delay+1;
		if (red_delay == 1000000) begin
			red_delay = 0;
			rled = 1;
			gled = 0;
			bled = 0;
		end
		end
		else if (COUNT_GREEN >60 | (avg>2800 & avg<3200))
		begin
		green_delay = green_delay+1;
		if (green_delay == 1000000) begin
			green_delay = 0;
			rled = 0;
			gled = 1;
			bled = 0;
		end
		end	
		else if (COUNT_BLUE >60 | (avg>5000 & avg<5500))
		begin
		blue_delay = blue_delay+1;
		if (blue_delay == 1000000) begin
			blue_delay = 0;
			rled = 0;
			gled = 0;
			bled = 1;
		end
		end


end


endmodule