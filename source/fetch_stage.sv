// interface include
`include "fetch_stage_if.vh"
`include "pc_if.vh"
//`include "pc.sv"

// memory types
`include "cpu_types_pkg.vh"

module fetch_stage (
  input CLK, nRST,
  fetch_stage_if.fs fsif
);

import cpu_types_pkg::*;

cpu_tracker_t track;

pc_if pcif();
pc PC(CLK, nRST, pcif);

assign track.pc = pcif.iaddr;
assign track.daddr = '0;
assign track.dstore = '0;
assign track.nxt_pc = '0;
assign track.instr = '0;
assign track.opcode = RTYPE;
assign track.funct = SLLV;
assign track.rs = '0;
assign track.rt = '0;
assign track.wsel = '0;
assign track.RegWr = 0;
assign track.WrLinkReg = 0;
assign track.lui = '0;
assign track.shamt = '0;
assign track.imm = '0;
assign track.branch = '0;
assign track.writeback = '0;

assign fsif.track_out = track;

assign fsif.out.pc = pcif.iaddr;
assign fsif.out.instr = fsif.instr;

assign pcif.pc_en = fsif.ihit;
assign pcif.pc_control = fsif.pc_control;
assign pcif.nxt_pc = fsif.nxt_pc;



endmodule
