// Verilog Test Bench code for AND gate
module And_Gate_Test_Bench ;
reg A;reg B;
wire C ;
// Defining unit under test i.e AND_GATE
AND_GATE uut (.A(A) ,.B(B) ,. C(C));
// Assigning all possible states for input A and B
initial begin

A = 0; B = 0; #100;
A = 0; B = 1; #100;
A = 1; B = 0; #100;
A = 1; B = 1; #100;

end
endmodule