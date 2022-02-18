`ifndef PC_IF_VH
`define PC_IF_VH

// typedefs
`include "cpu_types_pkg.vh"

interface pc_if;
  // import types
  import cpu_types_pkg::*;

  logic pc_control, pc_en, pred_control, flush;
  word_t iaddr, nxt_pc, pred_branch;
  
  // pc device
  modport pc (
    input   pc_control, nxt_pc, pc_en, pred_control, pred_branch, flush,
    output  iaddr
  );

  // testbench
  modport tb (
    input    iaddr,
    output   pc_control, nxt_pc, pc_en, pred_control, pred_branch, flush
  );

endinterface

`endif // PC_IF_VH
