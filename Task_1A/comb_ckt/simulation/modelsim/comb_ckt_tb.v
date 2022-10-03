`timescale 1 ps/1 ps

module comb_ckt_tb;

reg D0;
reg D1;
reg D2;
reg D3;
reg D4;
reg D5;
reg D6;
reg D7;
wire	out;

reg   exp_out;

comb_ckt_verilog dut(.D0(D0), .D1(D1), .D2(D2), .D3(D3), .D4(D4), .D5(D5), .D6(D6), .D7(D7), .out(out) );

reg [7:0] ip [7:0]; //16 inputs, each 14 bits
reg op [7:0]; //16 outputs, each 1 bit

reg   flag = 1;
integer fw;
reg [3:0]i = 0;

initial begin

	ip[7]  = 8'b10000000; op[7]  = 1;
	ip[6]  = 8'b01000000; op[6]  = 0;
	ip[5]  = 8'b00100000; op[5]  = 0;
	ip[4]  = 8'b00010000; op[4]  = 1;
	ip[3]  = 8'b00001000; op[3]  = 1;
	ip[2]  = 8'b00000100; op[2]  = 1;
	ip[1]  = 8'b00000010; op[1]  = 0;
	ip[0]  = 8'b00000001; op[0]  = 0;


end

always begin

	D0 = ip[i][0];
	D1 = ip[i][1];
	D2 = ip[i][2];
	D3 = ip[i][3];
	D4 = ip[i][4];
	D5 = ip[i][5];
	D6 = ip[i][6];
	D7 = ip[i][7];
	exp_out <= op[i];
	
	#100;	
	
	if (i == 7)
		i = 0;
	else
		i = i + 1;
		


end

always begin

	#5;

	if(out !== exp_out) begin
		flag = 0;
	end
		
end

always begin

	#1600;
	
	if(flag == 0) begin
		fw = $fopen("results.txt","w");
		$fdisplay(fw,"Errors");
		$display("Error(s) encountered, please check your design!");
		$fclose(fw);
	end
	else begin
		fw = $fopen("results.txt","w");
		$fdisplay(fw,"No Errors");
		$display("No errors encountered, congratulations!");
		$fclose(fw);
	end
		
end

endmodule

