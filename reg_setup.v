module reg_setup
(
	sw_i,
	r_i,
	e_i,
	clk_i,
	setup_o
);
localparam N = 8;

input clk_i,r_i,e_i;
input [N-1:0]sw_i;
output reg [N-1:0]setup_o;

always@(posedge clk_i or posedge r_i) begin 
	if(r_i) begin
		setup_o <= 8'b0000000;
	end 
	else if (e_i) begin
		setup_o <= sw_i;
	end

end 
	
endmodule
