// memory types
`include "cpu_types_pkg.vh"
`include "nxt_pc_logic_if.vh"

import cpu_types_pkg::*;

module nxt_pc_logic (
  npcl_if.npcl npclif
);

assign npclif.j_addr = {npclif.pc[31:28], npclif.j_offset, 2'b00};
assign npclif.b_addr = (npclif.pc + 4) + npclif.b_offset;

endmodule