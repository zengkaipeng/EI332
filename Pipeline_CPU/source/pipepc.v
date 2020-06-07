module pipepc(newpc, wpcir, clock, resetn, pc);
	input [31:0] newpc;
	input resetn, wpcir, clock;
	output reg [31:0] pc;
	always @(posedge clock or negedge resetn)
	begin
		if(resetn == 0)
		begin
			pc <= -4;
		end
		else
			if(wpcir != 0)
			begin
				pc <= newpc;
			end
	end
endmodule 