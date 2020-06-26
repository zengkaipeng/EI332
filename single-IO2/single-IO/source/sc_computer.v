module sc_computer(
	clk, reset, SW0,SW1,SW2,SW3,SW4,SW5,SW6,SW7,SW8,SW9, HEX0,HEX1,HEX2,HEX3,HEX4,HEX5,
	pc,instruction,aluout,memout,imem_clk,dmem_clk
);
	input clk, reset, SW0, SW1, SW2, SW3, SW4, SW5, SW6, SW7, SW8, SW9;
	output imem_clk, dmem_clk;
	output[31:0] aluout, memout, pc, instruction;
	output wire [6:0]  HEX0, HEX1, HEX2, HEX3, HEX4, HEX5;
	wire         cpu_clock;
	wire  [31:0] in_port0, in_port1;
	wire  [31:0] out_port0, out_port1, out_port2;
	
	clock_and_mem_clock inst(clk, cpu_clock);
	in_port inst1(SW5, SW6, SW7, SW8, SW9, in_port0);
	in_port inst2(SW0, SW1, SW2, SW3, SW4, in_port1);
	sc_computer_main inst4(reset,cpu_clock,clk,pc,instruction,aluout,memout,imem_clk,dmem_clk,
									in_port0,in_port1,out_port0,out_port1,out_port2);
	
	out_port_seg inst5(out_port0, HEX1, HEX0);
	out_port_seg inst6(out_port1, HEX3, HEX2);
	out_port_seg inst7(out_port2, HEX5, HEX4);
	
endmodule
