`ifndef NPCL_IF_VH
`define NPCL_IF_VH

// typedefs
`include "cpu_types_pkg.vh"

interface npcl_if;
  // import types
  import cpu_types_pkg::*;

  logic [ADDR_W-1:0] j_offset;
  word_t b_offset, j_addr, b_addr, pc;
  
  // pc device
  modport npcl (
    input   j_offset, b_offset, pc,
    output  j_addr, b_addr
  );

  // testbench
  modport tb (
    input    j_addr, b_addr,
    output   j_offset, b_offset, pc
  );

endinterface

`endif // NPCL_IF_VH
