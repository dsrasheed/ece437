// interface include
`include "fetch_stage_if.vh"

// memory types
`include "cpu_types_pkg.vh"

module fetch_stage (
  input CLK, nRST,
  fetch_stage.es fif
);

import cpu_types_pkg::*;

assign fif.pc = pcif.iaddr;

assign pcif.pc_en = fif.ihit;
assign pcif.pc_control = fif.pc_control;
assign pcif.nxt_pc = fif.nxt_pc;



endmodule
