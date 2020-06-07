module sc_cu (
	op, func, z, wmem, wreg, regrt, m2reg, aluc, shift,
	aluimm, pcsource, jal, sext, forwarda, forwardb, wpcir,
	rs, rt, mrn, mm2reg, mwreg, ern, em2reg, ewreg, ebubble
);
	input mwreg, ewreg, mm2reg, em2reg, ebubble;
	input  [4:0] rs, rt, mrn, ern;
   input  [5:0] op,func;
   input        z;
   output       wreg,regrt,jal,m2reg,shift,aluimm,sext,wmem, wpcir;
   output [3:0] aluc;
   output [1:0] pcsource, forwarda, forwardb;
	reg [1:0] forwarda, forwardb;
	
   wire r_type = ~|op;
   wire i_add = r_type & func[5] & ~func[4] & ~func[3] &
                ~func[2] & ~func[1] & ~func[0];          //100000
   wire i_sub = r_type & func[5] & ~func[4] & ~func[3] &
                ~func[2] &  func[1] & ~func[0];          //100010
      
   //  please complete the deleted code.
   
   wire i_and = r_type & func[5] & ~func[4] & ~func[3] &
					 func[2] & ~func[1] & ~func[0]; //100100
   wire i_or  = r_type & func[5] & ~func[4] & ~func[3] &
					 func[2] & ~func[1] & func[0]; //100101

   wire i_xor = r_type & func[5] & ~func[4] & ~func[3] &
					 func[2] & func[1] & ~func[0]; //100110
   wire i_sll = r_type & ~func[5] & ~func[4] & ~func[3] &
					 ~func[2] & ~func[1] & ~func[0]; //000000
   wire i_srl = r_type & ~func[5] & ~func[4] & ~func[3] &
					 ~func[2] & func[1] & ~func[0]; //000010
   wire i_sra = r_type & ~func[5] & ~func[4] & ~func[3] &
					 ~func[2] & func[1] & func[0]; //000011
   wire i_jr  = r_type & ~func[5] & ~func[4] & func[3] &
					 ~func[2] & ~func[1] & ~func[0]; //001000
                
   wire i_addi = ~op[5] & ~op[4] &  op[3] & ~op[2] & ~op[1] & ~op[0]; //001000
   wire i_andi = ~op[5] & ~op[4] &  op[3] &  op[2] & ~op[1] & ~op[0]; //001100
   
   wire i_ori  = ~op[5] & ~op[4] &  op[3] &  op[2] & ~op[1] &  op[0]; //001101        // complete by yourself.
   wire i_xori = ~op[5] & ~op[4] &  op[3] &  op[2] &  op[1] & ~op[0]; //001110  
   wire i_lw   =  op[5] & ~op[4] & ~op[3] & ~op[2] &  op[1] &  op[0]; //100011  
   wire i_sw   = 	op[5] & ~op[4] &  op[3] & ~op[2] &  op[1] &  op[0]; //101011
   wire i_beq  = ~op[5] & ~op[4] & ~op[3] &  op[2] & ~op[1] & ~op[0]; //000100
   wire i_bne  = ~op[5] & ~op[4] & ~op[3] &  op[2] & ~op[1] &  op[0]; //000101
   wire i_lui  = ~op[5] & ~op[4] &  op[3] &  op[2] &  op[1] &  op[0]; //001111
   wire i_j    = ~op[5] & ~op[4] & ~op[3] & ~op[2] &  op[1] & ~op[0]; //000010
   wire i_jal  = ~op[5] & ~op[4] & ~op[3] & ~op[2] &  op[1] &  op[0]; //000011
   
	assign wpcir = ~(em2reg & ( ern == rs | ern == rt ));
	wire ctrlable = wpcir & ~ebubble;
	
   assign pcsource[1] = i_jr | i_j | i_jal;
   assign pcsource[0] = ( i_beq & z ) | (i_bne & ~z) | i_j | i_jal ;
   
   assign wreg = ctrlable &( i_add | i_sub | i_and  | i_or   | i_xor  |
							i_sll | i_srl | i_sra | i_addi | i_andi |
							i_ori | i_xori | i_lw | i_lui  | i_jal );
   
   assign aluc[3] = ctrlable & i_sra ;    // complete by yourself.
   assign aluc[2] = ctrlable &( i_sub | i_beq  | i_bne | i_or  | i_ori | i_lui | i_srl | i_sra );
   assign aluc[1] = ctrlable &( i_xor | i_xori | i_lui | i_sll | i_srl | i_sra );
   assign aluc[0] = ctrlable &( i_and | i_andi | i_or  | i_ori | i_sll | i_srl | i_sra );
   assign shift   = ctrlable &( i_sll | i_srl  | i_sra );

   assign aluimm  = ctrlable &( i_addi | i_andi | i_ori | i_xori | i_lw | i_sw | i_lui);     // complete by yourself.
   assign sext    = ctrlable &( i_addi | i_lw | i_sw | i_beq | i_bne);
   assign wmem    = ctrlable & i_sw;
   assign m2reg   = ctrlable & i_lw;
   assign regrt   = ctrlable &(i_addi | i_andi | i_ori | i_xori | i_lw | i_lui);
   assign jal     = ctrlable & i_jal;
	
	always @(*)
	begin
		if (ewreg & ~ em2reg & (ern != 0) & (ern == rs) )  
				forwarda <= 2'b01; //exe_alu
      else 
		if (mwreg & ~ mm2reg & (mrn != 0) & (mrn == rs) ) 
            forwarda <= 2'b10; //mem_alu
      else  
      if (mwreg & mm2reg & (mrn != 0) & (mrn == rs) )  
				forwarda <= 2'b11; // mem_lw
      else 
            forwarda <= 2'b00;  
	end
	
	always@(*)
	begin
		if (ewreg & ~ em2reg &(ern != 0) & (ern == rt) ) 
			forwardb <= 2'b01;
      else  
      if (mwreg & ~ mm2reg & (mrn != 0) & (mrn == rt) )  
			forwardb <= 2'b10;
      else 
		if (mwreg & mm2reg & (mrn != 0) & (mrn == rt) )   
         forwardb <= 2'b11;
      else 
         forwardb <= 2'b00; // 无需直通 
	end
endmodule 