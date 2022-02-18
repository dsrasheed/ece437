// interface include
`include "nxt_pc_if.vh"
`include "mem_stage_if.vh"

module mem_stage (
  mem_stage_if.ms msif
);

nxt_pc_if npcif ();

nxt_pc NXT_PC(npcif);

// Track
assign msif.track_out.daddr = msif.in.aluOut;
assign msif.track_out.dstore = msif.in.rdat2;
assign msif.track_out.nxt_pc = (npcif.pc_control) ? npcif.nxt_pc : msif.track_in.pc + 4;
assign msif.track_out.pc = msif.track_in.pc;
assign msif.track_out.instr = msif.track_in.instr;
assign msif.track_out.opcode = msif.track_in.opcode;
assign msif.track_out.funct = msif.track_in.funct;
assign msif.track_out.rs = msif.track_in.rs;
assign msif.track_out.rt = msif.track_in.rt;
assign msif.track_out.wsel = msif.track_in.wsel;
assign msif.track_out.RegWr = msif.track_in.RegWr;
assign msif.track_out.WrLinkReg = msif.track_in.WrLinkReg;
assign msif.track_out.lui = msif.track_in.lui;
assign msif.track_out.shamt = msif.track_in.shamt;
assign msif.track_out.imm = msif.track_in.imm;
assign msif.track_out.branch = msif.track_in.branch;
assign msif.track_out.writeback = msif.track_in.writeback;


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
