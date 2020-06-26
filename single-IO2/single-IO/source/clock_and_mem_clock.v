module clock_and_mem_clock(clk, clock_out);
	input clk;
	output clock_out;
	reg clock_out;
	
	initial
	begin 
		clock_out = 0;
	end

	always @(posedge clk)
	begin
		clock_out = ~clock_out;
	end
endmodule
