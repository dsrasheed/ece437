// interface include
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
assign nxt_pc_if.b_addr = msif.in.jr_addr;
assign nxt_pc_if.


endmodule
