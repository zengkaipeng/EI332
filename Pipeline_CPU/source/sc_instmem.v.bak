module sc_instmem (addr,inst,clock,mem_clk,imem_clk);
   input  [31:0] addr;
   input         clock;
   input         mem_clk;
   output [31:0] inst;
   output        imem_clk;
   
   wire          imem_clk;

   assign  imem_clk = clock & ( ~ mem_clk );      
   
   lpm_rom_irom irom (addr[7:2],imem_clk,inst); 
   

endmodule 