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
assign nxt_pc_if.PCSrc = msif.in.PCSrc;
assign nxt_pc_if.j_addr = msif.in.j_addr;
assign nxt_pc_if.b_addr = msif.in.b_addr;
assign nxt_pc_if.jr_addr = msif.in.rdat1;
assign nxt_pc_if.zero = msif.in.zero;

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
