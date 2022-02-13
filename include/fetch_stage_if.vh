`ifndef FETCH_STAGE_IF_VH
`define FETCH_STAGE_IF_VH

// typedefs
`include "cpu_types_pkg.vh"

interface fetch_stage_if;
  // import types
  import cpu_types_pkg::*;

  fetch_latch_t out;
  logic stall, pc_control, pc_en;
  word_t nxt_pc;

  // decode stage device
  modport fs (
    input   stall, pc_en, pc_control, nxt_pc,
    output  out
  );

endinterface

`endif //FETCH_STAGE_IF_VH
