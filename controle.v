/*
	controle.v
	Gabriel Sacavem Mason
	28/05/2024
*/
module controle
(
	clock_50,
	enter,
	reset,
	end_fpga,
	end_user,
	end_time,
	win,
	match,
	r1,
	r2,
	e1,
	e2,
	e3,
	e4,
	sel
);

input wire clock_50,enter,reset,end_fpga,end_user,end_time,win,match;
output reg r1,r2,e1,e2,e3,e4,sel;

reg [2:0] EA, PE;
localparam[2:0]INIT = 3'b000,
					SETUP = 3'b001,
					PLAY_FPGA = 3'b010,
					PLAY_USER = 3'b011,
					CHECK = 3'b100,
					NEXT_ROUND = 3'b101,
					RESULT = 3'b110;

always @(posedge clock_50 or posedge reset) begin
	if (reset) begin
		EA <= INIT;
	end else begin
		EA <= PE;
	end
end
 
always @(EA or enter or end_fpga or end_user or end_time or win or match) begin
	case (EA)
		INIT: begin
         PE = SETUP;
      end
		SETUP: begin
         if (enter == 1'b1) PE = PLAY_FPGA;
         else PE = SETUP;
      end
		PLAY_FPGA: begin
			if (end_fpga == 1'b1) PE = PLAY_USER;
			else PE = PLAY_FPGA;
      end
      PLAY_USER: begin
			if (end_user == 1'b1) PE = CHECK;	
         else if (end_time == 1'b1) PE = RESULT;
			else PE = PLAY_USER;
      end
		CHECK: begin
         if (match == 1'b1) PE = NEXT_ROUND;
         else PE = RESULT;
		end
      NEXT_ROUND: begin
			if (win == 1'b1) PE = RESULT;
         else PE = PLAY_FPGA;
      end
      RESULT: begin
			PE = RESULT;
      end
      default: PE = INIT;
	endcase
end
	 
always @(EA) begin
	r1 = 0; r2 = 0; e1 = 0; e2 = 0; e3 = 0; e4 = 0; sel = 0;
		case (EA)
			INIT: begin
            r1 = 1;
				r2 = 1;
         end
         SETUP: begin
            e1 = 1;
         end
			PLAY_FPGA: begin
            e3 = 1;
         end
         PLAY_USER: begin
            e2 = 1;
         end
			CHECK: begin
            e4 = 1;
         end
         NEXT_ROUND: begin
            r2 = 1;
         end
         RESULT: begin
            sel = 1;
         end
       endcase
    end
endmodule
