/*
	datapath.v
	Gabriel Sacavem Mason
	28/05/2024
*/
module datapath
(
	clock_50,
	key_i,
	switch_i,
	r1_i,
	r2_i,
	e1_i,
	e2_i,
	e3_i,
	e4_i,
	sel_i,
	hex0_o,
	hex1_o,
	hex2_o,
	hex3_o,
	hex4_o,
	hex5_o,
	leds_o,
	end_fpga,
	end_user,
	end_time,
	win_o,
	match_o
);

localparam P_KEY = 4;
localparam P_DEC7SEG = 7;
localparam P_SEQOUTPUT = 4;
localparam P_POINTS = 8;
localparam P_NBTN = 4;
localparam P_COUNTER_ROUND = 4;
localparam P_SEQFPGA = 4;
localparam P_COUNTERTIME = 4;
localparam P_SW = 8;
localparam P_SETUP = 8;
localparam P_Q = 64;
localparam P_Q3 = 4;
localparam P_LED = 10;
localparam P_HEX = 7;	
	
//INPUTS 
input wire clock_50,r1_i,r2_i,e1_i,e2_i,e3_i,e4_i,sel_i;
input wire [P_KEY-1:0]key_i;
input wire [P_SW-1:0]switch_i;

//OUTPUTS	
output wire [P_LED-1:0]leds_o;
output wire [P_HEX-1:0]hex0_o,hex1_o,hex2_o,hex3_o,hex4_o,hex5_o;
output wire	end_fpga,end_user,end_time,win_o,match_o;

wire [P_SETUP-1:0]w_setup;
wire [P_NBTN-1 :0]w_btn;


ButtonSync BUTTON
(
	.KEY0(key_i[0]), 
	.KEY1(key_i[1]), 
	.KEY2(key_i[2]), 
	.KEY3(key_i[3]),
	.CLK(clock_50),
	.BTN0(w_btn[0]), 
	.BTN1(w_btn[1]), 
	.BTN2(w_btn[2]), 
	.BTN3(w_btn[3])
);
wire [P_NBTN-1:0]w_nbtn = ~w_btn;

reg_setup U04
(
	.sw_i(switch_i),
	.r_i(r1_i),
	.e_i(e1_i),
	.clk_i(clock_50),
	.setup_o(w_setup)
);

wire w_c025,w_c05,w_c1,w_c2; 

fsm_clock U03
(
	.clk_i(clock_50),
	.r_i(r1_i),
	.c025_o(w_c025),
	.c05_o(w_c05),
	.c1_o(w_c1),
	.c2_o(w_c2)
);
wire w_clkhz;

mux4x1 U05
(
	.F1_i(w_c025),
	.F2_i(w_c05),
	.F3_i(w_c1),
	.F4_i(w_c2),
	.SEL_i({w_setup[7],w_setup[6]}),
	.F_o(w_clkhz)
);

wire [P_COUNTERTIME-1:0]w_tempo;

counter_time U02
(
	.clk_i(w_c1),
	.r_i(r2_i),
	.e_i(e2_i),
	.tempo_o(w_tempo),
	.end_time(end_time)
);
wire [P_COUNTER_ROUND-1:0]w_round;

counter_round U06
(
	.clk_i(clock_50),
	.r_i(r1_i),
	.e_i(e4_i),
	.data_i(w_setup[3:0]),
	.tc_o(win_o),
	.round_o(w_round)
);

wire [P_SEQFPGA-1:0]w_seqfpga;

counter_fpga U07
(
	.clk_i(w_clkhz),
	.r_i(r2_i),
	.e_i(e3_i),
	.data_i(w_round),
	.tc_o(end_fpga),
	.seqfpga_o(w_seqfpga)
);

wire [P_SEQOUTPUT-1:0]w_seq1_o;

seq1 U08
(
    .address(w_seqfpga),
    .output_reg(w_seq1_o)
);
wire [P_SEQOUTPUT-1:0]w_seq2_o;
seq2 U09
(
    .address(w_seqfpga),
    .output_reg(w_seq2_o)
);
wire [P_SEQOUTPUT-1:0]w_seq3_o;
seq3 U10
(
    .address(w_seqfpga),
    .output_reg(w_seq3_o)
);
wire [P_SEQOUTPUT-1:0]w_seq4_o;
seq4 U11
(
    .address(w_seqfpga),
    .output_reg(w_seq4_o)
);

wire [P_SEQOUTPUT-1:0]w_seq_fpga;

mux4x1_4bits U12
(
	.F1_i(w_seq1_o),
	.F2_i(w_seq2_o),
	.F3_i(w_seq3_o),
	.F4_i(w_seq4_o),
	.SEL_i({w_setup[5],w_setup[4]}),
	.F_o(w_seq_fpga)
);

wire [P_Q-1:0]w_out_fpga;
wire [P_Q3-1:0]w_q3_o;

