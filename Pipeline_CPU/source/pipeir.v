module pipeir(pc4,ins,wpcir,clock,resetn, dpc4,inst);
	input [31:0] pc4, ins;
	input wpcir, clock, resetn;
	output reg [31:0] dpc4, inst;
	
	always @(posedge clock or negedge resetn)
	begin
		if(resetn == 0)
		begin
			inst <= 0;
			dpc4 <= 0;
		end
		else
			if(wpcir != 0)
			begin
				inst <= ins;
				dpc4 <= pc4;
			end
	end
endmodule 