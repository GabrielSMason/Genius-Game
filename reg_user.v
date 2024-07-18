module reg_user
(
	clk_i,
	r_i,
	e_i,
	data_i,
	q_o
);

localparam N = 64;

input clk_i,r_i,e_i;
input [N-1:0]data_i;
output reg [N-1:0]q_o;

always@(posedge clk_i or posedge r_i)begin
	if(r_i) begin
		q_o <= 64'b0;
	end 
	else if (e_i) begin
		q_o <= data_i;
end
end

endmodule
