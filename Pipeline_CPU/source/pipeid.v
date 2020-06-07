module pipeid(
	mwreg,mrn,ern,ewreg,em2reg,mm2reg,dpc4,inst,
	wrn,wdi,ealu,malu,mmo,wwreg, clock,resetn,
	bpc,jpc,pcsource,wpcir,dwreg,dm2reg,dwmem,daluc,
	daluimm,da,db,dimm,drn,dshift,djal,dbubble, ebubble, dsa
);
	input  [ 4:0] mrn, ern, wrn;
	input         ewreg, mwreg, wwreg, mm2reg, em2reg, clock, resetn, ebubble;
	input  [31:0] inst, wdi, ealu, malu, mmo, dpc4;
	output [31:0] jpc, bpc, da, db, dimm, dsa;
	output [ 1:0] pcsource;
	output        wpcir, dwreg, dm2reg, dbubble, dwmem, daluimm, dshift, djal;
	output [ 3:0] daluc;
	output [ 4:0] drn;
	
	wire [31:0] q1, q2, da, db;
	wire [ 1:0] forwarda, forwardb;
	wire        z = (da == db);
	wire        regrt, sext;
	wire        e = sext & inst[15];
	wire [15:0] imm = {16{e}};                // high 16 sign bit
   wire [31:0] dimm = {imm,inst[15:0]};
	wire [31:0] dsa = { 27'b0, inst[10:6] }; // extend to 32 bits from sa for shift instruction
   wire [31:0] offset = {imm[13:0],inst[15:0],1'b0,1'b0};
	wire [31:0] bpc = dpc4 + offset;
	wire [31:0] jpc = {dpc4[31:28],inst[25:0],1'b0,1'b0};
	wire dbubble = (pcsource[1:0] != 2'b00);
	
	regfile rf( inst[25:21], inst[20:16], wdi, wrn, wwreg, clock, resetn, q1, q2 );
	mux4x32 muxda(q1, ealu, malu, mmo, forwarda, da);
	mux4x32 muxdb(q2, ealu, malu, mmo, forwardb, db);
	mux2x5  muxrn(inst[15:11], inst[20:16], regrt, drn);
	sc_cu cu_inst(inst[31:26], inst[5:0], z, dwmem, dwreg, regrt, dm2reg, daluc, dshift,
			daluimm, pcsource, djal, sext, forwarda, forwardb, wpcir,
			inst[25:21], inst[20:16], mrn, mm2reg, mwreg, ern, em2reg, ewreg, ebubble);
	
	
endmodule 