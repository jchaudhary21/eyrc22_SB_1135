module colour_sensors(
	input clk,
	input colour_freq,
	output red_led,
	output blue_led,
	output green_led,
	output s2,
	output s3
);

reg temp_col_freq1;
reg temp_col_freq2;
reg temp_col_freq3;

reg [7:0] redf_cnt = 0;
reg [7:0] tmp_cnt1 = 0;

reg [7:0] greenf_cnt = 0;
reg [7:0] tmp_cnt2 = 0;

reg [7:0] bluef_cnt = 0;
reg [7:0] tmp_cnt3 = 0;


reg rled=0;
reg gled=0;
reg bled=0;
reg s3f = 0;
reg s2f = 0;

assign s2 = s2f;
assign s3 = s3f;

reg [3:0] first = 4'b0;
reg [3:0] state = 4'b0;

assign red_led = rled;
assign green_led =gled;
assign blue_led = bled;
localparam rfrl = 16666,
    		  rfrh =5000 ,
			  rfgl = 43102,
    		  rfgh = 7142,
			  rfbl = 33333,
    		  rfbh = 10000,
			  gfrl = 39682,
			  gfrh = 14970,
			  gfbl = 30120,
			  gfbh = 8992,
			  gfgl = 25000,
			  gfgh = 5494,
			  bfrl = 41666,
			  bfrh = 13888,
			  bfgl = 45454,
			  bfgh = 14534,
			  bfbl = 25000, 
			  bfbh = 5000,
			  second = 4'b0001,
			  third = 4'b0010; 
			  
	always @ (posedge clk) begin
		
		case(state) 
			first: begin
			
				temp_col_freq1 <= colour_freq;
				if (colour_freq) 
				begin
					tmp_cnt1 <= tmp_cnt1+1;
				end
				else if (temp_col_freq1) begin
					redf_cnt <= tmp_cnt1;
					tmp_cnt1 <= 0;
					state = second;
					s2f<= 0;
					s3f<= 1;
				end
			end
			
			second: begin
			
				temp_col_freq2 <= colour_freq;
				if (colour_freq)begin
					tmp_cnt2 <= tmp_cnt2+1;end
				else if (temp_col_freq2) begin
					bluef_cnt <= tmp_cnt2;
					tmp_cnt2 <= 0;
					state = third;
					s2f<= 1;
					s3f<= 1;
				end
			end
			
			third:begin
			
				temp_col_freq3 <= colour_freq;
				if (colour_freq)begin
					tmp_cnt3 <= tmp_cnt3+1;end
				else if (temp_col_freq3) begin
					greenf_cnt <= tmp_cnt3;
					tmp_cnt3 <= 0;
					state = first;
				end
			end
		endcase
	end

	always @ (posedge clk) begin
	
	if ((redf_cnt > rfrh & redf_cnt < rfrl) & (bluef_cnt > bfrh & bluef_cnt < bfrl) & (greenf_cnt > gfrh & greenf_cnt < gfrl))
	begin
		rled <= 1;
		bled <= 0;
		gled <= 0;
	end
	if ((redf_cnt > rfbh & redf_cnt < rfbl) & (bluef_cnt > bfbh & bluef_cnt < bfbl) & (greenf_cnt > gfbh & greenf_cnt < gfbl))
	begin
		rled <= 0;
		bled <= 1;
		gled <= 0;
	end	
	if ((redf_cnt > rfgh & redf_cnt < rfgl) & (bluef_cnt > bfgh & bluef_cnt < bfgl) & (greenf_cnt > gfgh & greenf_cnt < gfgl))
	begin
		rled <= 0;
		bled <= 0;
		gled <= 1;
	end
	end
		
endmodule
