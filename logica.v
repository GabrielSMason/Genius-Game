module logica
(
	reg_setupLevel,
	round,
	reg_setupMapa,
	points
);

input wire [1:0]reg_setupLevel;
input wire [1:0]reg_setupMapa;
input wire [3:0]round;
output wire [7:0]points;


assign points = reg_setupLevel * round;

endmodule
