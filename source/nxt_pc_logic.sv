// memory types
`include "cpu_types_pkg.vh"
`include "pc_if.vh"

import cpu_types_pkg::*;

module nxt_pc (
  input logic CLK, nRST, 
  pc_if.pc pcif
);

assign j_addr = {pc[31:28], j_offset, 2'b00};
assign b_addr = (pc + 4) + b_offset;

