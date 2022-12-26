// Copyright (C) 2019  Intel Corporation. All rights reserved.
// Your use of Intel Corporation's design tools, logic functions 
// and other software and tools, and any partner logic 
// functions, and any output files from any of the foregoing 
// (including device programming or simulation files), and any 
// associated documentation or information are expressly subject 
// to the terms and conditions of the Intel Program License 
// Subscription Agreement, the Intel Quartus Prime License Agreement,
// the Intel FPGA IP License Agreement, or other applicable license
// agreement, including, without limitation, that your use is for
// the sole purpose of programming logic devices manufactured by
// Intel and sold by Intel or its authorized distributors.  Please
// refer to the applicable agreement for further details, at
// https://fpgasoftware.intel.com/eula.

// PROGRAM		"Quartus Prime"
// VERSION		"Version 19.1.0 Build 670 09/22/2019 SJ Lite Edition"
// CREATED		"Mon Oct 03 20:36:01 2022"

module comb_ckt_verilog(
	D1,
	D2,
	D3,
	D4,
	D5,
	D6,
	D7,
	D0,
	out
);


input wire	D1;
input wire	D2;
input wire	D3;
input wire	D4;
input wire	D5;
input wire	D6;
input wire	D7;
input wire	D0;
output wire	out;

wire	SYNTHESIZED_WIRE_15;
wire	SYNTHESIZED_WIRE_16;
wire	SYNTHESIZED_WIRE_17;
wire	SYNTHESIZED_WIRE_18;
wire	SYNTHESIZED_WIRE_6;
wire	SYNTHESIZED_WIRE_7;
wire	SYNTHESIZED_WIRE_8;

assign	SYNTHESIZED_WIRE_15 = 1;
assign	SYNTHESIZED_WIRE_16 = 0;




Mux_4_to_1	b2v_inst(
	.I3(SYNTHESIZED_WIRE_15),
	.I2(SYNTHESIZED_WIRE_15),
	.I1(SYNTHESIZED_WIRE_16),
	.I0(SYNTHESIZED_WIRE_16),
	.S1(SYNTHESIZED_WIRE_17),
	.S0(SYNTHESIZED_WIRE_18),
	.out(SYNTHESIZED_WIRE_7));




Mux_2_to_1	b2v_inst14(
	.in1(SYNTHESIZED_WIRE_6),
	.in0(SYNTHESIZED_WIRE_7),
	.s0(SYNTHESIZED_WIRE_8),
	.y(out));


Mux_4_to_1	b2v_inst2(
	.I3(SYNTHESIZED_WIRE_15),
	.I2(SYNTHESIZED_WIRE_16),
	.I1(SYNTHESIZED_WIRE_16),
	.I0(SYNTHESIZED_WIRE_15),
	.S1(SYNTHESIZED_WIRE_17),
	.S0(SYNTHESIZED_WIRE_18),
	.out(SYNTHESIZED_WIRE_6));

assign	SYNTHESIZED_WIRE_8 = D4 | D6 | D7 | D5;

assign	SYNTHESIZED_WIRE_17 = D2 | D6 | D7 | D3;

assign	SYNTHESIZED_WIRE_18 = D1 | D5 | D7 | D3;


endmodule
