module mux4x1_4bits
(
	F1_i,
	F2_i,
	F3_i,
	F4_i,
	SEL_i,
	F_o
);


localparam WIDTH = 4;
localparam SEL = 2;

input wire  [WIDTH - 1:0] F1_i;
input wire  [WIDTH - 1:0] F2_i;
input wire  [WIDTH - 1:0] F3_i;
input wire  [WIDTH - 1:0] F4_i;
input wire  [SEL   - 1:0] SEL_i;
output reg  [WIDTH - 1:0] F_o;
	
always @(F1_i or F2_i or F3_i or F4_i or SEL_i)
begin
	case (SEL_i)
		2'b00: F_o <= F1_i;
			
		2'b01: F_o <= F2_i;
			
		2'b10: F_o <= F3_i;
			
		2'b11: F_o <= F4_i;
	endcase
end
	

endmodule
