module counter_time
(
	clk_i,
	r_i,
	e_i,
	tempo_o,
	end_time
);

localparam N = 4;

input wire clk_i, r_i, e_i;
output reg [N-1:0] tempo_o;
output reg end_time;

always @(posedge clk_i or posedge r_i)
begin
	if(r_i == 1'b1) tempo_o <= 4'b0000;
	else
 begin
	if(e_i == 1'b1) begin
		if(tempo_o == 4'b1001) begin
			tempo_o <= 4'b0000;
			end_time <= 1'b1; 
		end
		else begin
			tempo_o <= tempo_o + 1'b1;
			end_time <= 1'b0;
		end
	end
 end 
end

endmodule