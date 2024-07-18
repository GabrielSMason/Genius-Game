module mux4x1
(
	F1_i,
	F2_i,
	F3_i,
	F4_i,
	SEL_i,
	F_o
);

localparam SEL = 2;

input wire F1_i;
input wire F2_i;
input wire F3_i;
input wire F4_i;
input wire [SEL-1:0]SEL_i;
output reg F_o;
	
always @(F1_i or F2_i or F3_i or F4_i or SEL_i)
begin
	case (SEL_i)
		2'b00: begin
			F_o <= F1_i;
		end	
		2'b01: begin
			F_o <= F2_i;
		end	
		2'b10: begin
			F_o <= F3_i;
		end	
		2'b11: begin
			F_o <= F4_i;
		end
	endcase
end
	

endmodule
