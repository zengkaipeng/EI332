module pipeexe( ealuc,ealuimm,ea,eb,eimm, esa, eshift,ern0,epc4,ejal,ern,ealu);
	input [3:0] ealuc;
	input [31:0] ea, eb, eimm, esa, epc4;
	input [4:0] ern0;
	input ealuimm, eshift, ejal;
	output [4:0] ern;
	output [31:0] ealu;
	wire  [31:0] alua, alub, alures;
	wire  [31:0] epc8 = epc4 + 4;
	wire  [4:0] ern = ern0 | {5{ejal}};
	wire  iszero;
	
	mux2x32 a_mux(ea, esa, eshift, alua);
	mux2x32 b_mux(eb, eimm, ealuimm, alub);
	alu alu_inst(alua, alub, ealuc, alures, iszero);
	//mux2x32 res_mux(alures, epc8, ejal, ealu);
	mux2x32 res_mux(alures, epc4, ejal, ealu);
endmodule 