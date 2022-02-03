`ifndef PC_IF_VH
`define PC_IF_VH

// typedefs
`include "cpu_types_pkg.vh"

interface pc_if;
  // import types
  import cpu_types_pkg::*;

  pcsrc_t PCSrc;
  logic [ADDR_W-1:0] j_offset;
  word_t b_offset, jr_addr, iaddr;
  
  // pc device
  modport pc (
    input   PCSrc, j_offset, b_offset, jr_addr,
    output  iaddr
  );

  // testbench
  modport tb (
    input    iaddr,
    output   PCSrc, j_offset, b_offset, jr_addr 
  );

endinterface

`endif // PC_IF_VH
