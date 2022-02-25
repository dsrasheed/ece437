`ifndef PREDICTION_UNIT_IF_VH
`define PREDICTION_UNIT_IF_VH

// typedefs
`include "cpu_types_pkg.vh"
`include "datapath_types_pkg.vh"


interface prediction_unit_if;
  // import types
  import cpu_types_pkg::*;
  import datapath_types_pkg::*;
 
  word_t pred_branch, pc_decode, pc_mem, b_offset;
  logic pred_control;
  pred_t pred_result;
  pcsrc_t PCSrc;
  

  // prediction unit device
  modport pu (
    input   pc_decode, pc_mem, PCSrc, pred_result, b_offset,
    output  pred_control, pred_branch
  );

  // testbench
  modport tb (
    input    pred_control, pred_branch,
    output   pc_decode, pc_mem, PCSrc, pred_result, b_offset
  );

endinterface

`endif //PREDICTION_UNIT_IF_VH
