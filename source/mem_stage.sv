// interface include
`include "nxt_pc_if.vh"
`include "mem_stage_if.vh"

// memory types
`include "cpu_types_pkg.vh"

module mem_stage (
  mem_stage_if.ms msif
);

import cpu_types_pkg::*;

nxt_pc_if npcif ();

nxt_pc NXT_PC(npcif);

// NXT PC Inputs
assign npcif.PCSrc = msif.in.PCSrc;
assign npcif.j_addr = msif.in.j_addr;
assign npcif.b_addr = msif.in.b_addr;
assign npcif.jr_addr = msif.in.rdat1;
assign npcif.zero = msif.in.zero;

//NXT PC Outputs
assign msif.nxt_pc = npcif.nxt_pc;
assign msif.pc_control = npcif.pc_control;

// MEM LATCH OUTPUTS
assign msif.out.halt = msif.in.halt;
assign msif.out.wsel = msif.in.wsel;
assign msif.out.RegWr = msif.in.RegWr;
assign msif.out.MemToReg = msif.in.MemToReg;
assign msif.out.WrLinkReg = msif.in.WrLinkReg;
assign msif.out.aluOut = msif.in.aluOut;
assign msif.out.pc = msif.in.pc;
assign msif.out.dmemload = msif.dmemload;

// MEM STAGE OUTPUTS TO CACHE
assign msif.dcache_store = msif.in.rdat2;
assign msif.dcache_dWEN = msif.in.MemWr;
assign msif.dcache_dREN = msif.in.MemRd;
assign msif.dcache_daddr = msif.in.aluOut;

endmodule