reg_fpga U15
(
	.clk_i(w_clkhz),
	.r_i(r2_i),
	.e_i(e3_i),
	.data_i({w_seqfpga,w_out_fpga[63:4]}),
	.q_o(w_out_fpga),
	.q3_o(w_q3_o)
);


wire or12and1;
wire and12conteruser;
wire orbtn = w_nbtn[3] |w_nbtn[2] | w_nbtn[1] | w_nbtn[0];
and(and12conteruser,orbtn,e2_i);

counter_user U13
(
	.clk_i(clock_50),
	.r_i(r2_i),
	.e_i(and12conteruser),
	.data_i(w_round),
	.tc_o(end_user)
);

wire [P_POINTS-1:0]w_points;

logica U14
(
	.reg_setupLevel({w_setup[7],w_setup[6]}),
	.round(w_round),
	.reg_setupMapa({w_setup[5],w_setup[4]}),
	.points(w_points)
);

 
wire [P_Q-1:0]w_out_user;
wire or22and2;
wire and22reg_user;
wire orbtn1 = w_nbtn[3] |w_nbtn[2] | w_nbtn[1] | w_nbtn[0];
and(and22reg_user,orbtn1,e2_i);

reg_user U16
(
	.clk_i(clock_50),	
	.r_i(r2_i),
	.e_i(and22reg_user),
	.data_i({w_nbtn,w_out_user}),
	.q_o(w_out_user)
);

wire w_win;
assign w_win = win_o;
wire [6:0]w_mux02_mux1;

mux2x1 MUX0
(
	.a_i(~7'b011_1110), //U 7'b1000_111
	.b_i(~7'b111_0001), //F
	.sel_i(w_win),
	.saida_o(w_mux02_mux1)
);

mux2x1 MUX1
(
	.a_i(w_mux02_mux1),
	.b_i(~7'b011_1000), //L
	.sel_i(sel_i),
	.saida_o(hex5_o)	
);	

wire [P_DEC7SEG-1:0]w_dec0_mux2;

dec7seg DEC0
(
	 .bcd_i({2'b00,w_setup[7:6]}),
	 .seg_o(w_dec0_mux2)
);

wire [6:0]w_mux2_mux3;

mux2x1 MUX2
(
	.a_i(~7'b110_1101), //S
	.b_i(~7'b111_0011), //P
	.sel_i(w_win),
	.saida_o(w_mux2_mux3)	
);	

mux2x1 MUX3
(
	.a_i(w_mux2_mux3),
	.b_i(w_dec0_mux2),
	.sel_i(sel_i),
	.saida_o(hex4_o)	
);	

wire [6:0]w_mux4_mux5;

mux2x1 MUX4
(
	.a_i(~7'b111_1101), //G
	.b_i(~7'b111_1001), //E
	.sel_i(w_win),
	.saida_o(w_mux4_mux5)
);

mux2x1 MUX5
(
	.a_i(~7'b111_0001), //T
	.b_i(w_mux4_mux5),
	.sel_i(sel_i),
	.saida_o(hex3_o)	
);
wire [P_DEC7SEG-1:0]w_dec1_mux6;

dec7seg DEC1
(
    .bcd_i(w_tempo),
    .seg_o(w_dec1_mux6)
);

wire [6:0]w_mux6_mux7;

mux2x1 MUX6
(
	.a_i(~7'b101_0000), //r
	.b_i(~7'b111_0111), //A
	.sel_i(w_win),
	.saida_o(w_mux6_mux7)	
);	

mux2x1 MUX7
(
	.a_i(w_mux6_mux7),
	.b_i(w_dec1_mux6),
	.sel_i(sel_i),
	.saida_o(hex2_o)	
);	
wire [P_DEC7SEG-1:0]w_dec2_mux8;

dec7seg DEC2
(
    .bcd_i(w_points[7:4]),
    .seg_o(w_dec2_mux8)
);

mux2x1 MUX8
(
	.a_i(w_dec2_mux8),
	.b_i(~7'b101_0000), //r
	.sel_i(sel_i),
	.saida_o(hex1_o)	
);
wire [P_DEC7SEG-1:0]w_dec3_mux9;
wire [P_DEC7SEG-1:0]w_dec4_mux9;

dec7seg DEC3
(
    .bcd_i(w_round),
    .seg_o(w_dec3_mux9)
);

dec7seg DEC4
(
    .bcd_i(w_points[3:0]),
    .seg_o(w_dec4_mux9)
);

mux2x1 MUX9
(
	.a_i(w_dec4_mux9),
	.b_i(w_dec3_mux9),
	.sel_i(sel_i),
	.saida_o(hex0_o)	
);

wire [3:0] w_ledr;
not(w_ledr[0], key_i[0]);
not(w_ledr[1], key_i[1]);
not(w_ledr[2], key_i[2]);
not(w_ledr[3], key_i[3]);

assign leds_o[9:6] = w_ledr;
assign leds_o[5:4] = 2'b11;
assign leds_o[3:0] = w_q3_o;


assign match_o = (w_out_fpga == w_out_user) && end_user ? 1'b1 : 1'b0;

endmodule
