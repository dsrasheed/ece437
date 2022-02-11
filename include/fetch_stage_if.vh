`ifndef DECODE_STAGE_IF_VH
`define DECODE_STAGE_IF_VH

// typedefs
`include "cpu_types_pkg.vh"

interface decode_stage_if;
  // import types
  import cpu_types_pkg::*;

  fetch_latch_t out;
  logic stall, pc_control, ihit;
  word_t nxt_pc, imemaddr, imemload;

  // decode stage device
  modport fs (
    input   stall, imemload, ihit, pc_control, nxt_pc,
    output  out, imemaddr
  );

endinterface

`endif //DECODE_STAGE_IF_VH
