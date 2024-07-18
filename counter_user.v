module counter_user
(
	clk_i,
	r_i,
	e_i,
	data_i,
	tc_o
);

localparam N = 4;

input wire clk_i,r_i,e_i;
input wire [N-1:0]data_i;	
output reg tc_o;
reg [N-1:0] total;

always@(posedge clk_i or posedge r_i)begin
	if (r_i) begin
		total <= 4'b0000;
		tc_o <= 0;
	end
	else if (e_i) begin
		if (total == data_i) begin
			tc_o <= 1;
			total <= 4'b0000;
		end
		else begin
			total <= total + 1;
			tc_o <= 0;
		end
	end
end

endmodule
