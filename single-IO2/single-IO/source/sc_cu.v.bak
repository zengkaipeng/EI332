module sc_cu (op, func, z, wmem, wreg, regrt, m2reg, aluc, shift,
              aluimm, pcsource, jal, sext);
   input  [5:0] op,func;
   input        z;
   output       wreg,regrt,jal,m2reg,shift,aluimm,sext,wmem;
   output [3:0] aluc;
   output [1:0] pcsource;
   wire r_type = ~|op;
   wire i_add = r_type & func[5] & ~func[4] & ~func[3] &
                ~func[2] & ~func[1] & ~func[0];          //100000
   wire i_sub = r_type & func[5] & ~func[4] & ~func[3] &
                ~func[2] &  func[1] & ~func[0];          //100010
      
   //  please complete the deleted code.
   
   wire i_and = 
   wire i_or  = 

   wire i_xor = 
   wire i_sll = 
   wire i_srl = 
   wire i_sra = 
   wire i_jr  = 
                
   wire i_addi = ~op[5] & ~op[4] &  op[3] & ~op[2] & ~op[1] & ~op[0]; //001000
   wire i_andi = ~op[5] & ~op[4] &  op[3] &  op[2] & ~op[1] & ~op[0]; //001100
   
   wire i_ori  =         // complete by yourself.
   wire i_xori =   
   wire i_lw   =   
   wire i_sw   = 
   wire i_beq  = 
   wire i_bne  = 
   wire i_lui  = 
   wire i_j    = 
   wire i_jal  = 
   
  
   assign pcsource[1] = i_jr | i_j | i_jal;
   assign pcsource[0] = ( i_beq & z ) | (i_bne & ~z) | i_j | i_jal ;
   
   assign wreg = i_add | i_sub | i_and | i_or   | i_xor  |
                 i_sll | i_srl | i_sra | i_addi | i_andi |
                 i_ori | i_xori | i_lw | i_lui  | i_jal;
   
   assign aluc[3] =      // complete by yourself.
   assign aluc[2] = 
   assign aluc[1] = 
   assign aluc[0] = 
   assign shift   = i_sll | i_srl | i_sra ;

   assign aluimm  =      // complete by yourself.
   assign sext    = 
   assign wmem    = 
   assign m2reg   = 
   assign regrt   = 
   assign jal     = 

endmodule