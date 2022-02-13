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

pc_if pcif();
pc PC(CLK, nRST, pcif);

assign fsif.out.pc = pcif.iaddr;
assign fsif.out.instr = fsif.instr;

assign pcif.pc_en = fsif.ihit;
assign pcif.pc_control = fsif.pc_control;
assign pcif.nxt_pc = fsif.nxt_pc;



endmodule
