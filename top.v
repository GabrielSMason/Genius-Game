/*
	top.v
	Gabriel Sacavem Mason
	28/05/2024
*/
module top
(
	CLOCK_50,
	KEY,
	SW,
	LEDR,
	HEX0,
	HEX1,
	HEX2,
	HEX3,
	HEX4,
	HEX5
);
localparam P_KEY = 4;
localparam P_SW = 10;
localparam P_LDR = 10;
localparam P_HEX = 7;

//INPUTS 
input wire CLOCK_50;
input wire [P_KEY-1:0]KEY;
input wire [P_SW-1:0]SW;

//OUTPUTS	
output wire [P_LDR-1:0]LEDR;
output wire [P_HEX-1:0]HEX0,HEX1,HEX2,HEX3,HEX4,HEX5;

wire w_r1, w_r2, w_e1, w_e2, w_e3, w_e4;
wire w_end_fpga,w_end_user,w_end_time;
wire w_win,w_match;
wire w_sel;

datapath U00
(
	.clock_50 (CLOCK_50),
	.key_i(KEY),
	.switch_i(SW[9:2]),
	.r1_i(w_r1),
	.r2_i(w_r2),
	.e1_i(w_e1),
	.e2_i(w_e2),
	.e3_i(w_e3),
	.e4_i(w_e4),
	.sel_i(w_sel),
	.hex0_o(HEX0),
	.hex1_o(HEX1),
	.hex2_o(HEX2),
	.hex3_o(HEX3),
	.hex4_o(HEX4),
	.hex5_o(HEX5),
	.leds_o(LEDR),
	.end_fpga(w_end_fpga),
	.end_user(w_end_user),
	.end_time(w_end_time),
	.win_o(w_win),
	.match_o(w_match)
);

controle U01
(
	.clock_50(CLOCK_50),
	.enter(SW[0]),
	.reset(SW[1]),
	.end_fpga(w_end_fpga),
	.end_user(w_end_user),
	.end_time(w_end_time),
	.win(w_win),
	.match(w_match),
	.r1(w_r1),
	.r2(w_r2),
	.e1(w_e1),
	.e2(w_e2),
	.e3(w_e3),
	.e4(w_e4),
	.sel(w_sel)	
);



endmodule
