module mux2x1

(
	a_i,
	b_i,
	sel_i,
	saida_o
);

localparam N = 7;

input wire [N-1:0]a_i;
input wire [N-1:0]b_i;
input wire sel_i;
output reg [N-1:0]saida_o;

always @(a_i or b_i or sel_i)begin
	if(sel_i == 1)
		saida_o <= a_i;
	else
		saida_o <= b_i;
	
end

endmodule
