module fsm_clock
(
	clk_i,
	r_i,
	c025_o,
	c05_o,
	c1_o,
	c2_o
);
localparam integer DIV_025 = 199_999_999;
localparam integer DIV_05 = 99_999_999;
localparam integer DIV_1 = 49_999_999;
localparam integer DIV_2 = 24_999_999;

input wire clk_i,r_i;
output reg c025_o,c05_o,c1_o,c2_o;

reg [31:0]contador_025=0;
reg [31:0]contador_05=0;
reg [31:0]contador_1=0;
reg [31:0]contador_2=0;

always @(posedge clk_i or posedge r_i)begin
	if(r_i == 1'b1)begin
		contador_025 <=0;
		contador_05  <=0;
		contador_1 	 <=0;
		contador_2	 <=0;
		
		c025_o		 <=0; 
		c05_o			 <=0;
		c1_o         <=0;
		c2_o         <=0;
	end
	else begin
		contador_025 <= contador_025 + 1;
		contador_05 <= contador_05 + 1;
		contador_1 <= contador_1 + 1;	
		contador_2 <= contador_2 + 1;
				
		if(DIV_025 == contador_025)begin
				contador_025 <= 0;
				c025_o <= ~c025_o;
		end 
		
		if(DIV_05 == contador_05)begin
				contador_05 <= 0;
				c05_o <= ~c05_o;
		end 
		
		if(DIV_1 == contador_1)begin
				contador_1 <= 0;
				c1_o <= ~c1_o;
		end 
		
		if(DIV_2 == contador_2)begin
				contador_2 <= 0;
				c2_o <= ~c2_o;
		end 
	end
end

endmodule

