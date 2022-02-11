// interface include
`include "fetch_stage_if.vh"

// memory types
`include "cpu_types_pkg.vh"

module fetch_stage (
  input CLK, nRST,
  fetch_stage.fs fif
);

import cpu_types_pkg::*;

pc_if pcif();
pc PC(CLK, nRST, pcif);

assign fif.pc = pcif.iaddr;

assign pcif.pc_en = fif.ihit;
assign pcif.pc_control = fif.pc_control;
assign pcif.nxt_pc = fif.nxt_pc;



endmodule
