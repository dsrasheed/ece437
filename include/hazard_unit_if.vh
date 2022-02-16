`ifndef HAZARD_UNIT_IF_VH
`define HAZARD_UNIT_IF_VH

// typedefs
`include "cpu_types_pkg.vh"
`include "datapath_types_pkg.vh"

interface hazard_unit_if;
  // import types
  import cpu_types_pkg::*;
  import datapath_types_pkg::*;
 
  word_t exec_wsel;
  pcsrc_t PCSrc;
  regbits_t rs, rt;
  pred_t br_pred_result;
  logic zero, flush, pred_taken, taken, insert_nop, exec_MemRd;

  // hazard unit device
  modport hu (
    input   PCSrc, zero, pred_taken, taken, exec_MemRd, rs, rt, exec_wsel,
    output  insert_nop, br_pred_result, flush
  );

  // testbench
  modport tb (
    input    insert_nop, br_pred_result, flush,
    output   PCSrc, zero, pred_taken, taken, exec_MemRd, rs, rt, exec_wsel
  );

endinterface

`endif //HAZARD_UNIT_IF_VH
