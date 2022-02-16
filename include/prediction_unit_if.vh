`ifndef PREDICTION_UNIT_IF_VH
`define PREDICTION_UNIT_IF_VH

// typedefs
`include "cpu_types_pkg.vh"

interface prediction_unit_if;
  // import types
  import cpu_types_pkg::*;
 
  word_t pred_branch, pc, b_offset;
  logic pred_control, pred_success, pred_fail;
  pcsrc_t PCSrc;
  

  // request unit device
  modport pu (
    input   pc, PCSrc, pred_success, pred_fail, b_offset,
    output  pred_control, pred_branch
  );

  // testbench
  modport tb (
    input    pred_control, pred_branch,
    output   pc, PCSrc, pred_success, pred_fail, b_offset
  );

endinterface

`endif //PREDICTION_UNIT_IF_VH
