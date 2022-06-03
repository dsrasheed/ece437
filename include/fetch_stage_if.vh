`ifndef FETCH_STAGE_IF_VH
`define FETCH_STAGE_IF_VH

// typedefs
`include "cpu_types_pkg.vh"
`include "datapath_types_pkg.vh"

interface fetch_stage_if;
  // import types
  import cpu_types_pkg::*;
  import datapath_types_pkg::*;

  fetch_latch_t out;
  logic pc_control, ihit, pred_control, flush;
  word_t nxt_pc, instr, pred_branch;
  cpu_tracker_t track_out;

  // decode stage device
  modport fs (
    input   ihit, pc_control, nxt_pc, instr, pred_control, pred_branch, flush,
    output  out, track_out
  );

endinterface

`endif //FETCH_STAGE_IF_VH
