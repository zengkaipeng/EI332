/////////////////////////////////////////////////////////////
//                                                         //
// School of Software of SJTU                              //
//                                                         //
/////////////////////////////////////////////////////////////

module sc_computer_main(
	resetn,clock,mem_clk,pc,Instruction,aluout,memout,imem_clk,dmem_clk,
	in_port0,in_port1,out_port0,out_port1,out_port2
);
   
   input resetn,clock,mem_clk;
   output [31:0] pc,Instruction,aluout,memout;
	output [31:0] out_port0,out_port1,out_port2;
	input  [31:0] in_port0,in_port1;
   output        imem_clk,dmem_clk;
   wire   [31:0] data;
   wire          wmem; // all these "wire"s are used to connect or interface the cpu,dmem,imem and so on.
	wire   [31:0] mem_dataout, io_read_data;
	
   sc_cpu cpu (clock,resetn,Instruction,memout,pc,wmem,aluout,data);          // CPU module.
   sc_instmem  imem (pc,Instruction,clock,mem_clk,imem_clk);                  // instruction memory.
   sc_datamem  dmem (aluout,data,memout,wmem,clock,mem_clk,dmem_clk,
	                  out_port0, out_port1, out_port2, in_port0, in_port1, mem_dataout, io_read_data); // data memory.

endmodule



