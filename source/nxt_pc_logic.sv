// memory types
`include "cpu_types_pkg.vh"
`include "npcl_if.vh"

import cpu_types_pkg::*;

module nxt_pc (
  input logic CLK, nRST, 
  npcl_if.pc npclif
);

assign npclif.j_addr = {pc[31:28], npclif.j_offset, 2'b00};
assign npclif.b_addr = (pc + 4) + npclif.b_offset;

endmodule
