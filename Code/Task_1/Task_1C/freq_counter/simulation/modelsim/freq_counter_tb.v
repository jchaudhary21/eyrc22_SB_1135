`timescale 1 ps/1 ps

module freq_counter_tb;

reg clk;
reg in;

wire [7:0]count;
reg  [7:0]exp_count = 0;

freq_counter dut(clk, in, count);

integer fw;
reg   flag = 1;
reg [7:0]temp = 0;
reg [7:0]temp_reg = 0; 

initial begin

	in = 1; #100;
	in = 0; #150;
	in = 1; #250;
	in = 0; #50;
	in = 1; #50;
	in = 0; #200;
	in = 1; #30;
	in = 0; #40;
	in = 1; #130;
	in = 0; #50;

end

always begin

	clk = 0; #5;
	clk = 1; #5;

end

always @ (posedge clk)
begin
	if (in == 1) begin
		temp = temp + 1'b1;
	end
	else begin
		temp = 0;
	end

	if (temp !=0)
		temp_reg <= temp;
	else
		exp_count <= temp_reg;
end

always begin

	#10;

	if(count !== exp_count) begin
		flag = 0;
	end
		
end

always begin

	#1050;
	
	if(flag == 0) begin
		fw = $fopen("results.txt","w");
		$fdisplay(fw, "%02h","Errors");
		$display("Error(s) encountered, please check your design!");
		$fclose(fw);
	end
	else begin
		fw = $fopen("results.txt","w");
		$fdisplay(fw, "%02h","No Errors");
		$display("No errors encountered, congratulations!");
		$fclose(fw);
	end
		
end

endmodule
