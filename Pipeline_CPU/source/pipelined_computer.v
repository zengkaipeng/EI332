/////////////////////////////////////////////////////////////
//                                                         //
// School of Software of SJTU                              //
//                                                         //
/////////////////////////////////////////////////////////////

module pipelined_computer (resetn,clock,mem_clock,opc,oinst,oins,oealu,omalu,owalu,onpc,/*da,db,
							pcsource*/,in_port0,in_port1,out_port0,out_port1,out_port2,out_port3 
									);
   // ���嶥��ģ��pipelined_computer����Ϊ�����ļ��Ķ������ڡ�
   input resetn,clock/*,mem_clock*/;
   // ��������������module�����罻���������źţ������λ�ź�resetn��ʱ���ź�clock ��
   // �Լ�һ����clockͬƵ�ʵ�������mem_clock�źš�mem_clock����ָ��ͬ��ROM��
   // ����ͬ��RAMʹ�ã��䲨����Ҫ�б���ʵ��һ��
   // ��Щ�źſ�������������֤ʱ�������۲��ź� ��
   input  [5:0] in_port0,in_port1;
   output [31:0] out_port0,out_port1,out_port2,out_port3;// output [6:0] out_port0,out_port1,out_port2,out_port3;
   
   wire [31:0] real_out_port0,real_out_port1,real_out_port2,real_out_port3;
   
   wire [31:0] real_in_port0 = {26'b00000000000000000000000000,in_port0};
   wire [31:0] real_in_port1 = {26'b00000000000000000000000000,in_port1};
   
   assign out_port0 = real_out_port0[31:0];//assign out_port0 = real_out_port0[6:0];
   assign out_port1 = real_out_port1[31:0];//assign out_port0 = real_out_port1[6:0];
   assign out_port2 = real_out_port2[31:0];//assign out_port0 = real_out_port2[6:0];
   assign out_port3 = real_out_port3[31:0];//assign out_port0 = real_out_port3[6:0];
   
   output mem_clock;
   
   assign mem_clock = ~clock;
   
   wire [31:0] pc,ealu,malu,walu;
	output [31:0] opc,oealu,omalu,owalu;// for watch
	assign opc = pc;
	assign oealu = ealu;
	assign omalu = malu ;
	assign owalu = walu ;
	
   // ģ�����ڷ��������Ĺ۲��źš�ȱʡΪwire�͡�
   wire   [31:0] bpc,jpc,pc4,npc,ins,inst;
   output [31:0] onpc,oins,oinst;// for watch
	assign  onpc=npc;
	assign  oins=ins;
	assign  oinst=inst;
	
	// for test
	
	
   // ģ���以��������ݻ�������Ϣ�ĺ���,��Ϊ 32 λ���ź� ��IFȡָ���׶�
   wire   [31:0] dpc4,da,db,dimm,dsa;
   // ģ���以 ����� ���ݻ����� ��Ϣ�ĺ��� ,��Ϊ 32 λ���ź� ��ID ָ�������׶Ρ�
   wire   [31:0] epc4,ea,eb,eimm,esa;
   //ģ���以��������ݻ����� ��Ϣ�ĺ��� ,��Ϊ 32 λ���ź� ��EXE ָ�������׶Ρ�
   wire   [31:0] mb,mmo;
   //ģ���以����� ���ݻ����� ��Ϣ�ĺ��� ,��Ϊ 32 λ���ź� ��MEMMEM �������ݽ׶�
   wire   [31:0] wmo,wdi;
   // ģ���以����� ���ݻ����� ��Ϣ�ĺ��� ,��Ϊ 32 λ���ź� ��WB ��д�Ĵ����׶Ρ�
   wire   [4:0] ern0,ern,drn,mrn,wrn;
   // ģ���以���ͨ����ˮ�߼Ĵ���ݽ����Ĵ����ŵ��ź��ߣ��Ĵ����ţ� 32 ����Ϊ 5bit��
   wire   [4:0] drs,drt,ers,ert;
   // 
   wire   [3:0] daluc,ealuc;
   //ID �׶���EXE�׶�ͨ����ˮ�߼Ĵ���ݵ�aluc�����źţ�4bit��
   wire   [1:0] pcsource;
   //CU ģ���� IF �׶�ģ�鴫�ݵ� PC ѡ���źţ�2bit��
   wire         wpcir;
   // CU ģ�鷢���Ŀ�����ˮ��ͣ���źţ�ʹ PC ��IF/ID ��ˮ�߼Ĵ���ֲ��䡣
   wire         dwreg,dm2reg,dwmem,daluimm,dshift,djal;  //id stage
   // ID �׶� ����������������ˮ���������źš�
   wire         ewreg,em2reg,ewmem,ealuimm,eshift,ejal;  //exe stage
   //����� ID/EXE ��ˮ�߼Ĵ����� EXE �׶�ʹ�ã�����Ҫ��������ˮ���������źš�
   wire         mwreg,mm2reg,mwmem;  //mem stage
   //����� EXE/MEM ��ˮ�� �Ĵ����� MEM �׶�ʹ�ã�����Ҫ��������ˮ���������źš�
   wire         wwreg,wm2reg;  //wb stage
   //�����MEM/WB ��ˮ�߼Ĵ����� WB �׶�ʹ�õ��źš�
   wire         dbubble, ebubble;
   
	
	//fortest
	
   pipepc prog_cnt ( npc,wpcir,clock,resetn,pc );
	
	pipeif if_stage ( pcsource,pc,bpc,da,jpc,npc,pc4,ins,mem_clock ); // IF stage
	
	pipeir inst_reg ( pc4,ins,wpcir,clock,resetn,dpc4,inst ); // IF/ID流水线寄存器
	
	pipeid id_stage ( mwreg,mrn,ern,ewreg,em2reg,mm2reg,dpc4,inst,
	wrn,wdi,ealu,malu,mmo,wwreg,mem_clock,resetn,
	bpc,jpc,pcsource,wpcir,dwreg,dm2reg,dwmem,daluc,
	daluimm,da,db,dimm,drn,dshift,djal,dbubble, ebubble, dsa); // ID stage
	
	/*
	pipedereg de_reg ( dwreg,dm2reg,dwmem,daluc,daluimm,da,db,dimm,drn,dshift,djal,dpc4,clock,resetn, drs, drt, dbubble,
		ewreg,em2reg,ewmem,ealuc,ealuimm, ea,eb,eimm,ern0,eshift,ejal,epc4, ers, ert, ebubble ); // ID/EXE流水线寄存器
	*/
	pipedereg de_reg (dbubble,drs,drt,dwreg,dm2reg,dwmem,daluc,daluimm,da,db,dimm,dsa,drn,dshift,djal,dpc4,clock,resetn,
					ebubble,ers,ert,ewreg,em2reg,ewmem,ealuc,ealuimm,ea,eb,eimm,esa,ern0,eshift,ejal,epc4);
					
	pipeexe exe_stage ( ealuc,ealuimm,ea,eb,eimm, esa, eshift,ern0,epc4,ejal,ern,ealu); // EXE stage
	
	pipeemreg em_reg ( ewreg,em2reg,ewmem,ealu,eb,ern,clock,resetn, mwreg,mm2reg,mwmem,malu,mb,mrn);
	
	pipemem mem_stage ( resetn,mwmem,malu,mb,clock,mem_clock,mmo,
			real_in_port0,real_in_port1, real_out_port0, real_out_port1, real_out_port2); // MEM stage
	
	pipemwreg mw_reg ( mwreg,mm2reg,mmo,malu,mrn,clock,resetn,wwreg,wm2reg,wmo,walu,wrn); // MEM/WB流水线寄存器
	
	mux2x32 wb_stage ( walu,wmo,wm2reg,wdi ); // WB stage
	
endmodule
