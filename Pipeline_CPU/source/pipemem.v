module pipemem(
	resetn,mwmem,malu,mb,clock,mem_clock,mmo,
	real_in_port0,real_in_port1, real_out_port0, real_out_port1, real_out_port2
);
	input resetn, mwmem, clock, mem_clock;
	input [31:0] malu, mb;
	input [31:0] real_in_port0, real_in_port1;
	output [31:0] mmo, real_out_port0, real_out_port1, real_out_port2;
	wire   [31:0] mem_dataout, io_read_data;
	sc_datamem dmem(malu, mb, mmo, mwmem, mem_clock, resetn, 
		real_out_port0, real_out_port1, real_out_port2, real_in_port0, real_in_port1,
		mem_dataout, io_read_data);
	
endmodule 