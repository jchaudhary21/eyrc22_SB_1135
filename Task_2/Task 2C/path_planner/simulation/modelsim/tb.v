module tb;

reg clk = 0;
reg start = 0;
reg [4:0] s_node;
reg [4:0] e_node;

wire done;
reg done_exp;

wire [10*5-1:0] final_path;
reg [10*5-1:0] final_path_exp = 50'd0;

reg check;

reg flag  = 1;
integer fw;

path_planner uut (clk, start, s_node, e_node, done, final_path);

always begin

	clk <= 0; #1;
	clk <= 1; #1;

end

initial begin

	s_node <= 0;
	e_node <= 9;
	#3300;
	s_node <= 9;
	e_node <= 11;
	#3200;
	s_node <= 11;
	e_node <= 10;

end

initial begin

	start <= 0; #100;
	start <= 1; #200;
	start <= 0; #3000;
	start <= 1; #200;
	start <= 0; #3000;
	start <= 1; #200;
	start <= 0;

end

initial begin

	done_exp <= 1; #100;
	done_exp <= 0; #3000;
	done_exp <= 1; #200;
	done_exp <= 0; #3000;
	done_exp <= 1; #200;
	done_exp <= 0; #3000;
	done_exp <= 1;

end

initial begin

	final_path_exp <= 0; #3100;
	final_path_exp <= 50'b11011110111101111011110110000000001000100010101001; #3200;
	final_path_exp <= 50'b11011110110100101111101101010010010011010110001011; #3200;
	final_path_exp <= 50'b11011010110110001101100101010010110101111000001010;

end

initial begin

	check <= 0; #(190);
	check <= 1; #(20);
	check <= 0; #(2980);
	check <= 1; #(20);
	check <= 0; #(180);
	check <= 1; #(20);
	check <= 0; #(2980);
	check <= 1; #(20);
	check <= 0; #(180);
	check <= 1; #(20);
	check <= 0; #(2980);
	check <= 1; #(20);
	check <= 0;

end

always @ (posedge clk) begin

	if(check == 1) begin
	
		if(final_path_exp !== final_path || done_exp !== done) begin
		
			flag <= 0;
		
		end
	
	end

end

initial begin

	#11500;
		
	fw = $fopen("result.txt","w");

	if(flag == 1) begin
		$fdisplay(fw,"%02h","No Errors");
		$display("No errors encountered, congratulations!");
	end
	else begin
		$fdisplay(fw,"%02h","Errors");
		$display("Error(s) encountered, please check your design!");
	end
	
	$fclose(fw);

end

endmodule