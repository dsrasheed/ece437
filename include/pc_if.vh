`ifndef PC_IF_VH
`define PC_IF_VH

// typedefs
`include "cpu_types_pkg.vh"

interface pc_if;
  // import types
  import cpu_types_pkg::*;

  logic pc_control;
  word_t nxt_pc;
  
  // pc device
  modport pc (
    input   pc_control, nxt_pc,
    output  iaddr
  );

  // testbench
  modport tb (
    input    iaddr,
    output   pc_control, nxt_pc
  );

endinterface

`endif // PC_IF_VH
