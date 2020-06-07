module sc_instmem(addr, inst, mem_clk);
   input  [31:0] addr;
   input         mem_clk;
   output [31:0] inst;   
   lpm_rom_irom irom (addr[7:2],mem_clk,inst); 
endmodule 