module out_port_seg(portnum, ten, one);
	input [31:0] portnum;
	output [6:0] ten, one;
	assign ten = portnum / 10;
	assign one = portnum % 10;
endmodule 