module in_port(a0, a1, a2, a3, a4, out);
	input a0, a1, a2, a3, a4;
	output[31:0] out;
	assign out = {27'b0, a4, a3, a2, a1, a0};
endmodule
